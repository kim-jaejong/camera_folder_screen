import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:share_plus/share_plus.dart';
import '../custom/custom_icon.dart';
//import '../folders/row_folders.dart';
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

  void _showDlg(List<XFile> xFiles) {
    // 공유 기능을 다이얼로그로 구현
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('공유'),
          content: const Text('선택된 사진을 공유하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              child: const Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('공유'),
              onPressed: () async {
                Navigator.of(context).pop();
                await Share.shareXFiles(xFiles, text: '선택된 사진을 보냅니다!');
              },
            ),
          ],
        );
      },
    );
  }

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
              CustomIcon.getIcon(Icons.move_down, '이동', () {}),
              CustomIcon.getIcon(Icons.sort, color: Colors.redAccent, '정렬', () {
                setState(() {
                  final sortedImages = selectedImages.keys.toList();
                  sortedImages.sort((a, b) {
                    final aIsSelected = selectedImages[a]?.value ?? false;
                    final bIsSelected = selectedImages[b]?.value ?? false;
                    if (aIsSelected != bIsSelected) {
                      return bIsSelected ? 1 : -1;
                    }
                    return b.createDateTime.compareTo(a.createDateTime);
                  });
                  final sortedSelectedImages =
                      <AssetEntity, ValueNotifier<bool>>{};
                  for (final asset in sortedImages) {
                    sortedSelectedImages[asset] = selectedImages[asset]!;
                  }
                  selectedImages.clear();
                  selectedImages.addAll(sortedSelectedImages);
                });
              }),
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
              CustomIcon.getIcon(Icons.folder, '폴더', () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => const RowFolders()));
              }),
              CustomIcon.getIcon(Icons.share, '공유', () async {
                List<XFile> xFiles = [];
                for (var asset in selectedImages.keys) {
                  if (selectedImages[asset]!.value) {
                    var file = await asset.file;
                    xFiles.add(XFile(file!.path));
                    print('파일경로 ${file.path}');
                  }
                }
                print('파일 길이 : ${xFiles.length}');
                _showDlg(xFiles);
              }),
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
          crossAxisSpacing: 2.0,
          mainAxisSpacing: 2.0,
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
