import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'body_part.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CameraFolderScreen(),
    );
  }
}

class CameraFolderScreen extends StatefulWidget {
  const CameraFolderScreen({super.key});

  @override
  State<CameraFolderScreen> createState() => _CameraFolderScreenState();
}

class _CameraFolderScreenState extends State<CameraFolderScreen> {
  List<AssetPathEntity> imageAssets = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _requestPermissionsAndFetchAssets();
  }

  Future<void> _requestPermissionsAndFetchAssets() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      _fetchAssets();
    } else {
      setState(() {
        isLoading = false;
      });
      _showPermissionDeniedMessage(); // 권한이 거부되면 사용자에게 알리기
    }
  }

  void _showPermissionDeniedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('스토리지 접근 권한이 필요합니다.')),
    );
  }

  Future<void> _fetchAssets() async {
    List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
    );

    // 각 앨범의 이름을 출력합니다.
    for (var album in albums) {
      if (kDebugMode) {
        print('앨범 명: ${album.name}');
      }
    }

    setState(() {
      imageAssets = albums;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '휴대폰 사진 앨범',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
      ),
      body: ListView.builder(
        itemCount: imageAssets.length,
        itemBuilder: (context, index) {
          final album = imageAssets[index];
          return ListTile(
            title: Text(
              album.name,
              style: const TextStyle(fontSize: 12),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BodyPart(album: album),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
