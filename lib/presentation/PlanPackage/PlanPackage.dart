import 'dart:async';

import 'package:dsrummy/App_Export/app_export.dart';
import 'package:dsrummy/Constance/AppConst.dart';
import 'package:dsrummy/Storage/ProfileData.dart';
import 'package:dsrummy/Utlilities/AppColors/color_constant.dart';
import 'package:dsrummy/Utlilities/Images/image_constant.dart';
import 'package:dsrummy/Utlilities/Toast/ToastMessage.dart';
import 'package:dsrummy/api_service/Remote/Network/ApiEndPoints.dart';
import 'package:dsrummy/presentation/GetProfile_Screen/ViewModel/GetProfileVm.dart';
import 'package:dsrummy/presentation/PlanPackage/Model/PackageListModel.dart';
import 'package:dsrummy/presentation/PlanPackage/ViewModel/PackageListVM.dart';
import 'package:dsrummy/presentation/PlayNow/PlayNow.dart';
import 'package:dsrummy/socketsDetails/WebSocketStream.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class PlanPackage extends StatefulWidget {
  bool fourPlayer;
  PlanPackage({Key? key, required this.fourPlayer}) : super(key: key);

  @override
  State<PlanPackage> createState() => _PlanPackageState();
}

class _PlanPackageState extends State<PlanPackage> {
  late IO.Socket socket;
  WebSocketStream webSocketStream = WebSocketStream();
  WebSocketStream onlineUser = WebSocketStream();
  late PackageListVM packageListVM;

  GetProfileVM getProfileVM = GetProfileVM();

  @override
  void initState() {
    socket = IO.io(ApiEndPoints().baseUrl,
        IO.OptionBuilder().setTransports(['websocket']).build());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GetProfileVM>(context, listen: false).FetchProfile(context);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PackageListVM>(context, listen: false).getPackage(context);
    });
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
      socket.emit("onlineUser");
      socket.on("onlineUserRes", (response) {
        onlineUser.addResponse(response);
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
    packageListVM = context.watch<PackageListVM>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: ColorConstant.darkmerron,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: ColorConstant.white,
          ),
        ),
        title: Image.asset('assets/images/card.png',height: 100,
          width:60),
      ),
      body: Container(
        height: AppSize.height(context, 100),
        width: AppSize.width(context, 100),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImageConstant.bg),
            fit: BoxFit.fill,
          ),
        ),
        child: packageListVM.isLoading
            ? LoadingWidget()
            : Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AppText(
                        "You can choose a package for DS Rummy based on your needs.",
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: ColorConstant.ResultText,
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    SizedBox(
                      height: AppSize.height(context, 1),
                    ),
                    Expanded(
                      child: packageListVM.packageListModel!.message!.isEmpty
                          ? Center(
                              child: Padding(
                              padding: const EdgeInsets.only(bottom: 60),
                              child: AppText(
                                "No packages found...!",
                                color: AppColors.white,
                              ),
                            ))
                          : ListView.builder(
                              itemCount: packageListVM
                                  .packageListModel?.message?.length,
                              itemBuilder: (context, index) {
                                var data = packageListVM
                                    .packageListModel?.message?[index];
                                return data!.status == 0
                                    ? SizedBox()
                                    : Center(
                                        child: Stack(
                                          alignment: Alignment.topLeft,
                                          children: [
                                            Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 38.0),
                                                  child: Container(
                                                    width: AppSize.width(
                                                        context, 85),
                                                    decoration: BoxDecoration(
                                                      color: ColorConstant
                                                          .darkmerron,
                                                      border: Border.all(
                                                        color: ColorConstant
                                                            .yellow
                                                            .withOpacity(0.5),
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  8.0) //                 <--- border radius here
                                                              ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .all(15.0),
                                                            height:
                                                                AppSize.height(
                                                                    context,
                                                                    20),
                                                            width:
                                                                AppSize.width(
                                                                    context,
                                                                    80),
                                                            decoration:
                                                                BoxDecoration(
                                                              image:
                                                                  DecorationImage(
                                                                image: AssetImage(
                                                                    ImageConstant
                                                                        .bg),
                                                                fit:
                                                                    BoxFit.fill,
                                                              ),
                                                              border:
                                                                  Border.all(
                                                                color: ColorConstant
                                                                    .yellow
                                                                    .withOpacity(
                                                                        0.5),
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius.all(
                                                                      Radius.circular(
                                                                          8.0) //                 <--- border radius here
                                                                      ),
                                                            ),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                AppText(
                                                                  data.planName!,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  color: ColorConstant
                                                                      .ResultText,
                                                                ),
                                                                Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    AppText(
                                                                      "Entry Fee : ",
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      color: ColorConstant
                                                                          .ResultText,
                                                                    ),
                                                                    AppText(
                                                                      "${data.amount}",
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      color: ColorConstant
                                                                          .yellow,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          PlaynowButton(data),
                                                          SizedBox(
                                                            height:
                                                                AppSize.height(
                                                                    context,
                                                                    2.5),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 30.0),
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    height: 30,
                                                    width: 30,
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          ColorConstant.yellow
                                                              .withOpacity(0.5),
                                                      radius: 15,
                                                      child: CircleAvatar(
                                                        backgroundColor:
                                                            Colors.black,
                                                        radius: 15,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: AppSize.height(
                                                        context, 4.8),
                                                  ),
                                                  CircleAvatar(
                                                    backgroundColor:
                                                        ColorConstant.yellow
                                                            .withOpacity(0.5),
                                                    radius: 20,
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          Colors.black,
                                                      radius: 18,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Positioned(
                                              left: 45,
                                              top: 10,
                                              child: Container(
                                                height: 75,
                                                width: 10,
                                                decoration: BoxDecoration(
                                                  color: ColorConstant.yellow,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                              }),
                    )
                  ],
                ),
              ),
      ),
    );
  }

  Widget PlaynowButton(Message data) {
    return StreamBuilder(
        stream: webSocketStream.getResponse,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return buttonRummy(
              onPressed: () {
                if (snapshot.data["walletAmount"] >= data.amount) {
                  Navigator.of(context)
                      .push(
                    MaterialPageRoute(
                      builder: (context) => PlayNow(
                        playerStatus: widget.fourPlayer,
                        amount: data.amount,
                      ),
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
              },
              height: AppSize.height(context, 4.8),
              width: AppSize.width(context, 70),
              color: ColorConstant.gren,
              //color: Colors.lightGreen,
              child: AppText(
                "Join",
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: ColorConstant.white,
              ),
            );
          }
          // return SizedBox();
          return buttonRummy(
            onPressed: () {
              if (snapshot.data["walletAmount"] >= data.amount) {
                Navigator.of(context)
                    .push(
                  MaterialPageRoute(
                    builder: (context) => PlayNow(
                      playerStatus: widget.fourPlayer,
                      amount: data.amount,
                    ),
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
            },
            height: AppSize.height(context, 4.8),
            width: AppSize.width(context, 70),
            color: ColorConstant.gren,
            //color: Colors.lightGreen,
            child: AppText(
              "Join",
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: ColorConstant.white,
            ),
          );
        });
  }
}
