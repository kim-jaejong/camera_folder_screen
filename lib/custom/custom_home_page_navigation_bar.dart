// bottom_navigation_bar.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomHomePageNavigationBar extends StatelessWidget {
  final ValueNotifier<int> selectedIndex;

  const CustomHomePageNavigationBar({required this.selectedIndex, super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      currentIndex: selectedIndex.value,
      onTap: (index) {
        selectedIndex.value = index;
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
    );
  }
}
