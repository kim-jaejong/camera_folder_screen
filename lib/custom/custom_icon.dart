// common_icon_button.dart
import 'package:flutter/material.dart';

class CustomIcon {
  static IconButton getIcon(IconData iconData, Function onPress,
      {Color color = Colors.black, double iconSize = 15.0}) {
    return IconButton(
      icon: Icon(iconData, size: iconSize, color: color),
      onPressed: () => onPress(),
    );
  }
}
