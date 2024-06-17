// row_folders.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../custom/custom_text.dart';
import '../home/home_page.dart';
import 'folder_select/select_item_folder/stages.dart';

class RowFolders extends StatefulWidget {
  const RowFolders({super.key});

  @override
  State<RowFolders> createState() => _RowFoldersState();
}

class _RowFoldersState extends State<RowFolders> {
  final ValueNotifier<int> selectedIndex = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    var albumProvider = Provider.of<AlbumProvider>(context);
    var imageAssets = albumProvider.albums;
    return Column(children: [
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
                                builder: (context) => Stages(album: album),
                              )); //push
                        } //onPressedFunction
                        ));
              }))
    ]);
  }
}
