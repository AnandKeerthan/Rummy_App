import 'dart:async';
import 'dart:convert';

import 'package:dsrummy/Constance/AppConst.dart';
import 'package:dsrummy/Utlilities/textConstant/text_constants.dart';
import 'package:dsrummy/app_export/app_export.dart';
import 'package:dsrummy/presentation/GetProfile_Screen/ViewModel/GetProfileVm.dart';
import 'package:dsrummy/presentation/PaymentScreen/PaymentList.dart';
import 'package:dsrummy/presentation/PlayNow/PlayNow.dart';
import 'package:dsrummy/presentation/PlayNow/PlayNowButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Lobby extends StatefulWidget {
  const Lobby({Key? key}) : super(key: key);

  @override
  State<Lobby> createState() => _LobbyState();
}

class _LobbyState extends State<Lobby> with TickerProviderStateMixin {
  // WalletBalanceModel walletBalanceModel = WalletBalanceModel();
  //
  // Future<WalletBalanceModel> fetchStations() async {
  //   var client = http.Client();
  //
  //   if (walletBalanceModel.result == null) {
  //     final response = await client.get(Uri.parse(
  //         'https://bkcscan.io/api?module=account&action=eth_get_balance&address=${walletAddress.$}'));
  //
  //     if (response.statusCode == 200) {
  //       setState(() {
  //         walletBalanceModel =
  //             WalletBalanceModel.fromJson(jsonDecode(response.body));
  //       });
  //       return WalletBalanceModel.fromJson(jsonDecode(response.body));
  //     } else {
  //       throw Exception('Failed to load stations');
  //     }
  //   } else {
  //     return walletBalanceModel;
  //   }
  // }

  late IO.Socket socket;
  WebSocketStream webSocketStream = WebSocketStream();
  WebSocketStream onlineUser = WebSocketStream();
  GetProfileVM getProfileVM = GetProfileVM();

  String userId = "";

