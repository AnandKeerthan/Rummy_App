import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

///MediaQuery.sizeOf(context).width,
///MediaQuery.of(context).size.width,

class AppSize {
  static double height(BuildContext context, double value) {
    double height = MediaQuery.of(context).size.height / 100;
    return height * value;
  }

  static double width(BuildContext context, double value) {
    double width = MediaQuery.of(context).size.width / 100;
    return width * value;
  }
}

///Third party package use because its depand on our scree size --->eXAMPLE  MOBILE,TABLET

//package's pubspec.yaml (and run an implicit flutter pub get):
// dependencies:
//   sizer: ^2.0.15

class CustomSizer {
  static double height(BuildContext context, double value) {
    MediaQuery.of(context).size.height / 100;
    return value.h;
  }

  static double width(BuildContext context, double value) {
    double width = MediaQuery.of(context).size.width / 100;
    return width * value;
  }
}
