import 'package:flutter/material.dart';

import '../folders/row_folders.dart';
import 'custom_icon.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isHomeScreen; // 시작 화면인지 아닌지를 나타내는 변수

  const CustomAppBar(
      {required this.title, this.isHomeScreen = false, super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: isHomeScreen
          ? CustomIcon.getIcon(Icons.menu, () {
              Scaffold.of(context).openDrawer();
            })
          : CustomIcon.getIcon(Icons.arrow_back, () {
              Navigator.pop(context);
            }),
      title: Row(
//        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // const Icon(Icons.camera_alt),
          const SizedBox(width: 20),
          Text(title, style: const TextStyle(fontSize: 10)),
//          const RowFolders(),
        ],
      ),
      actions: [
        CustomIcon.getIcon(Icons.shopping_cart, () {
          // Navigator.pushNamed(context, '/cart');
        }),
        const SizedBox(width: 16),
      ],
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(0.5),
        child: Divider(thickness: 0.5, height: 0.5, color: Colors.black),
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
