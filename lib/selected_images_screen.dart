import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:camera_folder_screen/image_tile.dart';

class SelectedImagesScreen extends StatelessWidget {
  final Map<AssetEntity, ValueNotifier<bool>> selectedImages;

  const SelectedImagesScreen({
    required this.selectedImages,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final selectedAssets = selectedImages.entries
        .where((entry) => entry.value.value)
        .map((entry) => entry.key)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('선택된 사진'),
      ),
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
            onSelectedChanged: (bool isSelected) {},
          );
        },
      ),
    );
  }
}
