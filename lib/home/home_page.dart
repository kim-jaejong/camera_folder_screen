// home_page.dart
import '../custom/custom_home_page_navigation_bar.dart';
//import '../custom/custom_text.dart';
//import 'package:flutter/cupertino.dart';
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
  final selectedIndex =
      ValueNotifier<int>(0); // Replace _selectedIndex with a ValueNotifier

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const RightDrawer(),
      appBar: const CustomAppBar(title: '휴대폰 사진 앨범', isHomeScreen: true),
      body: SafeArea(
        child: Column(
          children: [
            const RowFolders(),
            const SizedBox(height: 10),
            Expanded(
              child: ValueListenableBuilder<int>(
                valueListenable: selectedIndex,
                builder: (context, value, child) {
                  return IndexedStack(
                    index: value,
                    children: const [
                      Text('111111111111111'),
                      Text('222222222222222'),
                      Text('3333333333333333'),
                      Text('444444444444444'),
                      Text('555555555555555'),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar:
          CustomHomePageNavigationBar(selectedIndex: selectedIndex), //
    );
  }
}
