import 'package:dsrummy/Utlilities/AppColors/color_constant.dart';
import 'package:dsrummy/Utlilities/Images/image_constant.dart';
import 'package:dsrummy/Utlilities/Mediaquery/Mediaquery.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:confetti/confetti.dart';

import '../../Utlilities/AppButton/ButtonRummy.dart';
import '../../Utlilities/App_Text/App_Text.dart';

class Winner extends StatefulWidget {
  dynamic snapshotData;
  Winner({Key? key, required this.snapshotData}) : super(key: key);

  @override
  State<Winner> createState() => _WinnerState();
}

class _WinnerState extends State<Winner> {
  @override
  void initState() {
    super.initState();
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 10));
    _controllerCenter.play();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void dispose() {
    _controllerCenter.dispose();

    super.dispose();
  }

  late ConfettiController _controllerCenter;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        backgroundColor: ColorConstant.apptheme,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.orange, width: 3),
            borderRadius: BorderRadius.all(Radius.circular(6.0))),
        content: Container(
            height: AppSize.height(context, 65),
            width: AppSize.width(context, 60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  child: Image.asset(
                    ImageConstant.cong,
                    //height: AppSize.height(context, 20),
                    width: AppSize.width(context, 40),
                  ),
                ),
                SizedBox(
                  height: AppSize.height(context, 2.5),
                ),
                AppText(
                  "You have won the game",
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: ColorConstant.ResultText,
                ),
                AppText(
                  "Why shouldn't you play again to potentially win a prize?",
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: ColorConstant.ResultText,
                ),
                Row(
                  children: [],
                )
              ],
            )),
        actions: [
          buttonRummy(
              color: ColorConstant.darkmerron,
              height: 30,
              width: 100,
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: AppText(
                "Okay",
                color: ColorConstant.white,
              ))
        ],
      ),
    );
  }
}
