// ignore_for_file: unused_import

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomDefaultButton extends StatelessWidget {
  final double height;
  final double width;
  final Color color;
  final String title;
  final TextStyle titleStyle;

  const CustomDefaultButton({
    Key? key,
    required this.height,
    required this.width,
    required this.color,
    required this.title,
    required this.titleStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(8), color: color),
      child: Center(
        child: Text(
          title,
          style: titleStyle,
        ),
      ),
    );
  }
}
