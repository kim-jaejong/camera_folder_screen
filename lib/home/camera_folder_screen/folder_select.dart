import 'package:camera_folder_screen/custom/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'folder_select/select_item_folder/select_item_folder.dart';

class FolderSelect extends StatefulWidget {
  final List<AssetPathEntity> imageAssets;

  const FolderSelect({required this.imageAssets, super.key});

  @override
  State<FolderSelect> createState() => _FolderSelectState();
}

class _FolderSelectState extends State<FolderSelect> {
  @override
  Widget build(BuildContext context) {
    return
        // Padding(
        //   padding: const EdgeInsets.symmetric(vertical: 50),
        SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.imageAssets.length,
              itemBuilder: (context, index) {
                final album = widget.imageAssets[index];
                return SizedBox(
                  width: 80,
                  child: Card(
                    child: CustomTextButton(
                      text: album.name,
                      onPressedFunction: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SelectItemFolder(album: album), //   --->
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ));
  }
}
// return ListTile(
//   title: CustomTextButton(
//     text: album.name,
//     onPressedFunction: () {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) =>
//               SelectItemFolder(album: album), //   --->
//         ),
//       );
//     },
//   ),
// );
//    },
//  );
