import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:camera_folder_screen/grid_part.dart';
import 'package:camera_folder_screen/header_part.dart';

class BodyPart extends StatefulWidget {
  final AssetPathEntity album;

  const BodyPart({super.key, required this.album});

  // 선택된 사진의 개수를 추적

  @override
  State<BodyPart> createState() => _BodyPartState();
}

class _BodyPartState extends State<BodyPart> {
  List<AssetEntity> images = [];
  bool isLoading = true;
  String albumName = '';
  final ValueNotifier<int> selectedCount = ValueNotifier<int>(0);
  final Map<AssetEntity, ValueNotifier<bool>> selectedImages = {}; // 선택 이미지 추적

  @override
  void initState() {
    super.initState();
    _fetchImages();
  }

  Future<void> _fetchImages() async {
    int totalImages = await widget.album.assetCountAsync; //  앨범에 있는 이미지의 총 갯수
    List<AssetEntity> assets =
        await widget.album.getAssetListPaged(page: 0, size: totalImages);
    setState(() {
      images = assets;
      isLoading = false;
      albumName = widget.album.name; // 폴더 이름 저장
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(albumName),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
        children: [
          Expanded(
            flex: 2, // 대표 이미지가 더 큰 공간을 차지하도록 설정
            child: images.isNotEmpty
                ? HeaderPart(
                    albumName: albumName,
                    imageAssets: images,
                    selectedCount: selectedCount,
                    selectedImages: selectedImages,
                  )
                : const Center(child: Text("이미지가 없습니다.")),
          ),
          Expanded(
            flex: 7, // 나머지 이미지 목록
            child: GridPart(
              imageAssets: images,
              selectedImages: selectedImages,
              selectedCount: selectedCount,
            ),
          ),
        ],
      ),
    );
  }
}
