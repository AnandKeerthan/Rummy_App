import 'package:dsrummy/App_Export/app_export.dart';
import 'package:dsrummy/Utlilities/AppColors/color_constant.dart';
import 'package:dsrummy/Utlilities/Images/image_constant.dart';
import 'package:dsrummy/Utlilities/Mediaquery/Mediaquery.dart';
import 'package:dsrummy/presentation/DeleteAccount/ViewModel/DeleteAccountVM.dart';
import 'package:dsrummy/presentation/Login_Screen/View/loginScreen_View.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:confetti/confetti.dart';

class YesDeleteAccountPopUP extends StatefulWidget {
  YesDeleteAccountPopUP({Key? key}) : super(key: key);

  @override
  State<YesDeleteAccountPopUP> createState() => _DeleteAccountPopUPState();
}

class _DeleteAccountPopUPState extends State<YesDeleteAccountPopUP> {
  bool agree = false;
  DeleteAccountVM deleteAccountVM = DeleteAccountVM();
  @override
  void initState() {
    super.initState();
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 10));
  }

  @override
  void dispose() {
    _controllerCenter.dispose();

    super.dispose();
  }

  late ConfettiController _controllerCenter;

  @override
  Widget build(BuildContext context) {
    deleteAccountVM = context.watch<DeleteAccountVM>();
    return AlertDialog(
      backgroundColor: ColorConstant.apptheme,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.orange, width: 3),
          borderRadius: BorderRadius.all(Radius.circular(6.0))),
      content: Container(
          height: AppSize.height(context, 10),
          width: AppSize.width(context, 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                    )),
              ),
              SizedBox(
                height: AppSize.height(context, 2.5),
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppText(
                      "Are You Sure? Delete for Account",
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: ColorConstant.ResultText,
                    ),
                  ],
                ),
              ),
            ],
          )),
      actions: [
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buttonRummy(
                  color: ColorConstant.darkmerron,
                  height: 30,
                  width: 100,
                  onPressed: () async {
                    // await clearSharedPreferences();
                    // storeLogInStatus(false);
                    deleteAccountVM.fetchDeteleAccount(context);
                  },
                  child: AppText(
                    "YES",
                    color: ColorConstant.white,
                  )),
              SizedBox(
                width: AppSize.width(context, 2),
              ),
              buttonRummy(
                  color: ColorConstant.darkmerron,
                  height: 30,
                  width: 100,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: AppText(
                    "NO",
                    color: ColorConstant.white,
                  )),
            ],
          ),
        )
      ],
    );
  }

  Future<void> clearSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  void storeLogInStatus(bool loginstatus) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("Loginstatus", loginstatus);
  }

  void storeEmail(String email) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("email", email);
  }
}
