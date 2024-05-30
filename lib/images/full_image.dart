import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class FullImage extends StatelessWidget {
  final AssetEntity asset;

  const FullImage({
    required this.asset,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('전체 이미지'),
      ),
      body: Center(
        child: FutureBuilder<Uint8List?>(
          future: asset.originBytes,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data != null) {
              return Image.memory(snapshot.data!, fit: BoxFit.contain);
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
