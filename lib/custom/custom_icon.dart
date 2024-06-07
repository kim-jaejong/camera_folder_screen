// custom_icon.dart
import 'package:flutter/material.dart';

class CustomIcon {
  static Widget getIcon(IconData iconData, String iconName, Function onPress,
      {Color color = Colors.black, double iconSize = 20.0}) {
    return InkWell(
        onTap: () => onPress(),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          SizedBox(
              height: 25,
              width: 40,
              child: Icon(iconData, size: iconSize, color: color)),
          Text(iconName, style: TextStyle(fontSize: 10, color: color))
        ]));
  }
}
