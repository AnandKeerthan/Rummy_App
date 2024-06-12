import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:dsrummy/app_export/app_export.dart';
import 'package:dsrummy/presentation/Guest/GetRegisterGuest/ViewModel/GetRegisterGuestViewModel.dart';
import 'package:dsrummy/presentation/PlayNow/PlayNow.dart';
import 'package:dsrummy/presentation/PlayNow/PlayNowButton.dart';
import 'package:dsrummy/presentation/RegisterScreen/View/RegisterScreen.dart';
import 'package:provider/provider.dart';

class BeforeLoginUser extends StatefulWidget {
  const BeforeLoginUser({Key? key}) : super(key: key);

  @override
  State<BeforeLoginUser> createState() => _BeforeLoginUserState();
}

class _BeforeLoginUserState extends State<BeforeLoginUser> {
  bool close = false;
  GetGusestRegisterVM gusestRegisterVM = GetGusestRegisterVM();
  @override
  void initState() {
    Provider.of<GetGusestRegisterVM>(context, listen: false)
        .fetchRegisterGuest(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    gusestRegisterVM = context.watch<GetGusestRegisterVM>();
    print(
        "${gusestRegisterVM.getRegisterGuestModel.data?.data?.userAddress.toString() ?? ""}");
    return ConnectivityScreenWrapper(
      positionOnScreen: PositionOnScreen.TOP,
      message: "Check Your Internet Connection",
      height: MediaQuery.of(context).viewPadding.top,
      disableInteraction: false,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: ColorConstant.apptheme,
          title: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 25,
                  width: 45,
                  child: Image.asset(
                    ImageConstant.userIcons,
                  ),
                ),
                SizedBox(
                  height: 1,
                ),
                AppText(
                  "Guest",
                  //"${gusestRegisterVM.getRegisterGuestModel.data?.data?.userAddress.toString() ?? ""}",
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: ColorConstant.white,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // AppText(
                  //   (walletAddress.$ ?? "").contains("@")
                  //       ? CommonFunctions.maskedEmail(walletAddress.$!)
                  //       : CommonFunctions.maskedAddress(walletAddress.$),
                  //   color: Colors.white,
                  //   overflow: TextOverflow.ellipsis,
                  // ),
                  // StreamBuilder(
                  //     stream: webSocketStream.getResponse,
                  //     builder: (context, snapshot) {
                  //       if (snapshot.hasData) {
                  //         return AppText(
                  //           "Bal: " +
                  //               snapshot.data["walletAmount"].toStringAsFixed(4),
                  //           color: Colors.white,
                  //           overflow: TextOverflow.ellipsis,
                  //         );
                  //       }
                  //       return AppText(
                  //         "Bal: 0.0000",
                  //         color: Colors.white,
                  //         overflow: TextOverflow.ellipsis,
                  //       );
                  //     }),
                ],
              ),
            ),
          ],
          // title: Column(
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     SizedBox(
          //       height: 25,
          //       width: 45,
          //       child: Image.asset(
          //         ImageConstant.person,
          //       ),
          //     ),
          //     Row(
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         AppText(
          //           'Online: ',
          //           color: Colors.white,
          //           fontSize: 12,
          //           fontWeight: FontWeight.w400,
          //         ),
          //         // StreamBuilder(
          //         //     stream: onlineUser.getResponse,
          //         //     builder: (context, snapshot) {
          //         //       if (snapshot.hasData) {
          //         //         return AppText(
          //         //           snapshot.data.toString(),
          //         //           color: Color(0xFFFFC600),
          //         //           fontSize: 12,
          //         //           fontWeight: FontWeight.w400,
          //         //         );
          //         //       }
          //         //       return AppText(
          //         //         "0",
          //         //         color: Color(0xFFFFC600),
          //         //         fontSize: 12,
          //         //         fontWeight: FontWeight.w400,
          //         //       );
          //         //     }),
          //       ],
          //     ),
          //   ],
          // ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              close == true
                  ? SizedBox()
                  : Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: 60,
                        width: AppSize.width(context, 90),
                        decoration: BoxDecoration(
                          color: ColorConstant.apptheme.withOpacity(0.5),
                          border: Border.all(color: Colors.white, width: 0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Image.asset(
                                      "assets/images/money.png",
                                    ),
                                  ),
                                  SizedBox(
                                    width: AppSize.width(context, 2),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppText(
                                        'Upon completing Sign Up you\'ll be',
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                      AppText(
                                        'rewarded with 100 DS coins',
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                      AppText(
                                        'On first Register',
                                        color: Colors.yellow,
                                        fontSize: 10,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    child: Container(
                                      height: 30,
                                      width: 100,
                                      child: Center(
                                        child: AppText(
                                          "Register",
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        color: Color(0xffF5591F),
                                        border: Border.all(
                                            color: Colors.white, width: 0.2),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                RegisterScreen(),
                                          ),
                                          (route) => false);
                                    },
                                  ),
                                  SizedBox(
                                    width: AppSize.width(context, 2),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        close = true;
                                      });
                                    },
                                    child: Icon(
                                      Icons.clear,
                                      color: Colors.yellow,
                                      size: 20,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                      "My Profile",
                      fontWeight: FontWeight.w400,
                    ),
                    Row(
                      children: [
                        buttonRummy(
                          onPressed: () {
                            Navigator.of(context)
                                .push(
                              MaterialPageRoute(
                                builder: (context) => PlayNow(
                                    playerStatus: false, amount: 0, cpu: true),
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
                        //PlaynowButton(),
                        SizedBox(
                          width: 3,
                        ),
                        //   AddcashButton()
                      ],
                    )
                  ],
                ),
              ),
              Container(
                height: AppSize.height(context, 0.2),
                width: MediaQuery.of(context).size.width,
                color: ColorConstant.darkmerron,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8, top: 18),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(-0.00, 1.00),
                      end: Alignment(0, -1),
                      colors: [Color(0xFFF5F5F5), Colors.white],
                    ),
                  ),
                  height: 45,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterScreen(),
                          ));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                          "Identity Verification",
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: AppSize.width(context, 2),
                            ),
                            AppText(
                              "(+100 DS Coins)",
                              color: AppColors.green,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: ColorConstant.gray300,
                              size: 27,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
