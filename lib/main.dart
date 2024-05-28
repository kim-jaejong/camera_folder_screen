import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:camera_folder_screen/header_part.dart';
import 'package:camera_folder_screen/grid_part.dart';

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
  List<AssetEntity> imageAssets = [];
  bool isLoading = true;
  String albumName = ''; // 폴더 이름

  ValueNotifier<int> selectedCount = ValueNotifier<int>(0); // 선택된 사진의 개수를 추적
  final Map<AssetEntity, ValueNotifier<bool>> _selectedImages = {}; // 선택 이미지 추적

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

    int totalImages = await albums[0].assetCountAsync; //  앨범에 있는 이미지의 총 갯수
    List<AssetEntity> images =
        await albums[0].getAssetListPaged(page: 0, size: totalImages);

    setState(() {
      imageAssets = images;
      isLoading = false;
      albumName = albums[0].name; // 폴더 이름 저장
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('휴대폰 사진 앨범', style: TextStyle(fontSize: 18))),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
        children: [
          Expanded(
            flex: 2, // 대표 이미지가 더 큰 공간을 차지하도록 설정
            child: imageAssets.isNotEmpty
                ? HeaderPart(
                    albumName: albumName,
                    imageAssets: imageAssets,
                    selectedCount: selectedCount,
                    selectedImages: _selectedImages, // Add this line
                  )
                : const Center(child: Text("이미지가 없습니다.")),
          ),
          Expanded(
            flex: 5, // 나머지 이미지 목록
            child: GridPart(
              imageAssets: imageAssets,
              selectedImages: _selectedImages,
              selectedCount: selectedCount,
            ),
          ),
        ],
      ),
    );
  }
}
