// assets_manager.dart
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

class AssetsManager {
  final BuildContext context;

  AssetsManager(this.context);

  Future<List<AssetPathEntity>> requestPermissionsAndFetchAssets() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      return fetchAssets();
    } else {
      showPermissionDeniedMessage();
      return Future.error('Permission Denied');
    }
  }

  void showPermissionDeniedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('스토리지 접근 권한이 필요합니다.')),
    );
  }

  Future<List<AssetPathEntity>> fetchAssets() async {
    List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
    );
    return albums;
  }
}
