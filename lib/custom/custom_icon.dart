// custom_icon.dart
import 'package:flutter/material.dart';

class CustomIcon {
  static Widget getIcon(IconData iconData, String iconName, Function onPress,
      {Color color = Colors.black, double iconSize = 15.0}) {
    return InkWell(
        onTap: () => onPress(),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          SizedBox(
              height: 20,
              width: 30,
              child: Icon(iconData, size: iconSize, color: color)),
          Text(iconName, style: TextStyle(fontSize: 8, color: color))
        ]));
  }
}
