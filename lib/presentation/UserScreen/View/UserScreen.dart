import 'dart:async';
import 'dart:convert';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:dsrummy/Constance/AppConst.dart';
import 'package:dsrummy/Utlilities/AppStyle/app_text_style.dart';
import 'package:dsrummy/Utlilities/Toast/StatusMessages.dart';
import 'package:dsrummy/app_export/app_export.dart';
import 'package:dsrummy/presentation/2FA/ViewModel/2FAViewModel.dart';
import 'package:dsrummy/presentation/GetProfile_Screen/ViewModel/GetProfileVm.dart';
import 'package:dsrummy/presentation/Guest/GetRegisterGuest/ViewModel/GetRegisterGuestViewModel.dart';
import 'package:dsrummy/presentation/Id_Verification/KycVm/KycVm.dart';
import 'package:dsrummy/presentation/PlayNow/PlayNowButton.dart';
import 'package:dsrummy/presentation/RegisterScreen/View/RegisterScreen.dart';
import 'package:dsrummy/presentation/SupportScreen/ViewModel/SupportVM.dart';
import 'package:dsrummy/presentation/UserScreen/View/DeleteAccount.dart';
import 'package:dsrummy/presentation/UserScreen/View/LogoutpopUP.dart';
import 'package:dsrummy/presentation/termsandcondition_screen/privacyPolicy.dart';
import 'package:dsrummy/presentation/termsandcondition_screen/refundPolicy.dart';
import 'package:dsrummy/presentation/termsandcondition_screen/terms&condition.dart';
import 'package:dsrummy/presentation/termsandcondition_screen/withdrawPolicy.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:url_launcher/url_launcher.dart';

