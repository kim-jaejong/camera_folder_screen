// row_folders.dart
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import '../custom/custom_text.dart';
import 'assets_manager.dart';
import 'folder_select/select_item_folder/stages.dart';

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
    return Column(children: [
//        FolderSelect(imageAssets: imageAssets),
      SizedBox(
          height: 30,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: imageAssets.length,
              itemBuilder: (context, index) {
                final album = imageAssets[index];
                return SizedBox(
                    width: 80,
                    child: CustomTextButton(
                        text: album.name,
                        onPressedFunction: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Stages(album: album),
                              )); //push
                        } //onPressedFunction
                        ));
              })),
    ]);
  }
}
