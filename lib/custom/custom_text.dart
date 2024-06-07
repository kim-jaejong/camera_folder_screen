import 'package:flutter/material.dart';

typedef CustomFunction = void Function()?;

class CustomTextButton extends StatelessWidget {
  final String text;
  final CustomFunction onPressedFunction;

  const CustomTextButton({
    required this.text,
    this.onPressedFunction,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressedFunction,
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blueAccent.shade100,
        disabledForegroundColor: Colors.grey.withOpacity(0.1),
        // 버튼이 disabled 상태일 때의 색상
        side: const BorderSide(color: Colors.black, width: 0.3),
        // 버튼의 테두리 설정
        shape: const RoundedRectangleBorder(
          // 버튼의 모양 설정
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
      ),
      child: Text(text, style: const TextStyle(fontSize: 12)),
    );
  }
}
