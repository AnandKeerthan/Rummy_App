import 'package:dsrummy/App_Export/app_export.dart';
import 'package:dsrummy/Utlilities/AppColors/color_constant.dart';
import 'package:dsrummy/Utlilities/Images/image_constant.dart';
import 'package:dsrummy/Utlilities/Mediaquery/Mediaquery.dart';
import 'package:dsrummy/presentation/Login_Screen/View/loginScreen_View.dart';
import 'package:dsrummy/presentation/UserScreen/View/YesPopForDeleteAccount.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:confetti/confetti.dart';

class DeleteAccountPopUP extends StatefulWidget {
  DeleteAccountPopUP({Key? key}) : super(key: key);

  @override
  State<DeleteAccountPopUP> createState() => _DeleteAccountPopUPState();
}

class _DeleteAccountPopUPState extends State<DeleteAccountPopUP> {
  bool agree = false;

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
    return WillPopScope(
      onWillPop: () async => true,
      child: AlertDialog(
        backgroundColor: ColorConstant.apptheme,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.orange, width: 3),
            borderRadius: BorderRadius.all(Radius.circular(6.0))),
        content: Container(
            height: AppSize.height(context, 25),
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
                Center(
                  child: AppText(
                    "Delete Account",
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: ColorConstant.ResultText,
                  ),
                ),
                SizedBox(
                  height: AppSize.height(context, 2.5),
                ),
                AppText(
                  "Deleting your account will permanently erase  your records with us and you will also loose all of your DS Coins.",
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: ColorConstant.ResultText,
                ),
                AppText(
                  "Kindly withdraw all of your DS Coin from your account balance before attempting to delete your account.",
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: ColorConstant.ResultText,
                ),
                SizedBox(
                  height: AppSize.height(context, 1),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      agree = !agree;
                    });
                  },
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.checkmark_rectangle_fill,
                        color: agree == true ? ColorConstant.gren : Colors.grey,
                      ),
                      SizedBox(
                        width: AppSize.width(context, 1),
                      ),
                      AppText(
                        "I'm aware that I'll lose my Balance andMy DS coins can\nnot be recovered.",
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        textAlign: TextAlign.justify,
                        color: ColorConstant.ResultText,
                      )
                    ],
                  ),
                )
              ],
            )),
        actions: [
          agree == true
              ? InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return YesDeleteAccountPopUP();
                      },
                    );
                  },
                  child: buttonRummy(
                      borderRadius: BorderRadius.circular(15),
                      color: ColorConstant.gren,
                      //height: 40,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AppText(
                          "Proceed to delete my account",
                          color: ColorConstant.white,
                        ),
                      )),
                )
              : SizedBox(),
          SizedBox(
            width: AppSize.width(context, 2),
          ),
          // buttonRummy(
          //     color: ColorConstant.darkmerron,
          //     height: 30,
          //     width: 100,
          //     onPressed: () {
          //       Navigator.pop(context);
          //     },
          //     child: AppText(
          //       "NO",
          //       color: ColorConstant.white,
          //     ))
        ],
      ),
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