class User extends StatefulWidget {
  const User({Key? key}) : super(key: key);

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
  String userId = "";
  late BuildContext ctxt;
  void launchapp() async {
    final Uri url = Uri.parse(
        'https://apps.apple.com/us/app/google-authenticator/id388497605');
    try {
      if (await canLaunch(url.toString())) {
        await launch(url.toString());
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print(e);
    }
  }

  bool isExpanded3 = false;
  bool isExpandedSupport = false;
  bool isExpanded2FA = false;
  bool _autoValidate = false;
  void displaySuccessAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Payment confirmed!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  TFaVM tFaVM = TFaVM();
  GetProfileVM getProfileVM = GetProfileVM();
  GetGusestRegisterVM gusestRegisterVM = GetGusestRegisterVM();
  String? email;
  KycVM viewModel = KycVM();
  SupportVM supportVM = SupportVM();
  @override
  void initState() {
    super.initState();
    socket = IO.io(ApiEndPoints().baseUrl,
        IO.OptionBuilder().setTransports(['websocket']).build());
    // fetchStations();

    viewModel.picker = ImagePicker();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GetProfileVM>(context, listen: false).FetchProfile(context);
      Provider.of<GetGusestRegisterVM>(context, listen: false)
          .fetchRegisterGuest(context);
      supportVM.mail = getProfileVM
              .ffeaturedProductsModelModel.data?.data?.user?.email!
              .toString() ??
          "";

      storeEmail(
          getProfileVM.ffeaturedProductsModelModel.data?.data?.user!.email ??
              "");
    });
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
    print("supportVM.mailsupportVM.mail:${supportVM.mail}");
  }

  late IO.Socket socket;
  WebSocketStream webSocketStream = WebSocketStream();
  WebSocketStream onlineUser = WebSocketStream();

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

  bool nextValidation() {
    return viewModel.file1 &&
        viewModel.file2 &&
        viewModel.nameController.text.isNotEmpty &&
        viewModel.noController.text.isNotEmpty &&
        viewModel.pickedImage != null &&
        viewModel.pickedImage1 != null;
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLoginEnabled() {
    if (_autoValidate) {
      print("#${_autoValidate}");
      // Check _autoValidate before validating the form
      final formState = _formKey.currentState;
      if (formState != null) {
        final isValid = formState.validate();
        if (isValid) {
          formState.save();
          return supportVM.descriptionController.text.isNotEmpty;
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<KycVM>();
    getProfileVM = context.watch<GetProfileVM>();
    tFaVM = context.watch<TFaVM>();
    supportVM = context.watch<SupportVM>();
    supportVM.mail = getProfileVM
            .ffeaturedProductsModelModel.data?.data?.user?.email!
            .toString() ??
        "";
    print("supportVM11.mailsupportVM.mail:${supportVM.mail}");

    print(
        "Inital :; ${getProfileVM.ffeaturedProductsModelModel.data?.data?.user?.email?.toString()}");
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
          leading: Padding(
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
                  getProfileVM
                          .ffeaturedProductsModelModel.data?.data?.user?.email
                          ?.toString() ??
                      "",
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
                  AppText(
                    getProfileVM.ffeaturedProductsModelModel.data == null
                        ? ""
                        : CommonFunctions.maskedEmail(getProfileVM
                            .ffeaturedProductsModelModel
                            .data!
                            .data!
                            .user!
                            .email!
                            .toString()),
                    color: Colors.white,
                    overflow: TextOverflow.ellipsis,
                  ),
                  StreamBuilder(
                      stream: webSocketStream.getResponse,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return AppText(
                            "Bal: " +
                                snapshot.data["walletAmount"]
                                    .toStringAsFixed(4),
                            color: Colors.white,
                            overflow: TextOverflow.ellipsis,
                          );
                        }
                        return AppText(
                          "Bal: 0.0000",
                          color: Colors.white,
                          overflow: TextOverflow.ellipsis,
                        );
                      }),
                ],
              ),
            ),
          ],
          title: Image.asset('assets/images/card.png', height: 100, width: 60),
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
          //         StreamBuilder(
          //             stream: onlineUser.getResponse,
          //             builder: (context, snapshot) {
          //               if (snapshot.hasData) {
          //                 return AppText(
          //                   snapshot.data.toString(),
          //                   color: Color(0xFFFFC600),
          //                   fontSize: 12,
          //                   fontWeight: FontWeight.w400,
          //                 );
          //               }
          //               return AppText(
          //                 "0",
          //                 color: Color(0xFFFFC600),
          //                 fontSize: 12,
          //                 fontWeight: FontWeight.w400,
          //               );
          //             }),
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
                      PlayNowButton(),
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
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    getProfileVM.ffeaturedProductsModelModel.data?.data?.user
                                ?.kycVerifyStatus ==
                            1
                        ? Get.snackbar("Kyc Verification",
                            "please wait for admin approval",
                            snackPosition: SnackPosition.TOP,
                            duration: const Duration(seconds: 6),
                            backgroundColor: AppColors.red,
                            margin: const EdgeInsets.all(10),
                            colorText: Colors.white)
                        : getProfileVM.ffeaturedProductsModelModel.data?.data
                                    ?.user?.kycVerifyStatus ==
                                2
                            ? Get.snackbar("Kyc Verification",
                                "your KYC is already verified",
                                snackPosition: SnackPosition.TOP,
                                duration: const Duration(seconds: 6),
                                backgroundColor: AppColors.green,
                                margin: const EdgeInsets.all(10),
                                colorText: Colors.white)
                            : getProfileVM.ffeaturedProductsModelModel.data
                                        ?.data?.user?.kycVerifyStatus ==
                                    3
                                ? {
                                    Get.snackbar(
                                        "Kyc Rejected",
                                        getProfileVM.ffeaturedProductsModelModel
                                                .data?.data!.user?.reason
                                                .toString() ??
                                            "",
                                        snackPosition: SnackPosition.TOP,
                                        duration: const Duration(seconds: 6),
                                        backgroundColor: AppColors.red,
                                        margin: const EdgeInsets.all(10),
                                        colorText: Colors.white),
                                    isExpanded3 = !isExpanded3,
                                  }
                                : isExpanded3 = !isExpanded3;
                  });
                },
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
                      setState(() {
                        getProfileVM.ffeaturedProductsModelModel.data?.data
                                    ?.user?.kycVerifyStatus ==
                                1
                            ? Get.snackbar("Kyc Verification",
                                "please wait for admin approval",
                                snackPosition: SnackPosition.TOP,
                                duration: const Duration(seconds: 2),
                                backgroundColor: AppColors.red,
                                margin: const EdgeInsets.all(10),
                                colorText: Colors.white)
                            : getProfileVM.ffeaturedProductsModelModel.data
                                        ?.data?.user?.kycVerifyStatus ==
                                    2
                                ? Get.snackbar("Kyc Verification",
                                    "your KYC is already verified",
                                    snackPosition: SnackPosition.TOP,
                                    duration: const Duration(seconds: 2),
                                    backgroundColor: AppColors.green,
                                    margin: const EdgeInsets.all(10),
                                    colorText: Colors.white)
                                : getProfileVM.ffeaturedProductsModelModel.data
                                            ?.data?.user?.kycVerifyStatus ==
                                        3
                                    ? {
                                        Get.snackbar(
                                            "Kyc Rejected",
                                            getProfileVM
                                                    .ffeaturedProductsModelModel
                                                    .data
                                                    ?.data!
                                                    .user
                                                    ?.reason
                                                    .toString() ??
                                                "",
                                            snackPosition: SnackPosition.TOP,
                                            duration:
                                                const Duration(seconds: 2),
                                            backgroundColor: AppColors.red,
                                            margin: const EdgeInsets.all(10),
                                            colorText: Colors.white),
                                        isExpanded3 = !isExpanded3,
                                      }
                                    : isExpanded3 = !isExpanded3;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.security_outlined,
                              size: 20,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            AppText(
                              "Identity Verification",
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                            AppText(
                              getProfileVM.ffeaturedProductsModelModel.data
                                          ?.data?.user?.kycVerifyStatus !=
                                      2
                                  ? "  (+100 DS Coins)"
                                  : "",
                              color: AppColors.green,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            AppText(
                              getProfileVM.ffeaturedProductsModelModel.data
                                          ?.data?.user?.kycVerifyStatus ==
                                      1
                                  ? "Pending"
                                  : getProfileVM
                                              .ffeaturedProductsModelModel
                                              .data
                                              ?.data
                                              ?.user
                                              ?.kycVerifyStatus ==
                                          2
                                      ? "Verified"
                                      : getProfileVM
                                                  .ffeaturedProductsModelModel
                                                  .data
                                                  ?.data
                                                  ?.user
                                                  ?.kycVerifyStatus ==
                                              3
                                          ? "Rejected"
                                          : "",
                              color: getProfileVM.ffeaturedProductsModelModel
                                          .data?.data?.user?.kycVerifyStatus ==
                                      2
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            SizedBox(
                              width: AppSize.width(context, 2),
                            ),
                            Icon(
                              isExpanded3
                                  ? Icons.keyboard_arrow_down
                                  : Icons.keyboard_arrow_up,
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
            ),
            isExpanded3 == true
                ? Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                      right: 8,
                    ),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: AppSize.height(context, 2),
                            ),
                            Container(
                              //  height: AppSize.height(context, 80),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    topLeft: Radius.circular(20)),
                                color: Theme.of(context).cardColor,
                              ),
                              child: Column(
                                children: [
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 16.0,
                                        ),
                                        child: Row(
                                          children: [
                                            AppText(
                                              'Personal Information',
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16.0, bottom: 16, top: 8),
                                        child: Row(
                                          children: [
                                            AppText(
                                                '* Please enter valid information to succeed',
                                                style: redtext),
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _showIdTypeBottomSheet(context);
                                          });
                                        },
                                        child: Container(
                                          child: GestureDetector(
                                            onTap: () {
                                              _showIdTypeBottomSheet(context);

                                              setState(() {
                                                viewModel.pickedImage = null;
                                                viewModel.pickedImage1 = null;
                                                viewModel.nameController
                                                    .clear();
                                                viewModel.noController.clear();
                                              });
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 16.0,
                                                  bottom: 16,
                                                  top: 8,
                                                  right: 16),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  AppText('*ID Type',
                                                      style: greytext),
                                                  Row(
                                                    children: [
                                                      AppText(
                                                          viewModel
                                                                  .selectedIdType ??
                                                              'Please select',
                                                          style: viewModel
                                                                      .selectedIdType !=
                                                                  null
                                                              ? blackpopuptext(
                                                                  context)
                                                              : greytext),
                                                      Icon(
                                                          Icons
                                                              .arrow_forward_ios,
                                                          color:
                                                              AppColors.black)
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 0.3,
                                                color: AppColors.grey)),
                                      ),
                                      if (viewModel.selectedIdType ==
                                          'Driving Licence')
                                        Column(
                                          children: [
                                            ListTile(
                                              title: Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      children: [
                                                        AppText('*Name',
                                                            style: greytext),
                                                        Expanded(
                                                          child: SizedBox(
                                                            width:
                                                                double.infinity,
                                                            child: TextField(
                                                              controller: viewModel
                                                                  .nameController,
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                              decoration:
                                                                  InputDecoration(
                                                                      border: InputBorder
                                                                          .none,
                                                                      enabledBorder: UnderlineInputBorder(
                                                                          borderSide: BorderSide
                                                                              .none), // Remove underline
                                                                      focusedBorder: UnderlineInputBorder(
                                                                          borderSide: BorderSide
                                                                              .none), // Remove underline when focused
                                                                      hintText:
                                                                          'Please type in your name',
                                                                      hintStyle: TextStyle(
                                                                          color: AppColors
                                                                              .lightGrey,
                                                                          fontSize:
                                                                              14)),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 0.3,
                                                      color: AppColors.grey)),
                                            ),
                                            ListTile(
                                              title: Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      children: [
                                                        AppText(
                                                            '*Driving Licence',
                                                            style: greytext),
                                                        Expanded(
                                                          child: SizedBox(
                                                            width:
                                                                double.infinity,
                                                            child: TextField(
                                                              controller: viewModel
                                                                  .noController,
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                              decoration:
                                                                  InputDecoration(
                                                                      border: InputBorder
                                                                          .none,
                                                                      enabledBorder: UnderlineInputBorder(
                                                                          borderSide: BorderSide
                                                                              .none), // Remove underline
                                                                      focusedBorder: UnderlineInputBorder(
                                                                          borderSide: BorderSide
                                                                              .none), // Remove underline when focused
                                                                      hintText:
                                                                          'Driving Licence No.',
                                                                      hintStyle: TextStyle(
                                                                          color: AppColors
                                                                              .lightGrey,
                                                                          fontSize:
                                                                              14)),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 0.3,
                                                      color: AppColors.grey)),
                                            ),
                                            ListTile(
                                              title: Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8.0,
                                                            bottom: 8,
                                                            left: 8),
                                                    child: Row(
                                                      children: [
                                                        AppText(
                                                            '*Licence photo',
                                                            style: greytext),
                                                        SizedBox(
                                                          width: 20,
                                                        ),
                                                        Row(
                                                          children: [
                                                            viewModel.pickedImage !=
                                                                    null
                                                                ? GestureDetector(
                                                                    onTap: () {
                                                                      viewModel
                                                                          .openGallery();

                                                                      print(
                                                                          "!!!${viewModel.pickedImage!.toString()}");
                                                                    },
                                                                    child: Image
                                                                        .file(
                                                                      viewModel
                                                                          .pickedImage!,
                                                                      height:
                                                                          80,
                                                                      width:
                                                                          120,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  )
                                                                : GestureDetector(
                                                                    onTap: () {
                                                                      viewModel
                                                                          .openGallery();

                                                                      print(
                                                                          "!!!${viewModel.pickedImage!.toString()}");
                                                                    },
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .all(
                                                                          4.0),
                                                                      child:
                                                                          Container(
                                                                        decoration:
                                                                            BoxDecoration(border: Border.all(color: AppColors.grey)),
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              4.0),
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Icon(
                                                                                Icons.add,
                                                                                color: AppColors.grey,
                                                                                size: 40,
                                                                              ),
                                                                              AppText('Front', color: AppColors.grey)
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            viewModel.pickedImage1 !=
                                                                    null
                                                                ? GestureDetector(
                                                                    onTap: () {
                                                                      viewModel
                                                                          .openGallery1();
                                                                      print(
                                                                          "!!!${viewModel.pickedImage1!.toString()}");
                                                                    },
                                                                    child: Image
                                                                        .file(
                                                                      viewModel
                                                                          .pickedImage1!,
                                                                      height:
                                                                          80,
                                                                      width:
                                                                          120,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  )
                                                                : GestureDetector(
                                                                    onTap: () {
                                                                      viewModel
                                                                          .openGallery1();
                                                                      print(
                                                                          "!!!${viewModel.pickedImage1!.toString()}");
                                                                    },
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              4),
                                                                      child:
                                                                          Container(
                                                                        decoration:
                                                                            BoxDecoration(border: Border.all(color: AppColors.grey)),
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              4.0),
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Icon(
                                                                                Icons.add,
                                                                                color: AppColors.grey,
                                                                                size: 40,
                                                                              ),
                                                                              AppText('Back', color: AppColors.grey)
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: AppText(
                                                'File size max : 5MB supported File: PNG,JPEG,JPG',
                                                style: redtext,
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 0.3,
                                                      color: AppColors.grey)),
                                            ),
                                          ],
                                        ),
                                      if (viewModel.selectedIdType ==
                                          'Passport')
                                        Column(
                                          children: [
                                            ListTile(
                                              title: Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      children: [
                                                        AppText('*Name',
                                                            style: greytext),
                                                        Expanded(
                                                          child: SizedBox(
                                                            width:
                                                                double.infinity,
                                                            child: TextField(
                                                              controller: viewModel
                                                                  .nameController,
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                              decoration:
                                                                  InputDecoration(
                                                                      border: InputBorder
                                                                          .none,
                                                                      enabledBorder: UnderlineInputBorder(
                                                                          borderSide: BorderSide
                                                                              .none), // Remove underline
                                                                      focusedBorder: UnderlineInputBorder(
                                                                          borderSide: BorderSide
                                                                              .none), // Remove underline when focused
                                                                      hintText:
                                                                          'Please type in your name',
                                                                      hintStyle:
                                                                          TextStyle(
                                                                              color: AppColors.lightGrey)),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 0.3,
                                                      color: AppColors.grey)),
                                            ),
                                            ListTile(
                                              title: Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      children: [
                                                        AppText('*Passport',
                                                            style: greytext),
                                                        Expanded(
                                                          child: SizedBox(
                                                            width:
                                                                double.infinity,
                                                            child: TextField(
                                                              controller: viewModel
                                                                  .noController,
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                              decoration:
                                                                  InputDecoration(
                                                                      border: InputBorder
                                                                          .none,
                                                                      enabledBorder: UnderlineInputBorder(
                                                                          borderSide: BorderSide
                                                                              .none), // Remove underline
                                                                      focusedBorder: UnderlineInputBorder(
                                                                          borderSide: BorderSide
                                                                              .none), // Remove underline when focused
                                                                      hintText:
                                                                          'Passport No.',
                                                                      hintStyle:
                                                                          TextStyle(
                                                                              color: AppColors.lightGrey)),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 0.3,
                                                      color: AppColors.grey)),
                                            ),
                                            ListTile(
                                              title: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      AppText('*Passport photo',
                                                          style: greytext),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Row(
                                                        children: [
                                                          viewModel.pickedImage !=
                                                                  null
                                                              ? GestureDetector(
                                                                  onTap: () {
                                                                    viewModel
                                                                        .openGallery();
                                                                    print(
                                                                        "!!!${viewModel.pickedImage?.toString()}");
                                                                  },
                                                                  child: Image
                                                                      .file(
                                                                    viewModel
                                                                        .pickedImage!,
                                                                    height: 50,
                                                                    width: 50,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                )
                                                              : GestureDetector(
                                                                  onTap: () {
                                                                    viewModel
                                                                        .openGallery();
                                                                    print(
                                                                        "!!!${viewModel.pickedImage?.toString()}");
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                            border:
                                                                                Border.all(color: AppColors.grey)),
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .all(
                                                                          4.0),
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Icon(
                                                                            Icons.add,
                                                                            color:
                                                                                AppColors.grey,
                                                                            size:
                                                                                40,
                                                                          ),
                                                                          AppText(
                                                                              'Front',
                                                                              color: AppColors.grey)
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          viewModel.pickedImage1 !=
                                                                  null
                                                              ? GestureDetector(
                                                                  onTap: () {
                                                                    viewModel
                                                                        .openGallery1();
                                                                    print(
                                                                        "!!!${viewModel.pickedImage1!.toString()}");
                                                                  },
                                                                  child: Image
                                                                      .file(
                                                                    viewModel
                                                                        .pickedImage1!,
                                                                    height: 50,
                                                                    width: 50,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                )
                                                              : GestureDetector(
                                                                  onTap: () {
                                                                    viewModel
                                                                        .openGallery1();
                                                                    print(
                                                                        "!!!${viewModel.pickedImage1!.toString()}");
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                            border:
                                                                                Border.all(color: AppColors.grey)),
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .all(
                                                                          4.0),
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Icon(
                                                                            Icons.add,
                                                                            color:
                                                                                AppColors.grey,
                                                                            size:
                                                                                40,
                                                                          ),
                                                                          AppText(
                                                                              'Back',
                                                                              color: AppColors.grey)
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: AppText(
                                                'File size max : 5MB supported File: PNG,JPEG,JPG',
                                                style: redtext,
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 0.3,
                                                      color: AppColors.grey)),
                                            ),
                                          ],
                                        ),
                                      // SizedBox(height: AppSize.height(context, 30),),
                                    ],
                                  ),
                                  SizedBox(
                                    height: AppSize.height(context, 1),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.security,
                                        color: AppColors.green,
                                      ),
                                      AppText(
                                        'Your personal information will be secured',
                                        color: AppColors.grey,
                                        fontSize: 13,
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ConnectivityWidgetWrapper(
                                        stacked: false,
                                        disableInteraction: false,
                                        offlineWidget: RoundedLoadingButton(
                                          height: AppSize.height(context, 6),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          color: ColorConstant.apptheme,
                                          onPressed: null,
                                          animateOnTap: nextValidation(),
                                          elevation: 5,
                                          controller:
                                              viewModel.nextButtonController,
                                          child: Text("No connection",
                                              style: willGrowTittle(context)),
                                        ),
                                        child: RoundedLoadingButton(
                                          onPressed: () async {
                                            if (viewModel.file1 == false ||
                                                viewModel.file2 == false) {
                                              Get.snackbar(
                                                  "Identity Verification",
                                                  "Image file size should be less than 5MB.",
                                                  snackPosition:
                                                      SnackPosition.TOP,
                                                  duration: const Duration(
                                                      seconds: 6),
                                                  backgroundColor:
                                                      AppColors.red,
                                                  margin:
                                                      const EdgeInsets.all(10),
                                                  colorText: Colors.white);
                                              viewModel.nextButtonController
                                                  .reset();
                                            } else if (nextValidation()) {
                                              viewModel.fetchKyc(context);
                                              setState(() {
                                                isExpanded3 = false;
                                              });
                                            } else {
                                              Get.snackbar(
                                                  "Identity Verification",
                                                  "Please fill all the details",
                                                  snackPosition:
                                                      SnackPosition.TOP,
                                                  duration: const Duration(
                                                      seconds: 6),
                                                  backgroundColor:
                                                      AppColors.red,
                                                  margin:
                                                      const EdgeInsets.all(10),
                                                  colorText: Colors.white);
                                              viewModel.nextButtonController
                                                  .reset();
                                            }
                                          },
                                          height: AppSize.height(context, 6),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          controller:
                                              viewModel.nextButtonController,
                                          elevation: 0,
                                          color: ColorConstant.apptheme,
                                          child: const Text("Submit",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18)),
                                        )),
                                  ),
                                  SizedBox(
                                    height: AppSize.height(context, 1),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                : SizedBox(),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8, top: 18),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isExpandedSupport = !isExpandedSupport;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(-0.00, 1.00),
                      end: Alignment(0, -1),
                      colors: [Color(0xFFF5F5F5), Colors.white],
                    ),
                  ),
                  height: 45,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.article,
                            size: 20,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          AppText(
                            "Support Form",
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: AppSize.width(context, 2),
                          ),
                          Icon(
                            isExpandedSupport
                                ? Icons.keyboard_arrow_down
                                : Icons.keyboard_arrow_up,
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
            isExpandedSupport == true
                ? Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                      right: 8,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              SizedBox(
                                height: AppSize.height(context, 2),
                              ),
                              // Container(
                              //   height: AppSize.height(context, 9),
                              //   width: MediaQuery.of(context).size.width,
                              //   child: TextFormField(
                              //     controller: supportVM.emailController,
                              //     cursorColor: ColorConstant.apptheme,
                              //     decoration: InputDecoration(
                              //         filled: true,
                              //         border: OutlineInputBorder(
                              //           borderRadius:
                              //               BorderRadius.circular(10),
                              //         ),
                              //         contentPadding: EdgeInsets.fromLTRB(
                              //             20.0, 20.0, 20.0, 15.0),
                              //         focusedBorder: OutlineInputBorder(
                              //             borderRadius:
                              //                 BorderRadius.circular(10),
                              //             borderSide: BorderSide(
                              //                 width: 2,
                              //                 color:
                              //                     ColorConstant.darkmerron)),
                              //         enabledBorder: OutlineInputBorder(
                              //             borderRadius:
                              //                 BorderRadius.circular(10),
                              //             borderSide: BorderSide(
                              //                 width: 2,
                              //                 color:
                              //                     ColorConstant.darkmerron)),
                              //         labelText: email.toString(),
                              //
                              //         // hintText: "Email",
                              //         hintStyle: TextStyle(
                              //           fontSize: 15,
                              //         )),
                              //     enableSuggestions: true,
                              //     style: TextStyle(
                              //         decoration: TextDecoration.none,
                              //         color: ColorConstant.darkmerron,
                              //         fontSize: 15,
                              //         fontFamily: 'Nunito Sans'),
                              //   ),
                              // ),
                              // SizedBox(
                              //   height: AppSize.height(context, 1),
                              // ),
                              Form(
                                key: _formKey,
                                child: Container(
                                  height: AppSize.height(context, 15),
                                  width: MediaQuery.of(context).size.width,
                                  child: TextFormField(
                                    maxLines: 5,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Form is required!';
                                      }
                                      if (value.length > 1000) {
                                        return 'Maximum 1000 characters allowed!';
                                      }
                                      return null;
                                    },
                                    onChanged: (text) {
                                      // Update the character count when the text changes
                                      supportVM.updateCharCount(text.length);
                                    },
                                    controller: supportVM.descriptionController,
                                    cursorColor: ColorConstant.apptheme,
                                    decoration: InputDecoration(
                                        //filled: true,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        contentPadding: EdgeInsets.fromLTRB(
                                            20.0, 20.0, 20.0, 15.0),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                width: 2,
                                                color:
                                                    ColorConstant.darkmerron)),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                width: 2,
                                                color:
                                                    ColorConstant.darkmerron)),
                                        hintText: "description",
                                        // hintText: "Email",
                                        hintStyle: TextStyle(
                                          fontSize: 15,
                                        )),
                                    enableSuggestions: true,
                                    style: TextStyle(
                                        decoration: TextDecoration.none,
                                        color: ColorConstant.darkmerron,
                                        fontSize: 15,
                                        fontFamily: 'Nunito Sans'),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                      "${supportVM.charCount}/${supportVM.maxCharCount}"),
                                ],
                              ),
                              SizedBox(
                                height: AppSize.height(context, 3),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ConnectivityWidgetWrapper(
                                    stacked: false,
                                    disableInteraction: false,
                                    offlineWidget: RoundedLoadingButton(
                                      height: AppSize.height(context, 8),
                                      width: MediaQuery.of(context).size.width,
                                      controller:
                                          supportVM.supportButtonController,
                                      onPressed: null,
                                      animateOnTap: isLoginEnabled(),
                                      elevation: 5,
                                      color: isLoginEnabled()
                                          ? Color(0xffF5591F)
                                          : Colors.grey[300],
                                      child: Text(
                                        "No connection",
                                      ),
                                    ),
                                    child: RoundedLoadingButton(
                                      onPressed: () {
                                        setState(() {
                                          _autoValidate =
                                              true; // Enable validation when login button is pressed
                                        });
                                        if (isLoginEnabled())
                                          supportVM.fetchSupport(context);
                                      },
                                      height: AppSize.height(context, 6),
                                      width: MediaQuery.of(context).size.width,
                                      controller:
                                          supportVM.supportButtonController,
                                      animateOnTap: isLoginEnabled(),
                                      elevation: 0,
                                      color: isLoginEnabled()
                                          ? Color(0xffF5591F)
                                          : Colors.grey[300],
                                      child: const Text("Submit",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18)),
                                    )),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                : SizedBox(),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8, top: 18),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isExpanded2FA = !isExpanded2FA;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(-0.00, 1.00),
                      end: Alignment(0, -1),
                      colors: [Color(0xFFF5F5F5), Colors.white],
                    ),
                  ),
                  height: 45,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/tfa.png',
                            height: 20,
                            width: 20,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          AppText(
                            "Two-factor authentication setup",
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            isExpanded2FA
                                ? Icons.keyboard_arrow_down
                                : Icons.keyboard_arrow_up,
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
            isExpanded2FA == true
                ? Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                      right: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              AppText(
                                "Two-factor authentication (2FA) helps protect your account. Even if hackers somehow obtained your login and password, they will also need to have a physical access to the device where 2FA has been set up. In the vast majority of cases this is not possible, so your account will remain protected: no one will be able to make calls on your behalf and spend your money.",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                height: AppSize.height(context, 1.5),
                              ),
                              AppText(
                                "We require 2FA on a mandatory basis, please follow the next steps:",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                height: AppSize.height(context, 1.5),
                              ),
                              AppText(
                                "1. Use authenticator app of your choice or install Google Authenticator from the App Store or Google Play:",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                height: AppSize.height(context, 1.5),
                              ),
                              playstoreicon(),
                              SizedBox(
                                height: AppSize.height(context, 1.5),
                              ),
                              getProfileVM.ffeaturedProductsModelModel.data
                                          ?.data?.user?.tFAStatus ==
                                      0
                                  ? AppText(
                                      "2. Add a new account to your authenticator app by entering the secret key or by scanning the QR code:",
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    )
                                  : SizedBox(),
                              getProfileVM.ffeaturedProductsModelModel.data
                                          ?.data?.user?.tFAStatus ==
                                      0
                                  ? Column(
                                      children: [
                                        SizedBox(
                                          height: AppSize.height(context, 1.5),
                                        ),
                                        QrImageView(
                                          backgroundColor: Colors.white,
                                          data:
                                              "otpauth://totp/dsrummy:${getProfileVM.ffeaturedProductsModelModel.data?.data?.user?.email}?secret=${getProfileVM.ffeaturedProductsModelModel.data?.data?.tFAenablekey}&issuer=&algorithm=SHA1&digits=6&period=30",
                                          version: QrVersions.auto,
                                          size: 200.0,
                                        ),
                                        SizedBox(
                                          height: AppSize.height(context, 1.5),
                                        ),
                                        getProfileVM.ffeaturedProductsModelModel
                                                    .data?.data?.tFAenablekey !=
                                                null
                                            ? Center(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Clipboard.setData(ClipboardData(
                                                        text: getProfileVM
                                                                .ffeaturedProductsModelModel
                                                                .data
                                                                ?.data!
                                                                .tFAenablekey
                                                                .toString() ??
                                                            ""));
                                                    Future.delayed(
                                                        Duration.zero, (() {
                                                      Get.snackbar(
                                                          "Copied to Clipboard",
                                                          "Secret Key Copied",
                                                          snackPosition:
                                                              SnackPosition.TOP,
                                                          duration:
                                                              const Duration(
                                                                  seconds: 6),
                                                          backgroundColor:
                                                              AppColors.green,
                                                          margin:
                                                              const EdgeInsets
                                                                  .all(10),
                                                          colorText:
                                                              Colors.white);
                                                    }));
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      AppText(getProfileVM
                                                              .ffeaturedProductsModelModel
                                                              .data
                                                              ?.data
                                                              ?.tFAenablekey
                                                              .toString() ??
                                                          ""),
                                                      SizedBox(
                                                        width: AppSize.width(
                                                            context, 2),
                                                      ),
                                                      Icon(
                                                        Icons.copy_outlined,
                                                        color: Colors.green,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : SizedBox(),
                                      ],
                                    )
                                  : SizedBox(),
                              SizedBox(
                                height: AppSize.height(context, 1.5),
                              ),
                              Row(
                                children: [
                                  getProfileVM.ffeaturedProductsModelModel.data
                                              ?.data?.user?.tFAStatus ==
                                          0
                                      ? AppText(
                                          "3.",
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        )
                                      : AppText(
                                          "2.",
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                  Row(
                                    children: [
                                      AppText(
                                        "Enter the code provided by the authenticator app:",
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                      getProfileVM
                                                  .ffeaturedProductsModelModel
                                                  .data
                                                  ?.data
                                                  ?.user
                                                  ?.tFAStatus ==
                                              0
                                          ? AppText(
                                              "Enable",
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            )
                                          : AppText(
                                              "Disable",
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: AppSize.height(context, 1),
                              ),
                              Form(
                                key: _formKey,
                                child: Container(
                                  height: AppSize.height(context, 9),
                                  width: MediaQuery.of(context).size.width,
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'OTP is required!';
                                      }
                                      return null;
                                    },
                                    controller: tFaVM.otpController,
                                    cursorColor: ColorConstant.apptheme,
                                    decoration: InputDecoration(
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        contentPadding: EdgeInsets.fromLTRB(
                                            20.0, 20.0, 20.0, 15.0),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                width: 2,
                                                color:
                                                    ColorConstant.darkmerron)),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                width: 2,
                                                color:
                                                    ColorConstant.darkmerron)),
                                        //  labelText: "Email",

                                        hintText: "OTP",
                                        hintStyle: TextStyle(
                                          fontSize: 15,
                                        )),
                                    keyboardType: TextInputType.number,
                                    enableSuggestions: true,
                                    style: TextStyle(
                                        decoration: TextDecoration.none,
                                        color: ColorConstant.darkmerron,
                                        fontSize: 15,
                                        fontFamily: 'Nunito Sans'),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: AppSize.height(context, 1),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  buttonRummy(
                                      color: ColorConstant.gren,
                                      height: 30,
                                      width: 100,
                                      onPressed: () async {
                                        setState(() {
                                          _autoValidate = true;
                                          tFaVM.fetchVerify(context,
                                              secret: getProfileVM
                                                  .ffeaturedProductsModelModel
                                                  .data!
                                                  .data!
                                                  .tFAenablekey
                                                  .toString());
                                        });
                                        if (isLoginEnabled())
                                          tFaVM.fetchVerify(context,
                                              secret: getProfileVM
                                                  .ffeaturedProductsModelModel
                                                  .data!
                                                  .data!
                                                  .tFAenablekey
                                                  .toString());
                                      },
                                      child: AppText(
                                        getProfileVM
                                                    .ffeaturedProductsModelModel
                                                    .data
                                                    ?.data
                                                    ?.user
                                                    ?.tFAStatus ==
                                                0
                                            ? "Enable"
                                            : "Disable",
                                        color: ColorConstant.white,
                                      )),
                                  SizedBox(
                                    width: AppSize.width(context, 2),
                                  ),
                                  buttonRummy(
                                      color: ColorConstant.gray400,
                                      height: 30,
                                      width: 100,
                                      onPressed: () {
                                        // Navigator.pop(context);
                                        setState(() {
                                          isExpanded2FA = false;
                                          tFaVM.otpController.clear();
                                        });
                                      },
                                      child: AppText(
                                        "Close",
                                        color: ColorConstant.white,
                                      ))
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                : SizedBox(),
            // getProfileVM.ffeaturedProductsModelModel.data?.data != null
            //     ? Padding(
            //         padding:
            //             const EdgeInsets.only(left: 8.0, right: 8, top: 18),
            //         child: GestureDetector(
            //           onTap: () {
            //             showDialog(
            //               context: context,
            //               barrierDismissible: false,
            //               builder: (BuildContext context) {
            //                 return DeleteAccountPopUP();
            //               },
            //             );
            //           },
            //           child: Container(
            //             decoration: BoxDecoration(
            //               gradient: LinearGradient(
            //                 begin: Alignment(-0.00, 1.00),
            //                 end: Alignment(0, -1),
            //                 colors: [Color(0xFFF5F5F5), Colors.white],
            //               ),
            //             ),
            //             height: 45,
            //             child: Row(
            //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //               children: [
            //                 Row(
            //                   children: [
            //                     Icon(
            //                       Icons.delete,
            //                       size: 20,
            //                     ),
            //                     SizedBox(
            //                       width: 5,
            //                     ),
            //                     AppText(
            //                       "Delete My Account",
            //                       fontSize: 13,
            //                       fontWeight: FontWeight.w500,
            //                     ),
            //                   ],
            //                 ),
            //                 Row(
            //                   children: [
            //                     SizedBox(
            //                       width: AppSize.width(context, 2),
            //                     ),
            //                     Icon(
            //                       Icons.keyboard_arrow_right,
            //                       color: ColorConstant.gray300,
            //                       size: 27,
            //                     ),
            //                   ],
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ),
            //       )
            //     : SizedBox(),

            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8, top: 18),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return PrivacyPolicy();
                  }));
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(-0.00, 1.00),
                      end: Alignment(0, -1),
                      colors: [Color(0xFFF5F5F5), Colors.white],
                    ),
                  ),
                  height: 45,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset('assets/images/Privacy Policy.png',
                              height: 20, width: 20),
                          SizedBox(
                            width: 5,
                          ),
                          AppText(
                            "General Agreement privacy policy",
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: AppSize.width(context, 2),
                          ),
                          Icon(
                            Icons.keyboard_arrow_right,
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
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8, top: 18),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return termscondition();
                  }));
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(-0.00, 1.00),
                      end: Alignment(0, -1),
                      colors: [Color(0xFFF5F5F5), Colors.white],
                    ),
                  ),
                  height: 45,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset('assets/images/Terms and Conditions.png',
                              height: 20, width: 20),
                          SizedBox(
                            width: 5,
                          ),
                          AppText(
                            "Terms & Conditions",
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: AppSize.width(context, 2),
                          ),
                          Icon(
                            Icons.keyboard_arrow_right,
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
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8, top: 18),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return refundPolicy();
                  }));
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(-0.00, 1.00),
                      end: Alignment(0, -1),
                      colors: [Color(0xFFF5F5F5), Colors.white],
                    ),
                  ),
                  height: 45,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset('assets/images/refund.png',
                              height: 20, width: 20),
                          SizedBox(
                            width: 5,
                          ),
                          AppText(
                            "Cancellation & Refund Policy",
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: AppSize.width(context, 2),
                          ),
                          Icon(
                            Icons.keyboard_arrow_right,
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
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8, top: 18),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return WithdrawPolicy();
                  }));
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(-0.00, 1.00),
                      end: Alignment(0, -1),
                      colors: [Color(0xFFF5F5F5), Colors.white],
                    ),
                  ),
                  height: 45,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset('assets/images/Withdrawal Policy.png',
                              height: 20, width: 20),
                          SizedBox(
                            width: 5,
                          ),
                          AppText(
                            "Withdrawal Policy",
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: AppSize.width(context, 2),
                          ),
                          Icon(
                            Icons.keyboard_arrow_right,
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

            getProfileVM.ffeaturedProductsModelModel.data?.data != null
                ? Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 8, top: 18),
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return LogoutPopUP();
                          },
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(-0.00, 1.00),
                            end: Alignment(0, -1),
                            colors: [Color(0xFFF5F5F5), Colors.white],
                          ),
                        ),
                        height: 45,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.logout,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                AppText(
                                  "Logout",
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: AppSize.width(context, 2),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_right,
                                  color: ColorConstant.gray300,
                                  size: 27,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : SizedBox(),
          ],
        )),
      ),
    );
  }

  // Widget AddcashButton() {
  //   return buttonRummy(
  //     onPressed: () {
  //       Navigator.of(context).push(
  //         MaterialPageRoute(
  //           builder: (context) => Deposit(),
  //         ),
  //       );
  //     },
  //     height: AppSize.height(context, 3.5),
  //     width: AppSize.width(context, 28),
  //     color: ColorConstant.yellow,
  //     //color: Colors.lightGreen,
  //     child: AppText(
  //       "ADD CASH",
  //       fontSize: 13,
  //       fontWeight: FontWeight.w500,
  //       color: ColorConstant.apptheme,
  //     ),
  //   );
  // }

  void _showIdTypeBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: ColorConstant.apptheme,
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AppText(
                        'Driving Licence',
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  setState(() {
                    viewModel.selectedIdType = 'Driving Licence';
                  });
                  Navigator.pop(context);
                },
              ),
              Container(
                decoration: BoxDecoration(
                    border:
                        Border.all(width: 0.1, color: AppColors.timeLineGrey)),
              ),
              ListTile(
                title: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AppText('Passport', color: Colors.white),
                    ),
                  ],
                ),
                onTap: () {
                  setState(() {
                    viewModel.selectedIdType = 'Passport';
                  });
                  Navigator.pop(context);
                },
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 5, color: Theme.of(context).canvasColor)),
              ),
              ListTile(
                title: Column(
                  children: [
                    AppText(
                      'Cancel',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
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

  Widget playstoreicon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () {
            launch(
                "https://play.google.com/store/apps/details?id=com.google.android.apps.authenticator2&hl=en_IN&gl=US&pli=1");
          },
          child: Container(
            decoration: BoxDecoration(
                color: Colors.black, borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    "assets/images/playStore.png",
                    //width: 150,
                    height: 35,
                  ),
                  SizedBox(
                    width: AppSize.width(context, 1),
                  ),
                  AppText(
                    "Download the\nPlayStore",
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            launch(
                "https://apps.apple.com/us/app/google-authenticator/id388497605");
          },
          child: Container(
            decoration: BoxDecoration(
                color: Colors.black, borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    "assets/images/appStore.png",
                    color: Colors.white,
                    // width: 150,
                    height: 35,
                  ),
                  SizedBox(
                    width: AppSize.width(context, 1),
                  ),
                  AppText(
                    "Download the\nAppStore",
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
