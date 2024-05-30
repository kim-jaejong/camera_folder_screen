import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:camera_folder_screen/image_tile.dart';

class GridPart extends StatelessWidget {
  final List<AssetEntity> imageAssets;
  final Map<AssetEntity, ValueNotifier<bool>> selectedImages;
  final ValueNotifier<int> selectedCount;

  const GridPart({
    required this.imageAssets,
    required this.selectedImages,
    required this.selectedCount,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 8,
        crossAxisSpacing: 1.0,
        mainAxisSpacing: 1.0,
      ),
      itemCount: imageAssets.length > 1 ? imageAssets.length - 1 : 0,
      itemBuilder: (context, index) {
        final asset = imageAssets[index];
        final isSelected =
            selectedImages.putIfAbsent(asset, () => ValueNotifier<bool>(false));

        return ImageTile(
          asset: asset,
          isSelected: isSelected,
          onSelectedChanged: (bool isSelected) {
            // 선택 상태가 변경되면 selectedCount를 업데이트
            if (isSelected) {
              selectedCount.value++;
            } else {
              selectedCount.value--;
            }
          },
        );
      },
    );
  }
}
