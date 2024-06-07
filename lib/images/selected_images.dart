import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import '../custom/custom_icon.dart';
import '/images/image_tile.dart';
import 'package:camera_folder_screen/right_drawer.dart';

class SelectedImages extends StatefulWidget {
  final Map<AssetEntity, ValueNotifier<bool>> selectedImages;
  final ValueNotifier<int> selectedCount; // 선택된 사진의 개수를 추적하는 변수 추가

  const SelectedImages({
    required this.selectedImages,
    required this.selectedCount,
    super.key,
  });

  @override
  State<SelectedImages> createState() => _SelectedImagesState();
}

int _counter = 2;

class _SelectedImagesState extends State<SelectedImages> {
  Map<AssetEntity, ValueNotifier<bool>> get selectedImages =>
      widget.selectedImages;

  ValueNotifier<int> get selectedCount => widget.selectedCount;

  @override
  Widget build(BuildContext context) {
    final selectedAssets = selectedImages.entries
        .where((entry) => entry.value.value)
        .map((entry) => entry.key)
        .toList();

    return Scaffold(
      endDrawer: const RightDrawer(),
      appBar: AppBar(
        title: Text('선택된 사진(${selectedAssets.length})',
            style: const TextStyle(fontSize: 10)),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomIcon.getIcon(Icons.zoom_in_map, '작게', () {
                if (_counter < 8) {
                  setState(() => _counter++);
                }
              }),
              CustomIcon.getIcon(Icons.zoom_out_map, '크게', () {
                if (_counter > 1) {
                  setState(() => _counter--);
                }
              }),
              CustomIcon.getIcon(Icons.bookmark_add, 'HnPnA', () {
                // Navigator.pushNamed(context, '/cart');
              }),
              //  const SizedBox(width: 1), // 간격 조절
              CustomIcon.getIcon(Icons.delete, '삭제', () {
                // 휴지통 아이콘을 눌렀을 때의 동작을 여기에 작성합니다.
              }),
            ],
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(0.5),
          child: Divider(thickness: 1, height: 0.5, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _counter,
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
