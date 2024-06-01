import 'dart:typed_data';

import 'package:camera_folder_screen/right_drawer.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:camera_folder_screen/folders/row_folders.dart';

//import '../../../custom/custom_text.dart';
import '../../../images/full_image.dart';
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
              }),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(0.5),
          child: Divider(thickness: 0.5, height: 0.5, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start, // 위젯을 위에서부터 정렬
        children: [
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
                          customBorder: const RoundedRectangleBorder(
                              side: BorderSide(color: Colors.black, width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          onTap: selectedCount.value > 0
                              ? () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SelectedImages(
                                        selectedImages: selectedImages,
                                        selectedCount: selectedCount,
                                      ),
                                    ),
                                  );
                                }
                              : null,
                          child: Text('선택된 ${selectedCount.value} 개 사진 보기',
                              style: const TextStyle(fontSize: 10)),
                        ),
                      );
              },
            ),

            const Spacer(), // Spacer 위젯 추가

            IconButton(
              icon: const Icon(Icons.zoom_in_map),
              onPressed: () {
                if (_counter < 8) {
                  setState(() {
                    _counter++;
                  });
                }
              },
            ),
            const SizedBox(width: 10),
            IconButton(
              icon: const Icon(Icons.zoom_out_map),
              onPressed: () {
                if (_counter > 1) {
                  setState(() {
                    _counter--;
                  });
                }
              },
            ),
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
                return GestureDetector(
                  onPanDown: (_) {
                    final wasSelected = isSelected.value;
                    isSelected.value = !wasSelected;
                    if (wasSelected) {
                      selectedCount.value--;
                    } else {
                      selectedCount.value++;
                    }
                  },
                  onPanUpdate: (_) {
                    if (!isSelected.value) {
                      isSelected.value = true;
                      selectedCount.value++;
                    }
                  },
                  onLongPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullImage(
                          asset: asset,
                        ),
                      ),
                    );
                  },
                  child: ValueListenableBuilder<bool>(
                    valueListenable: isSelected,
                    builder: (context, isSelected, _) {
                      return FutureBuilder<Uint8List?>(
                        future: asset.thumbnailData,
                        builder: (context, snapshot) {
                          if (snapshot.data == null) {
                            return Container(color: Colors.grey[300]);
                          }
                          return Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.memory(snapshot.data!, fit: BoxFit.cover),
                              if (isSelected)
                                Positioned(
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                      color: Colors.blue.withOpacity(0.5),
                                      child: const Icon(
                                        Icons.check_circle,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                    )),
                            ],
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
