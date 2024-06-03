import 'package:flutter/material.dart';

class IconRowMenu extends StatelessWidget {
  final int count;
  const IconRowMenu({this.count = 0, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(children: [
        _buildIconMenu(Icons.grid_view, '폴더'),
        _buildIconMenu(Icons.grid_view, '폴더'),
        _buildIconMenu(Icons.grid_view, '폴더'),
      ]),
    );
  }

  Widget _buildIconMenu(IconData icon, String mText) {
    return Container(
      width: 60,
      height: 80,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(icon, size: 30, color: Colors.black87),
        const SizedBox(height: 5),
        Text(mText,
            style: const TextStyle(fontSize: 10, color: Colors.black87)),
      ]),
    );
  }
}
