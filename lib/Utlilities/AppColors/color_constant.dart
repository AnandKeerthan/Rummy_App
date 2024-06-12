import 'dart:ui';
import 'package:flutter/material.dart';

class ColorConstant {
  // static const Color background = Color(0XFFFFFFFF);
  static Color apptheme = fromHex('#650403');

  static Color ResultText = fromHex('#FFDBE9');
  static Color dividerPink = fromHex('#73001A');

  static Color yellow = fromHex('#F0BD0A');

  static Color darkmerron = fromHex('#330A0A');

  static Color gren = fromHex('#3A9400');

  static Color gray400 = fromHex('#CCCCCC');

  static Color gray500 = fromHex('#91979e');

  static Color gray90033 = fromHex('#33131117');

  static Color gray900 = fromHex('#141218');

  static Color gray90001 = fromHex('#1d2129');

  static Color gray300 = fromHex('#D9D9D9');

  static Color whiteA70033 = fromHex('#33ffffff');
  static Color white = Colors.white;
  static Color black = Colors.black;

  static Color whiteA700Cc = fromHex('#ccffffff');

  static Color gray40019 = fromHex('#19c0c0c0');

  static Color whiteA70014 = fromHex('#14ffffff');

  static Color black900 = fromHex('#000000');

  static Color whiteA70019 = fromHex('#19ffffff');

  static Color whiteA700 = fromHex('#ffffff');

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
