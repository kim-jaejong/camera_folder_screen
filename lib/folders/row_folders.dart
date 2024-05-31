// row_folders.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'folder_select.dart';
import 'assets_manager.dart';

class RowFolders extends StatefulWidget {
  const RowFolders({super.key});

  @override
  State<RowFolders> createState() => _RowFoldersState();
}

class _RowFoldersState extends State<RowFolders> {
  List<AssetPathEntity> imageAssets = [];
  bool isLoading = true;
  late AssetsManager assetsManager;
  final ValueNotifier<int> selectedIndex = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    assetsManager = AssetsManager(context);
    _fetchAssets();
  }

  Future<void> _fetchAssets() async {
    try {
      imageAssets = await assetsManager.requestPermissionsAndFetchAssets();
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
    return Column(
      children: [
        FolderSelect(imageAssets: imageAssets),
      ],
    );
  }
}
