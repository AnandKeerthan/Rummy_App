// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class AppText extends StatefulWidget {
  final String data;
  FontWeight? fontWeight;
  double? fontSize;
  Color? color;
  final TextDecoration? decoration;
  final double? letterSpacing;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  AppText(@required this.data,
      {Key? key,
      this.fontWeight = FontWeight.normal,
      this.style,
      this.fontSize = 16,
      this.color,
      this.decoration,
      this.textAlign,
      this.overflow,
      this.letterSpacing,
      String? fontFamily})
      : super(key: key);

  @override
  State<AppText> createState() => _AppTextState();
}

class _AppTextState extends State<AppText> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.data,
      textAlign: widget.textAlign ?? TextAlign.left,
      style: widget.style ??
          TextStyle(
              decoration: widget.decoration,
              color: widget.color ?? Colors.black,
              fontFamily: "appFont",
              fontSize: widget.fontSize,
              letterSpacing: widget.letterSpacing,
              overflow: widget.overflow,
              fontWeight: widget.fontWeight),
      overflow: widget.overflow,
    );
  }
}

class AppTextNumber extends StatefulWidget {
  final String data;
  FontWeight? fontWeight;
  double? fontSize;
  Color? color;
  final TextDecoration? decoration;
  final double? letterSpacing;

  final TextAlign? textAlign;
  final TextOverflow? overflow;
  AppTextNumber(@required this.data,
      {Key? key,
      this.fontWeight = FontWeight.normal,
      this.fontSize = 16,
      this.color,
      this.decoration,
      this.textAlign,
      this.overflow,
      this.letterSpacing,
      String? fontFamily})
      : super(key: key);

  @override
  State<AppTextNumber> createState() => _AppTextNumberState();
}

class _AppTextNumberState extends State<AppTextNumber> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.data,
      textAlign: widget.textAlign ?? TextAlign.left,
      style: TextStyle(
          decoration: widget.decoration,
          color: widget.color ?? Colors.black,
          fontFamily: "appFont",
          fontSize: widget.fontSize,
          letterSpacing: widget.letterSpacing,
          overflow: widget.overflow,
          fontWeight: widget.fontWeight),
      overflow: widget.overflow,
    );
  }
}
