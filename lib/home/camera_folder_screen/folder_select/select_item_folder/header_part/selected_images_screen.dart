import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:camera_folder_screen/image_tile.dart';
import 'package:camera_folder_screen/right_drawer.dart';
import 'package:camera_folder_screen/custom/custom_app_bar.dart';

class SelectedImagesScreen extends StatelessWidget {
  final Map<AssetEntity, ValueNotifier<bool>> selectedImages;
  final ValueNotifier<int> selectedCount; // 선택된 사진의 개수를 추적하는 변수 추가

  const SelectedImagesScreen({
    required this.selectedImages,
    required this.selectedCount, // selectedCount를 인자로 받도록 수정
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final selectedAssets = selectedImages.entries
        .where((entry) => entry.value.value)
        .map((entry) => entry.key)
        .toList();

    return Scaffold(
      endDrawer: const RightDrawer(),
      appBar: const CustomAppBar(title: '선택된 사진'),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 1.0,
          mainAxisSpacing: 1.0,
        ),
        itemCount: selectedAssets.length,
        itemBuilder: (context, index) {
          final asset = selectedAssets[index];
          final isSelected = selectedImages[asset]!;

          return ImageTile(
            asset: asset,
            isSelected: isSelected,
            onSelectedChanged: (bool isSelected) {
              // 선택 상태가 변경되면 selectedCount를 업데이트
              if (isSelected) {
                selectedCount.value++;
              } else {
                selectedCount.value--;
                selectedImages.remove(asset); // 선택 해지된 사진을 selectedImages에서 제거
              }
            },
          );
        },
      ),
    );
  }
}
