// home_page.dart
import '../custom/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../custom/custom_app_bar.dart';
import '../../right_drawer.dart';
import '../folders/row_folders.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const RightDrawer(),
      appBar: const CustomAppBar(title: '휴대폰 사진 앨범', isHomeScreen: true),
      body: Column(
        children: [
          const RowFolders(),
          const SizedBox(height: 10),
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                CustomTextButton(
                  text: '두번째',
                  onPressedFunction: () {},
                ),
                const Text('3333333333333333'),
                const Text('444444444444444'),
                const Text('555555555555555'),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.square_on_square),
            label: '동네생활',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.placemark),
            label: '내 근처',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chat_bubble_2),
            label: '채팅',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
            label: '나의 당근',
          ),
        ],
      ),
    );
  }
}
