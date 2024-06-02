import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../../images/image_tile.dart';
import '../../row_folders.dart';
import '../../../right_drawer.dart';
import '../../../images/selected_images.dart';

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
  final ValueNotifier<int> selectedCount = ValueNotifier<int>(0); // 선택된 갯수 추적
  final Map<AssetEntity, ValueNotifier<bool>> selectedImages = {}; // 선택 이미지 추적

  @override
  void initState() {
    super.initState();
    _fetchImages();
  }

  Future<void> _fetchImages() async {
    List<AssetEntity> assets =
        await widget.album.getAssetListPaged(page: 0, size: 100);
    setState(() {
      images = assets;
      isLoading = false;
      albumName = widget.album.name; // 폴더 이름 저장
    });
  }

  int _counter = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        endDrawer: const RightDrawer(),
        appBar: AppBar(
          title: albumName.isEmpty
              ? const Text('Loading...', style: TextStyle(fontSize: 10))
              : Text('폴더: $albumName(${images.length})',
                  style: const TextStyle(fontSize: 18)),
          actions: [
            IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  // Navigator.pushNamed(context, '/cart');
                })
          ],
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(0.5),
            child: Divider(thickness: 0.5, height: 0.5, color: Colors.black),
          ),
          centerTitle: true,
        ),
        body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          const RowFolders(),
          const SizedBox(height: 10),
          Row(children: [
            ValueListenableBuilder<int>(
              valueListenable: selectedCount,
              builder: (context, count, child) {
                return count == 0
                    ? const Text('선택은 클릭, 전체이미지는 롱 클릭',
                        style: TextStyle(fontSize: 10))
                    : Container(
                        color: Colors.grey[300],
                        padding: const EdgeInsets.all(10),
                        child: InkWell(
                            onTap: selectedCount.value > 0
                                ? () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SelectedImages(
                                                  selectedImages:
                                                      selectedImages,
                                                  selectedCount: selectedCount,
                                                ))); // push 선택된 이미지 목록 보기
                                  }
                                : null,
                            child: Text('선택된 ${selectedCount.value} 개 사진 보기',
                                style: const TextStyle(fontSize: 10))),
                      );
              },
            ),
            const Spacer(), // Spacer 위젯 추가
            IconButton(
                icon: const Icon(Icons.zoom_in_map),
                onPressed: () {
                  if (_counter < 8) {
                    setState(() => _counter++);
                  }
                }),
            const SizedBox(width: 10),
            IconButton(
                icon: const Icon(Icons.zoom_out_map),
                onPressed: () {
                  if (_counter > 1) {
                    setState(() => _counter--);
                  } //if
                })
          ]),
          const SizedBox(height: 10),
          Expanded(
              flex: 9, // 나머지 이미지 목록
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _counter,
                  crossAxisSpacing: 1.0,
                  mainAxisSpacing: 1.0,
                ),
                itemCount: images.length,
                itemBuilder: (context, index) {
                  final asset = images[index];
                  final isSelected = selectedImages.putIfAbsent(
                      asset, () => ValueNotifier<bool>(false));
                  return ImageTile(
                    asset: asset,
                    isSelected: isSelected,
                    onSelectedChanged: (isSelectedNow) {
                      if (isSelectedNow) {
                        selectedCount.value++;
                        selectedImages.putIfAbsent(
                            asset,
                            () => ValueNotifier<bool>(
                                true)); // 이미지를 추가 선택하면 selectedImages에 다시 추가
                      } else {
                        selectedCount.value--;
                        selectedImages.remove(asset); // 선택 해제된 이미지 제거
                      }
                    },
                  );
                },
              ))
        ]));
  }
}
