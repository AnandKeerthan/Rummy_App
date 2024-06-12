// ignore_for_file: prefer_const_constructors
import 'package:dsrummy/app_export/app_export.dart';
import 'package:pinput/pinput.dart';

import 'package:flutter/material.dart';

import '../AppColors/AppColors.dart';

BoxDecoration containerBgDecoration() =>
    const BoxDecoration(color: Color(0xff111613)
        //0xff1A191F
        //     gradient: LinearGradient(
        //   colors: [
        //     Color(0xff092a18),
        //     Color(0xff020024),
        //     Color(0xff11172b),
        //     Color(0xff082314),
        //   ],
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        // )
        );

///Order Cancel Decoration
BoxDecoration orderCancelDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(16),
    gradient: LinearGradient(colors: [
      Colors.white.withOpacity(0.1),
      Colors.white.withOpacity(0.5),
    ]));
BoxDecoration centerBoxDecoration = BoxDecoration(
  color: AppColors.white,
  borderRadius: BorderRadius.circular(2),
);

BoxDecoration redBoxDecoration = BoxDecoration(
  color: AppColors.red,
  borderRadius: BorderRadius.circular(5),
);
BoxDecoration greenBoxDecoration = BoxDecoration(
  color: AppColors.green,
  borderRadius: BorderRadius.circular(5),
);
BoxDecoration circleBorder = BoxDecoration(
  shape: BoxShape.circle,
  border: Border.all(
    color: Colors.black,
    width: 1.0,
  ),
);

BoxDecoration circleTimeLineBorder = BoxDecoration(
  shape: BoxShape.circle,
  border: Border.all(
    color: AppColors.timeLineGrey,
    width: 1.0,
  ),
);

BoxDecoration circleSelectTimeLineBorder = BoxDecoration(
  shape: BoxShape.circle,
  border: Border.all(
    color: AppColors.primaryColor,
    width: 1.0,
  ),
);

BoxDecoration homeBorder(BuildContext context) {
  return BoxDecoration(
      color: Theme.of(context).canvasColor,
      borderRadius: BorderRadius.circular(5),
      border: Border.all(
        color: Theme.of(context).canvasColor,
        width: 0.3,
      ));
}

BoxDecoration listBox(BuildContext context) {
  return BoxDecoration(
      color: Color(0xffF5591F).withOpacity(0.2),
      borderRadius: BorderRadius.circular(5),
      border: Border.all(
        color: ColorConstant.darkmerron,
        width: 0.3,
      ));
}


BoxDecoration createWhiteBoxDecoration(BuildContext context) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(5),
    color: Theme.of(context).cardColor,
  );
}

final resetPinTheme = (BuildContext context) => PinTheme(
      width: MediaQuery.of(context).size.width,
      height: 44,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(48),
        gradient: LinearGradient(
          colors: [
            Color(0xffF5591F).withOpacity(0.3),
            Color(0xffF5591F).withOpacity(0.3),
          ],
        ),
      ),
      textStyle: TextStyle(
        fontSize: 22,
        color: Colors.white,
      ),
    );
BoxDecoration topViewBgDecoration() => BoxDecoration(
    // gradient: LinearGradient(colors: [
    //   Color.fromRGBO(255, 255, 255, 0.1),
    //   Color.fromRGBO(255, 255, 255, 0.1),
    // ]),
    color: Color(0xffF5591F).withOpacity(0.2),
    borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50)));

class BorderRadiusStyle {
  static BorderRadius boxradius = BorderRadius.only(
    topLeft: Radius.circular(10),
    topRight: Radius.circular(10),
  );

  static BorderRadius circleBorder23 = BorderRadius.circular(10);
}

class AppDecoration {
  static BoxDecoration get RummyBox => BoxDecoration(
        color: ColorConstant.apptheme,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      );

  static BoxDecoration get poolboxes => BoxDecoration(
      color: ColorConstant.white, borderRadius: BorderRadiusStyle.boxradius);
  static BoxDecoration get dealboxes => BoxDecoration(
      color: ColorConstant.white, borderRadius: BorderRadiusStyle.boxradius);
}
