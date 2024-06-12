import 'package:dsrummy/app_export/app_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WrongDeclare extends StatefulWidget {
  dynamic snapshotData;
  WrongDeclare({Key? key, required this.snapshotData}) : super(key: key);

  @override
  State<WrongDeclare> createState() => _WrongDeclareState();
}

class _WrongDeclareState extends State<WrongDeclare> {
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
    return WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        backgroundColor: ColorConstant.apptheme,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.orange, width: 3),
            borderRadius: BorderRadius.all(Radius.circular(6.0))),
        content: Container(
            height: AppSize.height(context, 60),
            width: AppSize.width(context, 80),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ImageConstant.bg),
                fit: BoxFit.fill,
              ),
            ),
            // decoration:
            //     BoxDecoration(border: Border.all(color: Colors.orange, width: 3)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppText(
                  "You Loss The Game. Try Again",
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: ColorConstant.ResultText,
                ),
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
