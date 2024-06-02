import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'full_image.dart';

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
      onLongPress: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FullImage(
              asset: widget.asset,
            ),
          ),
        );
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          FutureBuilder<Uint8List?>(
            future: widget.asset.thumbnailData,
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return Container(color: Colors.grey[300]);
              }
              return Image.memory(snapshot.data!, fit: BoxFit.cover);
            },
          ),
          ValueListenableBuilder<bool>(
            valueListenable: widget.isSelected,
            builder: (context, isSelected, _) {
              return isSelected
                  ? Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        color: Colors.blue.withOpacity(0.5),
                        child: const Icon(
                          Icons.check_circle,
                          color: Colors.white,
                          size: 15,
                        ),
                      ),
                    )
                  : Container();
            },
          )
        ],
      ),
    );
  }
}
