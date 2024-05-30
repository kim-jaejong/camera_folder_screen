// camera_folder_screen.dart
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
//import 'custom/custom_app_bar.dart';
import 'home/camera_folder_screen/folder_select.dart';
//import 'right_drawer.dart';
import 'home/camera_folder_screen/assets_manager.dart';

class CameraFolderScreen extends StatefulWidget {
  const CameraFolderScreen({super.key});

  @override
  State<CameraFolderScreen> createState() => _CameraFolderScreenState();
}

class _CameraFolderScreenState extends State<CameraFolderScreen> {
  List<AssetPathEntity> imageAssets = [];
  bool isLoading = true;
  late AssetsManager assetsManager; // AssetsManager 인스턴스 생성을 늦춥니다.

  @override
  void initState() {
    super.initState();
    assetsManager =
        AssetsManager(context); // initState에서 AssetsManager 인스턴스를 생성합니다.
    _fetchAssets();
  }

  Future<void> _fetchAssets() async {
    try {
      imageAssets = await assetsManager
          .requestPermissionsAndFetchAssets(); // AssetsManager 클래스 사용
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      endDrawer: const RightDrawer(),
//      appBar: const CustomAppBar(title: '휴대폰 사진 앨범', isHomeScreen: true),
      body: Column(
        children: [
//          const SizedBox(height: 5),
          FolderSelect(imageAssets: imageAssets),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
