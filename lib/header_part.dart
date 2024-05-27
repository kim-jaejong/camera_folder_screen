import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class HeaderPart extends StatelessWidget {
  final String albumName;
  final List<AssetEntity> imageAssets;
  final ValueNotifier<int> selectedCount;

  const HeaderPart({
    required this.albumName,
    required this.imageAssets,
    required this.selectedCount,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
        )
      ],
    );
  }
}
