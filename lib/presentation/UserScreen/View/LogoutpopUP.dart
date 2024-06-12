import 'package:dsrummy/App_Export/app_export.dart';
import 'package:dsrummy/Utlilities/AppColors/color_constant.dart';
import 'package:dsrummy/Utlilities/Images/image_constant.dart';
import 'package:dsrummy/Utlilities/Mediaquery/Mediaquery.dart';
import 'package:dsrummy/presentation/Login_Screen/View/loginScreen_View.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:confetti/confetti.dart';

class LogoutPopUP extends StatefulWidget {
  LogoutPopUP({Key? key}) : super(key: key);

  @override
  State<LogoutPopUP> createState() => _LogoutPopUPState();
}

class _LogoutPopUPState extends State<LogoutPopUP> {
  late IO.Socket socket;

  @override
  void initState() {
    socket = IO.io(ApiEndPoints().baseUrl,
        IO.OptionBuilder().setTransports(['websocket']).build());
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
      onWillPop: () async => false,
      child: AlertDialog(
        backgroundColor: ColorConstant.apptheme,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.orange, width: 3),
            borderRadius: BorderRadius.all(Radius.circular(6.0))),
        content: Container(
            height: AppSize.height(context, 10),
            width: AppSize.width(context, 60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: AppSize.height(context, 2.5),
                ),
                AppText(
                  "Are you Sure!",
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: ColorConstant.ResultText,
                ),
                AppText(
                  "Logout the game?",
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
                      await clearSharedPreferences();
                      storeLogInStatus(false);
                      socket.emit("logoutUser", {"userId": userID.$});
                      if (mounted) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => Login()),
                            (a) => false);
                      }
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
