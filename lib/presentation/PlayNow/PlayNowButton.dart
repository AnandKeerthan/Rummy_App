import 'dart:async';

import 'package:dsrummy/App_Export/app_export.dart';
import 'package:dsrummy/Constance/AppConst.dart';
import 'package:dsrummy/Storage/ProfileData.dart';
import 'package:dsrummy/Utlilities/AppButton/ButtonRummy.dart';
import 'package:dsrummy/Utlilities/AppColors/color_constant.dart';
import 'package:dsrummy/Utlilities/Toast/ToastMessage.dart';
import 'package:dsrummy/api_service/Remote/Network/ApiEndPoints.dart';
import 'package:dsrummy/presentation/GetProfile_Screen/ViewModel/GetProfileVm.dart';
import 'package:dsrummy/presentation/PlanPackage/PlanPackage.dart';
import 'package:dsrummy/socketsDetails/WebSocketStream.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class PlayNowButton extends StatefulWidget {
  bool? fourPlayer;
  PlayNowButton({Key? key, this.fourPlayer = false}) : super(key: key);

  @override
  State<PlayNowButton> createState() => _PlayNowButtonState();
}

class _PlayNowButtonState extends State<PlayNowButton> {
  late IO.Socket socket;
  WebSocketStream webSocketStream = WebSocketStream();
  GetProfileVM getProfileVM = GetProfileVM();

  @override
  void initState() {
    socket = IO.io(ApiEndPoints().baseUrl,
        IO.OptionBuilder().setTransports(['websocket']).build());
    Future.delayed(Duration(milliseconds: 1000), () {
      socketFetch();
    });
    Timer.periodic(AppConst.balanceUpdateDuration, (timer) {
      socketFetch();
    });

    connectToServer();
    super.initState();
  }

  socketFetch() {
    if (getProfileVM
            .ffeaturedProductsModelModel.data?.data?.user?.userAddress !=
        null) {
      socket.emit("sendWalletAmount", {
        "walletAddress": getProfileVM
            .ffeaturedProductsModelModel.data?.data?.user?.userAddress
      });
      socket.on("receviceAmount", (response) {
        if (response["userId"] ==
            getProfileVM.ffeaturedProductsModelModel.data?.data?.user?.sId) {
          webSocketStream.addResponse(response);
        }
      });
    }
  }

  void connectToServer() {
    socket.onConnect((data) => print('Connection established'));
    socket.onConnectError((data) => print('Connect Error: $data'));
    socket.onDisconnect((data) => print('Socket.IO server disconnected'));
  }

  @override
  Widget build(BuildContext context) {
    getProfileVM = context.watch<GetProfileVM>();
    return StreamBuilder(
        stream: webSocketStream.getResponse,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return buttonRummy(
              onPressed: () {
                if (getProfileVM.ffeaturedProductsModelModel.data?.data?.user
                        ?.userStatus ==
                    false) {
                  Get.snackbar("User Status",
                      "Your account is disabled. Please contact admin",
                      snackPosition: SnackPosition.TOP,
                      duration: const Duration(seconds: 2),
                      backgroundColor: AppColors.red,
                      margin: const EdgeInsets.all(10),
                      colorText: Colors.white);
                } else if (widget.fourPlayer == true) {
                  ToastCommon.message("Coming Soon");
                } else {
                  if (snapshot.data["walletAmount"] >= 0.001) {
                    Navigator.of(context)
                        .push(
                      MaterialPageRoute(
                        builder: (context) =>
                            PlanPackage(fourPlayer: widget.fourPlayer ?? false),
                      ),
                    )
                        .then((value) {
                      SystemChrome.setPreferredOrientations([
                        DeviceOrientation.portraitUp,
                      ]);
                    });
                  } else {
                    ToastCommon.errorMessage("Insufficient Balance!");
                  }
                }
              },
              height: AppSize.height(context, 3.5),
              width: AppSize.width(context, 28),
              color: ColorConstant.gren,
              //color: Colors.lightGreen,
              child: AppText(
                "PLAY NOW",
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: ColorConstant.white,
              ),
            );
          }
          return buttonRummy(
            onPressed: () async {
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              var status = prefs.getBool("Loginstatus") ?? false;
              if (status == false) {
                ToastCommon.errorMessage("Please login to continue!");
              } else {
                ToastCommon.message("Please Wait!");
              }
            },
            height: AppSize.height(context, 3.5),
            width: AppSize.width(context, 28),
            color: ColorConstant.gren,
            //color: Colors.lightGreen,
            child: AppText(
              "PLAY NOW",
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: ColorConstant.white,
            ),
          );
        });
  }
}
