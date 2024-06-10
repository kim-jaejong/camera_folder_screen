// assets_manager.dart
//import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

class AssetsManager {
  bool _isGranted = false;
  AssetsManager();

  Future<List<AssetPathEntity>> requestPermissionsAndFetchAssets() async {
    print('접근 진입');
    var storageStatus = await Permission.storage.request();
    if (storageStatus.isGranted) {
      //&& photosStatus.isGranted) {
      print('접근 허용');
      _isGranted = true;
      return fetchAssets();
    } else {
//      showPermissionDeniedMessage();
      print('접근 불가');
      return Future.error('Permission Denied');
    }
  }

  bool get isGranted => _isGranted;

  // void showPermissionDeniedMessage() {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(content: Text('스토리지 접근 권한이 필요합니다.')),
  //   );
  // }

  Future<List<AssetPathEntity>> fetchAssets() async {
    List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
      // filterOption: FilterOptionGroup(orders: [
      //   const OrderOption(
      //     type: OrderOptionType.createDate,
      //     asc: false,
      //   )
      // ],
    );
    return albums;
  }
}
