import 'package:dsrummy/Utlilities/App_Text/App_Text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../Utlilities/AppButton/ButtonRummy.dart';
import '../../Utlilities/AppColors/color_constant.dart';
import '../../Utlilities/Mediaquery/Mediaquery.dart';

class Finish extends StatefulWidget {
  const Finish({Key? key}) : super(key: key);

  @override
  State<Finish> createState() => _FinishState();
}

class _FinishState extends State<Finish> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ColorConstant.apptheme,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.orange, width: 3),
          borderRadius: BorderRadius.all(Radius.circular(6.0))),
      content: Container(
          height: AppSize.height(context, 35),
          width: AppSize.width(context, 60),
          // decoration:
          //     BoxDecoration(border: Border.all(color: Colors.orange, width: 3)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: AppSize.height(context, 0.5),
              ),
              AppText(
                "FINISH",
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              AppText(
                "Are you sure you want to Finish the Game?",
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
              SizedBox(
                height: AppSize.height(context, 2.5),
              ),
              SizedBox(
                height: AppSize.height(context, 0.5),
              ),
              Container(
                height: AppSize.height(context, 11),
                width: AppSize.width(context, 60),
                color: ColorConstant.darkmerron,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    buttonRummy(
                      width: AppSize.width(context, 25),
                      height: AppSize.height(context, 8),
                      child: AppText("Yes"),
                      color: ColorConstant.gren,
                    ),
                    buttonRummy(
                      width: AppSize.width(context, 25),
                      height: AppSize.height(context, 8),
                      child: AppText("NO"),
                      color: ColorConstant.gray300,
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }
}
