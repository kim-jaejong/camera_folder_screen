import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:camera_folder_screen/images/image_tile.dart';

class GridPart extends StatefulWidget {
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
  State<GridPart> createState() => _GridPartState();
}

class _GridPartState extends State<GridPart> {
  final int _counter = 6;
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _counter,
        crossAxisSpacing: 1.0,
        mainAxisSpacing: 1.0,
      ),
      itemCount: widget.imageAssets.length, // > 1 ? imageAssets.length - 1 : 0,
      itemBuilder: (context, index) {
        final asset = widget.imageAssets[index];
        final isSelected = widget.selectedImages
            .putIfAbsent(asset, () => ValueNotifier<bool>(false));
        return ImageTile(
          asset: asset,
          isSelected: isSelected,
          onSelectedChanged: (bool isSelected) {
            if (isSelected) {
              widget.selectedCount.value++;
            } else {
              widget.selectedCount.value--;
            }
          },
        );
      },
    );
  }
}
