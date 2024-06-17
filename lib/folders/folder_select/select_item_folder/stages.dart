import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:share_plus/share_plus.dart';
import '../../../custom/custom_icon.dart';
import '../../../images/image_tile.dart';
import '../../row_folders.dart';
import '../../../right_drawer.dart';
import '../../../images/selected_images.dart';

class Stages extends StatefulWidget {
  final AssetPathEntity album;

  const Stages({super.key, required this.album});

  @override
  State<Stages> createState() => _StagesState();
}

class _StagesState extends State<Stages> {
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
    int totalImages = await widget.album.assetCountAsync; //  앨범에 있는 이미지의 총 갯수
    List<AssetEntity> assets = await widget.album.getAssetListPaged(
      page: 0,
      size: totalImages,
    );

    // 이미지를 날짜의 내림차순으로 정렬
    assets.sort((a, b) => b.createDateTime.compareTo(a.createDateTime));

    setState(() {
      images = assets;
      isLoading = false;
      albumName = widget.album.name; // 폴더 이름 저장
    });
  }

  int _counter = 4;

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
    return Scaffold(
      endDrawer: const RightDrawer(),
      appBar: AppBar(
        title: albumName.isEmpty
            ? const Text('Loading...', style: TextStyle(fontSize: 10))
            : Text('$albumName(${images.length})',
                style: const TextStyle(fontSize: 12)),
        actions: [],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(0.5),
          child: Divider(thickness: 0.5, height: 0.5, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        const RowFolders(), // 앨범 선택 화면으로 이동
        const SizedBox(height: 2),
        ValueListenableBuilder<int>(
          valueListenable: selectedCount,
          builder: (context, count, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
//                if (count > 0) ...[
                CustomIcon.getIcon(
                    Icons.remove_red_eye_outlined,
                    color: Colors.redAccent,
                    '선택', () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SelectedImages(
                              selectedImages: selectedImages,
                              selectedCount: selectedCount)));
                }),
                CustomIcon.getIcon(Icons.sort, color: Colors.redAccent, '정렬',
                    () {
                  setState(() {
                    images.sort((a, b) {
                      final aIsSelected = selectedImages[a]?.value ?? false;
                      final bIsSelected = selectedImages[b]?.value ?? false;
                      if (aIsSelected && bIsSelected) {
                        return a.createDateTime.compareTo(b.createDateTime);
                      }
                      return (bIsSelected ? 1 : 0) - (aIsSelected ? 1 : 0);
                    });
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RowFolders()));
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
                //              ],
              ],
            );
          },
        ),
        Expanded(
            flex: 9, // 나머지 이미지 목록
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _counter,
                  crossAxisSpacing: 2.0,
                  mainAxisSpacing: 2.0,
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
                      });
                }))
      ]),
    );
  }
}
