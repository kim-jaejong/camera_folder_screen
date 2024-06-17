// custom_icon.dart
import 'package:flutter/material.dart';

class CustomIcon {
  static Widget getIcon(IconData iconData, String iconName, Function onPress,
      {Color color = Colors.black,
      double iconSize = 20.0,
      bool isEnabled = true}) {
    return InkWell(
        onTap: isEnabled ? () => onPress() : null,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          SizedBox(
              height: 20,
              width: 30,
              child: Icon(iconData,
                  size: iconSize, color: isEnabled ? color : Colors.grey)),
          Text(iconName,
              style: TextStyle(
                  fontSize: 8, color: isEnabled ? color : Colors.grey))
        ]));
  }
}
