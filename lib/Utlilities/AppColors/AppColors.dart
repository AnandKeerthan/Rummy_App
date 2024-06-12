// ignore_for_file: file_names

import 'dart:ui';

import '../../app_export/app_export.dart';

class AppColors {
  static AppColors? _instance;
  factory AppColors() => _instance ??= AppColors._();

  AppColors._();

  static const primaryColor = Color(0xFFf8c702);
  static const white = Colors.white;
  static const orange = Colors.orange;
  static const red = Color(0xFFD21404);
  static const green = Color(0xFF43a046);
  static const black = Colors.black;
  static const dividerGrey = Color(0xFFF5F5F5);
  static const timeLineGrey = Color(0xFFECECEC);

  static const grey = Color(0xFFbfbfbf);
  static const merronRed = Color(0xFF8B0000);

  static const lightGrey = Color(0xFFdfe0e2);
  static const appBarGradient1 = Color(0xFF0793BB);
  static const appBarGradient2 = Color(0xFF62B852);
  static const iceGreenColor = Color(0xFF9fdfcd);
  static const iceDartGreenColor = Color(0xFF3cb898);

  static Color lightGreys(BuildContext context) {
    return Theme.of(context).textTheme.headline2!.color!;
  }

  static Color whiteWithLightGrey(BuildContext context) {
    return Theme.of(context).textTheme.headline3!.color!;
  }

  static Color lightWhiteWithBlack(BuildContext context) {
    return Theme.of(context).textTheme.headline4!.color!;
  }

  static Color greyWithWhite(BuildContext context) {
    return Theme.of(context).textTheme.headline5!.color!;
  }
}
