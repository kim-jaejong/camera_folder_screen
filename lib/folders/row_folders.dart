// row_folders.dart
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import '../custom/custom_text.dart';
import 'assets_manager.dart';
import 'folder_select/select_item_folder/stages.dart';
import 'move/grouped_image_picker.dart';

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
    assetsManager = AssetsManager();
    _fetchAssets();
  }

  Future<void> _fetchAssets() async {
    try {
      imageAssets = await assetsManager.requestPermissionsAndFetchAssets();
      if (assetsManager.isGranted) {
        setState(() {
          isLoading = false;
        });
      } else {
        return;
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return assetsManager.isGranted
        ? Column(children: [
            SizedBox(
                height: 40,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: imageAssets.length,
                    itemBuilder: (context, index) {
                      final album = imageAssets[index];
                      return SizedBox(
                          width: 100,
                          child: CustomTextButton(
                              text: album.name,
                              onPressedFunction: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          Stages(album: album),
                                    )); //push
                              } //onPressedFunction
                              ));
                    }))
          ])
        :
        // CustomTextButton(
        //         text: '앨범 선택',
        //         onPressedFunction: () {
        //           Navigator.push(
        //               context,
        //               MaterialPageRoute(
        //                 builder: (context) => const GroupedImagePicker(),
        //               )); //push
        //         } //onPressedFunction
        //         );
        InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GroupedImagePicker(),
                  )); //push
            },
            child: const SizedBox(
                height: 25,
                child: Text('앨범 선택', style: TextStyle(fontSize: 10))));
  }
}
