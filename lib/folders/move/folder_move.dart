import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PhotoMover(),
    );
  }
}

class PhotoMover extends StatefulWidget {
  const PhotoMover({super.key});

  @override
  State<PhotoMover> createState() => _PhotoMoverState();
}

class _PhotoMoverState extends State<PhotoMover> {
  List<AssetEntity> photos = [];
  Directory? destinationDirectory;

  @override
  void initState() {
    super.initState();
    _initializePhotos();
  }

  Future<void> _initializePhotos() async {
    // final permitted = await PhotoManager.requestPermission();
    // if (!permitted) return;

    // 사진 앨범 가져오기
    List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
      onlyAll: true,
    );
    if (albums.isNotEmpty) {
      List<AssetEntity> photosInAlbum =
          await albums[0].getAssetListPaged(page: 0, size: 100);
      setState(() {
        photos = photosInAlbum;
      });
    }

    // 임시 디렉토리 경로 설정
    Directory tempDir = await getTemporaryDirectory();
    setState(() {
      destinationDirectory = Directory(path.join(tempDir.path, 'destination'));
    });

    // 대상 폴더가 없으면 생성
    if (!(destinationDirectory?.existsSync() ?? false)) {
      destinationDirectory?.createSync(recursive: true);
    }
  }

  Future<void> _movePhotos() async {
    if (destinationDirectory == null) return;

    for (final asset in photos) {
      final file = await asset.file;
      if (file == null) continue;
      final fileName = path.basename(file.path);
      final newFile = File(path.join(destinationDirectory!.path, fileName));
      await file.copy(newFile.path);
      await file.delete();
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Photos moved successfully!')),
    );

    // 업데이트된 사진 리스트 가져오기
    _initializePhotos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Mover'),
      ),
      body: Center(
        child: photos.isEmpty
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: _movePhotos,
                child: const Text('Move Photos'),
              ),
      ),
    );
  }
}
