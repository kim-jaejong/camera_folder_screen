import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:photo_manager/photo_manager.dart';
import 'package:camera_folder_screen/selected_images_screen.dart';

class HeaderPart extends StatelessWidget {
  final String albumName;
  final List<AssetEntity> imageAssets;
  final ValueNotifier<int> selectedCount;
  final Map<AssetEntity, ValueNotifier<bool>> selectedImages;

  const HeaderPart({
    required this.albumName,
    required this.imageAssets,
    required this.selectedCount,
    required this.selectedImages,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white, // 배경색을 흰색으로 설정
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10), // 왼쪽에 20만큼 패딩 추가
              child: Expanded(
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: FutureBuilder<Uint8List?>(
                    future: imageAssets[0].originBytes, // 첫 번째 이미지의 원본 데이터 사용
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.data != null) {
                        return Image.memory(snapshot.data!, fit: BoxFit.cover);
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(albumName,
                    style: const TextStyle(fontSize: 14)), // 폴더 이름 표시
                const SizedBox(height: 8),
                Text('전체 사진 ${imageAssets.length}개',
                    style: const TextStyle(fontSize: 10)), // 이미지 개수 표시
                const SizedBox(height: 8),
                ValueListenableBuilder<int>(
                  valueListenable: selectedCount,
                  builder: (context, count, child) {
                    return SizedBox(
                        height: 30, // 버튼의 높이 설정
                        child: TextButton(
                          onPressed: count > 0
                              ? () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          SelectedImagesScreen(
                                        selectedImages: selectedImages,
                                        selectedCount:
                                            selectedCount, // Add this line
                                      ),
                                    ),
                                  );
                                }
                              : null,
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blueAccent.shade100,
                            disabledForegroundColor:
                                Colors.grey.withOpacity(0.38),
                            // 버튼이 disabled 상태일 때의 색상
                            side:
                                const BorderSide(color: Colors.black, width: 1),
                            // 버튼의 테두리 설정
                            shape: const RoundedRectangleBorder(
                              // 버튼의 모양 설정
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                          ),
                          child: Text('선택된 $count개 사진 보기', // 선택된 사진의 개수 표시
                              style: const TextStyle(fontSize: 10)),
                        ));
                  },
                ),
              ],
            )
          ],
        ));
  }
}