  @override
  void initState() {
    socket = IO.io(ApiEndPoints().baseUrl,
        IO.OptionBuilder().setTransports(['websocket']).build());
    Future.delayed(Duration(milliseconds: 1000), () {
      socketFetch();
      setState(() {
        userId =
            getProfileVM.ffeaturedProductsModelModel.data?.data?.user?.sId ??
                "";
      });
    });
    Timer.periodic(AppConst.balanceUpdateDuration, (timer) {
      socketFetch();
    });
    // fetchStations();

    connectToServer();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    _tabController = TabController(
      length: 1,
      vsync: this,
    );
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

  dynamic hexaToNumber(String hex) {
    hex = hex.contains("Balance") ? "0x0" : hex;
    final hexWithoutPrefix = hex.startsWith('0x') ? hex.substring(2) : hex;
    int val = int.parse(
        hexWithoutPrefix.length > 16
            ? hexWithoutPrefix.substring(0, 15)
            : hexWithoutPrefix,
        radix: 16);
    return (val / 1e18);
  }

  // final flutterWebViewPlugin = FlutterWebviewPlugin();

  @override
  void dispose() {
    super.dispose();
    // flutterWebViewPlugin.dispose();
  }

  // void deposit() async {
  //   // Replace with your MetaMask URL
  //   String recipientAddress = '0x0f3fA528f6d768694ab855C2bbb7F11794D5bF47';
  //   double amountInEth = 10000000000000000;
  //
  //   String metaMaskUrl =
  //       'https://metamask.app.link/ethereum:send?to=$recipientAddress&value=$amountInEth';
  //
  //   if (await canLaunchUrl(Uri.parse(metaMaskUrl))) {
  //     await launchUrl(
  //       Uri.parse(metaMaskUrl),
  //       // mode: LaunchMode.externalApplication,
  //     );
  //   }
  // }

  TabController? _tabController;
  int changeIndex = 0;

  bool fourPlayer = false;
  bool points = true;
  bool pool = false;
  bool deals = false;

  @override
  Widget build(BuildContext context) {
    getProfileVM = context.watch<GetProfileVM>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: ColorConstant.apptheme,
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          buttonRummy(
            width: 120,
            height: 35,
            color: ColorConstant.gren,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PaymentScreen(),
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  ImageConstant.currency,
                  height: 25,
                ),
                AppText(
                  "ADD CASH",
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          SizedBox(
            width: 5,
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            Container(
              height: AppSize.height(context, 8),
              width: MediaQuery.of(context).size.width,
              color: ColorConstant.darkmerron,
            ),
            SizedBox(
              height: AppSize.height(context, 7),
            ),
            Container(
                height: AppSize.height(context, 5),
                width: AppSize.width(context, 50),
                decoration: AppDecoration.RummyBox,
                child: AppStyle.rummy),
            Container(
              height: AppSize.height(context, 6),
              width: AppSize.width(context, 100),
              decoration: BoxDecoration(
                color: ColorConstant.gray300,
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      child: Container(
                          height: AppSize.height(context, 5),
                          width: AppSize.width(context, 45),
                          decoration: BoxDecoration(
                              color: points
                                  ? ColorConstant.white
                                  : ColorConstant.gray400,
                              borderRadius: BorderRadiusStyle.boxradius),
                          child: Center(
                              child: AppText(
                            "cash",
                            fontSize: 12,
                            color:
                                points ? ColorConstant.apptheme : Colors.black,
                          ))),
                      onTap: () {
                        setState(() {
                          points = true;
                          pool = false;
                          deals = false;
                        });
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          pool = true;

                          points = false;
                          deals = false;
                        });
                      },
                      child: Container(
                          height: AppSize.height(context, 5),
                          width: AppSize.width(context, 45),
                          decoration: BoxDecoration(
                              color: pool
                                  ? ColorConstant.white
                                  : ColorConstant.gray400,
                              borderRadius: BorderRadiusStyle.boxradius),
                          child: Center(
                              child: AppText(
                            "practice",
                            fontSize: 12,
                            color: pool ? ColorConstant.apptheme : Colors.black,
                          ))),
                    ),
                    // GestureDetector(
                    //   onTap: () {
                    //     setState(() {
                    //       deals = true;
                    //       pool = false;
                    //       points = false;
                    //     });
                    //   },
                    //   child: Container(
                    //       height: AppSize.height(context, 5),
                    //       width: AppSize.width(context, 30),
                    //       decoration: BoxDecoration(
                    //           color: deals
                    //               ? ColorConstant.white
                    //               : ColorConstant.gray400,
                    //           borderRadius: BorderRadiusStyle.boxradius),
                    //       child: Center(
                    //           child: AppText(
                    //         textConstants.deals,
                    //         fontSize: 12,
                    //         color:
                    //             deals ? ColorConstant.apptheme : Colors.black,
                    //       ))),
                    // ),
                  ],
                ),
              ),
            ),
            points
                ? Cash()
                : pool
                    ? practice()
                    : SizedBox()
          ],
        ),
      ),
      // floatingActionButton: Align(
      //   alignment: Alignment.bottomCenter,
      //   child: Row(
      //     crossAxisAlignment: CrossAxisAlignment.center,
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       AppText(
      //         "online players:",
      //         color: ColorConstant.gray300,
      //         fontSize: 12,
      //       ),
      //       StreamBuilder(
      //           stream: onlineUser.getResponse,
      //           builder: (context, snapshot) {
      //             if (snapshot.hasData) {
      //               return AppText(
      //                 snapshot.data.toString(),
      //                 color: ColorConstant.gray300,
      //                 fontSize: 12,
      //               );
      //             }
      //             return AppText(
      //               "0",
      //               color: ColorConstant.gray300,
      //               fontSize: 12,
      //             );
      //           }),
      //     ],
      //   ),
      //   // child: AppText(
      //   //   "online players:57155",
      //   //   color: ColorConstant.gray300,
      //   //   fontSize: 12,
      //   // ),
      // ),
    );
  }

  Widget Cash() {
    return Container(
      height: AppSize.height(context, 55),
      // color: Colors.orange,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                SizedBox(
                  height: AppSize.height(context, 1),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // CircleAvatar(
                    //   radius: 15,
                    //   backgroundColor: ColorConstant.gray300,
                    //   child: Image.asset(ImageConstant.help, height: 15),
                    // ),
                    SizedBox(
                      width: AppSize.width(context, 10),
                    ),
                  ],
                ),
                SizedBox(
                  height: AppSize.height(context, 4),
                ),
                AppText(
                  "Select Players",
                  color: ColorConstant.black,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                PlayerSelectesboxStatus(),
                SizedBox(
                  height: AppSize.height(context, 3.5),
                ),
                PlayNowButton(fourPlayer: fourPlayer),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //------------------------------------------------------PlayerBox 2 or 4 -------------------------------//

  Widget PlayerSelectesboxStatus() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: DefaultTabController(
        length: 1,
        child: Column(
          children: <Widget>[
            Container(
              // color: Colors.yellowAccent,
              // margin: const EdgeInsets.only(top: 17),
              height: AppSize.height(context, 5.5),
              width: AppSize.width(context, 25),
              decoration: BoxDecoration(
                  color: ColorConstant.gray300,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4),
                    bottomLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                    bottomRight: Radius.circular(4),
                  )),
              child: TabBar(
                  controller: _tabController,
                  isScrollable: false,
                  unselectedLabelStyle: TextStyle(color: ColorConstant.black),
                  labelStyle: TextStyle(color: ColorConstant.white),
                  indicatorSize: TabBarIndicatorSize.tab,
                  physics: const NeverScrollableScrollPhysics(),
                  indicator: _tabController!.index == 0
                      ? BoxDecoration(
                          color: ColorConstant.apptheme,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4),
                            bottomLeft: Radius.circular(4),
                          ))
                      : BoxDecoration(
                          color: ColorConstant.apptheme,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(4),
                            bottomRight: Radius.circular(4),
                          )),
                  onTap: (v) {
                    setState(() {
                      changeIndex = _tabController!.index;
                      fourPlayer = changeIndex == 1;
                    });
                  },
                  tabs: [
                    Tab(
                      child: AppText(
                        "2",
                        color: _tabController!.index == 0
                            ? ColorConstant.white
                            : Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  //------------------------------------------------------ PlayButton -------------------------------//

  // Widget PlaynowButton() {
  //   return buttonRummy(
  //     onPressed: () {
  //       Navigator.of(context)
  //           .push(
  //         MaterialPageRoute(
  //           builder: (context) => PlayNow(playerStatus: fourPlayer),
  //         ),
  //       )
  //           .then((value) {
  //         SystemChrome.setPreferredOrientations([
  //           DeviceOrientation.portraitUp,
  //         ]);
  //       });
  //     },
  //     height: AppSize.height(context, 4.5),
  //     width: AppSize.width(context, 40),
  //     color: ColorConstant.gren,
  //     //color: Colors.lightGreen,
  //     child: AppText(
  //       "PLAY NOW",
  //       fontWeight: FontWeight.w500,
  //       color: ColorConstant.white,
  //     ),
  //   );
  // }

  //---------------------------------------------------------------------------------------//

  Widget practice() {
    return Container(
      height: AppSize.height(context, 55),
      // color: Colors.orange,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                SizedBox(
                  height: AppSize.height(context, 1),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // CircleAvatar(
                    //   radius: 15,
                    //   backgroundColor: ColorConstant.gray300,
                    //   child: Image.asset(ImageConstant.help, height: 15),
                    // ),
                    SizedBox(
                      width: AppSize.width(context, 10),
                    ),
                  ],
                ),
                SizedBox(
                  height: AppSize.height(context, 4),
                ),
                // AppText(
                //   "Select Players",
                //   color: ColorConstant.black,
                //   fontSize: 13,
                //   fontWeight: FontWeight.w500,
                // ),
                // PlayerSelectesboxStatus(),
                SizedBox(
                  height: AppSize.height(context, 3.5),
                ),
                buttonRummy(
                  onPressed: () {
                    Navigator.of(context)
                        .push(
                      MaterialPageRoute(
                        builder: (context) =>
                            PlayNow(playerStatus: false, amount: 0, cpu: true),
                      ),
                    )
                        .then((value) {
                      SystemChrome.setPreferredOrientations([
                        DeviceOrientation.portraitUp,
                      ]);
                    });
                  },
                  height: AppSize.height(context, 3.5),
                  width: AppSize.width(context, 45),
                  color: ColorConstant.gren,
                  //color: Colors.lightGreen,
                  child: AppText(
                    "PLAY WITH SYSTEM",
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: ColorConstant.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
