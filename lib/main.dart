import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CameraFolderScreen(),
    );
  }
}

class CameraFolderScreen extends StatefulWidget {
  const CameraFolderScreen({super.key});

  @override
  State<CameraFolderScreen> createState() => _CameraFolderScreenState();
}

class _CameraFolderScreenState extends State<CameraFolderScreen> {
  List<AssetEntity> imageAssets = [];
  bool isLoading = true;
  String albumName = ''; // 폴더 이름을 저장할 변수 추가

  ValueNotifier<int> selectedCount =
      ValueNotifier<int>(0); // 선택된 사진의 개수를 추적하는 변수 추가

  final Map<AssetEntity, ValueNotifier<bool>> _selectedImages =
      {}; // 선택된 이미지를 추적하는 맵

  Widget _buildGridPart(List<AssetEntity> imageAssets) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 8,
        crossAxisSpacing: 1.0,
        mainAxisSpacing: 1.0,
      ),
      itemCount: imageAssets.length > 1 ? imageAssets.length - 1 : 0,
      itemBuilder: (context, index) {
        final asset = imageAssets[index];
        final isSelected = _selectedImages.putIfAbsent(
            asset, () => ValueNotifier<bool>(false));

        return ImageTile(
          asset: asset,
          isSelected: isSelected,
          onSelectedChanged: (bool isSelected) {
            // 선택 상태가 변경되면 selectedCount를 업데이트
//            setState(() {
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

  Widget _buildHeaderPart(String albumName, List<AssetEntity> imageAssets) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20), // 왼쪽에 20만큼 패딩 추가
          child: Expanded(
            child: SizedBox(
              height: 200,
              child: FutureBuilder<Uint8List?>(
                future: imageAssets[0].originBytes, // 첫 번째 이미지의 원본 데이터 사용

                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.data != null) {
                    return Image.memory(snapshot.data!, fit: BoxFit.contain);
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 텍스트를 오른쪽에 정렬
          children: [
            const SizedBox(height: 8),
            Text(albumName, style: const TextStyle(fontSize: 14)), // 폴더 이름 표시
            const SizedBox(height: 8),
            Text('전체 사진 ${imageAssets.length}개',
                style: const TextStyle(fontSize: 10)), // 이미지 개수 표시
            const SizedBox(height: 8),
            ValueListenableBuilder<int>(
              valueListenable: selectedCount,
              builder: (context, count, child) {
                return Text('선택된 사진 $count개', // 선택된 사진의 개수 표시
                    style: const TextStyle(fontSize: 10));
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _requestPermissionsAndFetchAssets();
  }

  Future<void> _requestPermissionsAndFetchAssets() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      _fetchAssets();
    } else {
      setState(() {
        isLoading = false;
      });
      // 권한이 거부되면 사용자에게 알리기
      _showPermissionDeniedMessage();
    }
  }

  void _showPermissionDeniedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('스토리지 접근 권한이 필요합니다.')),
    );
  }

  Future<void> _fetchAssets() async {
    List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
    );

    int totalImages = await albums[0].assetCountAsync; //  앨범에 있는 이미지의 총 갯수
    List<AssetEntity> images =
        await albums[0].getAssetListPaged(page: 0, size: totalImages);

    setState(() {
      imageAssets = images;
      isLoading = false;
      albumName = albums[0].name; // 폴더 이름 저장
    });
  }

  // Scaffold의 Body 수정 부분
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('카메라 이미지 목록', style: TextStyle(fontSize: 18))),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
        children: [
          Expanded(
            flex: 2, // 대표 이미지가 더 큰 공간을 차지하도록 설정
            child: imageAssets.isNotEmpty
                ? Row(
                    children: [
                      _buildHeaderPart(albumName, imageAssets),
                    ],
                  )
                : const Center(child: Text("이미지가 없습니다.")),
          ),
          // 이미지 그리드 리스트
          Expanded(
            flex: 5, // 나머지 이미지 목록
            child: _buildGridPart(imageAssets),
          ),
        ],
      ),
    );
  }
}

class ImageTile extends StatefulWidget {
  final AssetEntity asset;
  final ValueNotifier<bool> isSelected;
  final ValueChanged<bool> onSelectedChanged; // 선택 상태가 변경될 때 호출될 콜백 추가

  const ImageTile({
    required this.asset,
    required this.isSelected,
    required this.onSelectedChanged, // 콜백을 생성자에서 받음
    super.key,
  });

  @override
  State<ImageTile> createState() => _ImageTileState();
}

class _ImageTileState extends State<ImageTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: (_) {
        final wasSelected = widget.isSelected.value;
        widget.isSelected.value = !wasSelected;
        widget.onSelectedChanged(!wasSelected); // 선택 상태가 변경되면 콜백 호출
      },
      onPanUpdate: (_) {
        if (!widget.isSelected.value) {
          widget.isSelected.value = true;
          widget.onSelectedChanged(true); // 선택 상태가 변경되면 콜백 호출
        }
      },
      onLongPress: () {},
      child: ValueListenableBuilder<bool>(
        valueListenable: widget.isSelected,
        builder: (context, isSelected, _) {
          return FutureBuilder<Uint8List?>(
            future: widget.asset.thumbnailData,
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
  }
}
