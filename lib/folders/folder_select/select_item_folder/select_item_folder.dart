import 'package:camera_folder_screen/custom/custom_app_bar.dart';
import 'package:camera_folder_screen/right_drawer.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:camera_folder_screen/folders/row_folders.dart';
import 'grid_part/grid_part.dart';
import 'header_part/header_part.dart';

class SelectItemFolder extends StatefulWidget {
  final AssetPathEntity album;

  const SelectItemFolder({super.key, required this.album});

  @override
  State<SelectItemFolder> createState() => _SelectItemFolderState();
}

class _SelectItemFolderState extends State<SelectItemFolder> {
  List<AssetEntity> images = [];
  bool isLoading = true;
  String albumName = '';
  final ValueNotifier<int> selectedCount =
      ValueNotifier<int>(0); // 선택된 이미지 갯수 추적
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
      endDrawer: const RightDrawer(),
      appBar: CustomAppBar(title: albumName),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start, // 위젯을 위에서부터 정렬
        children: [
          const RowFolders(),
          const SizedBox(height: 10),
          Expanded(
            flex: 2, // 대표 이미지가 더 큰 공간을 차지하도록 설정
            child: images.isNotEmpty
                ? HeaderPart(
                    albumName: albumName,
                    imageAssets: images,
                    selectedCount: selectedCount,
                    selectedImages: selectedImages,
                  )
                : const Center(child: CircularProgressIndicator()),
          ),
          Expanded(
            flex: 9, // 나머지 이미지 목록
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