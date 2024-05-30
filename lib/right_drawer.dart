import 'package:flutter/material.dart';

class RightDrawer extends StatelessWidget {
  const RightDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: const Text('설정'),
            onTap: () {
              //        Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
