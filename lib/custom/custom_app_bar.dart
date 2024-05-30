import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isHomeScreen; // 시작 화면인지 아닌지를 나타내는 변수

  const CustomAppBar(
      {required this.title, this.isHomeScreen = false, super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: isHomeScreen
          ? IconButton(
              icon: const Icon(Icons.menu), // 메뉴 아이콘으로 변경
              onPressed: () {
                Scaffold.of(context).openDrawer(); // 메뉴 버튼을 누르면 드로어를 엽니다.
              },
            )
          : IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, color: Colors.black),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.shopping_cart),
          onPressed: () {
            // Navigator.pushNamed(context, '/cart');
          },
        ),
        const SizedBox(
          width: 16,
        ),
      ],
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
