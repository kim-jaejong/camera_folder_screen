import 'package:camera_folder_screen/custom/custom_text.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:photo_manager/photo_manager.dart';
import 'selected_images.dart';

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
        color: Colors.white,
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
                Text('폴더명: $albumName',
                    style: const TextStyle(fontSize: 12)), // 폴더 이름 표시
                const SizedBox(height: 8),
                Text('총 ${imageAssets.length}개',
                    style: const TextStyle(fontSize: 10)), // 이미지 개수 표시
                const SizedBox(height: 8),
                ValueListenableBuilder<int>(
                  valueListenable: selectedCount,
                  builder: (context, count, child) {
                    return SizedBox(
                        height: 30, // 버튼의 높이 설정
                        child: count == 0
                            ? const Text('선택은 클릭, 확대는 롱 클릭',
                                style: TextStyle(fontSize: 10))
                            : CustomTextButton(
                                text: '선택된 $count개 사진 보기',
                                onPressedFunction: count > 0
                                    ? () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                SelectedImages(
                                              selectedImages: selectedImages,
                                              selectedCount: selectedCount,
                                            ),
                                          ),
                                        );
                                      }
                                    : null,
                              ));
                  },
                ),
              ],
            )
          ],
        ));
  }
}
