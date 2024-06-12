import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:dsrummy/app_export/app_export.dart';
import 'package:dsrummy/presentation/DeviceIdVM/DeviceIDVM.dart';
import 'package:dsrummy/presentation/Forgot_Screen/forgotScreen_View.dart';
import 'package:dsrummy/presentation/GetProfile_Screen/ViewModel/GetProfileVm.dart';
import 'package:dsrummy/presentation/Guest/GuestRegister/ViewModel/GusestViewModel.dart';
import 'package:dsrummy/presentation/LoginVerificationScreen/View/LoginVerificationScreen.dart';
import 'package:dsrummy/presentation/RegisterScreen/View/RegisterScreen.dart';
import 'package:dsrummy/presentation/RootScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ViewModel/LoginViewModel.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late LoginVM viewModel;

  bool _autoValidate = false;

  GetProfileVM getProfileVM = GetProfileVM();
  GusestRegisterVM gusestRegisterVM = GusestRegisterVM();

  bool obscureText = true;
  bool obscure = true;
  bool obscure2 = true;
  bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
      caseSensitive: false,
      multiLine: false,
    );
    return emailRegex.hasMatch(email);
  }

  late DeviceInfoViewModel _deviceInfoViewModel;
  String id = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _deviceInfoViewModel = DeviceInfoViewModel();
    _initializeDeviceInfo();
  }

  Future<void> _initializeDeviceInfo() async {
    await _deviceInfoViewModel.initDeviceInfo();
    // Now you can access _deviceInfoViewModel.deviceId and use it across your app
    print('Device22  99999999999 : ${_deviceInfoViewModel.deviceId}');
    setState(() {
      id = _deviceInfoViewModel.deviceId ?? "Not available";
    }); // Navigate to the next screen
    // Navigator.push(context, MaterialPageRoute(builder: (context) => NextScreen()));
  }

  bool isValidPassword(String input) {
    RegExp regex = RegExp(r'^(?=.*[0-9])(?=.*[a-zA-Z])[a-zA-Z0-9]{6,15}$');
    return regex.hasMatch(input);
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime? _lastBackPressedTime;
  bool isLoginEnabled() {
    if (_autoValidate) {
      // Check _autoValidate before validating the form
      final formState = _formKey.currentState;
      if (formState != null) {
        final isValid = formState.validate();
        if (isValid) {
          formState.save();
          return viewModel.loginMailController.text.isNotEmpty &&
              viewModel.loginPasswordController.text.isNotEmpty;
        }
      }
    }
    return false;
  }

  @override
  void dispose() {
    // Dispose of controllers when the widget is disposed
    viewModel.loginMailController.clear();
    viewModel.loginPasswordController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<LoginVM>();
    getProfileVM = context.watch<GetProfileVM>();
    gusestRegisterVM = context.watch<GusestRegisterVM>();
    // print("id66666666666 :: ${id}");
    return WillPopScope(
        onWillPop: () async {
          if (_lastBackPressedTime == null ||
              DateTime.now().difference(_lastBackPressedTime!) >
                  Duration(seconds: 2)) {
            _lastBackPressedTime = DateTime.now();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: const Duration(seconds: 2),
                content: AppText(
                  'Do you want to exit the app? Press back again.',
                  color: Colors.white,
                ),
              ),
            );

            return false;
          } else {
            SystemNavigator.pop(); // Close the app

            return true;
          }
        },
        child: ConnectivityScreenWrapper(
          positionOnScreen: PositionOnScreen.TOP,
          message: "Check Your Internet Connection",
          height: MediaQuery.of(context).viewPadding.top,
          disableInteraction: false,
          child: Scaffold(
            body: SingleChildScrollView(
              child: Container(
                height: MediaQuery.sizeOf(context).height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(ImageConstant.bg),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: AppSize.height(context, 3),
                        ),
                        viewModel.close == true
                            ? SizedBox()
                            : Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  height: 60,
                                  width: AppSize.width(context, 90),
                                  decoration: BoxDecoration(
                                    color: Color(0xffF5591F).withOpacity(0.2),
                                    border: Border.all(
                                        color: Colors.white, width: 0.2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(3.0),
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
                                                      color: Colors.white,
                                                      width: 0.2),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                              ),
                                              onTap: () {
                                                Navigator.of(context)
                                                    .pushAndRemoveUntil(
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
                                                  FocusScope.of(context)
                                                      .unfocus();

                                                  viewModel.close = true;
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
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // Align(
                              //   alignment: Alignment.topLeft,
                              //   child: IconButton(
                              //       onPressed: () {
                              //         Navigator.pop(context);
                              //       },
                              //       icon: Icon(
                              //         Icons.arrow_back_ios,
                              //         color: AppColors.white,
                              //       )),
                              // ),
                              GestureDetector(
                                onTap: () {
                                  // FocusScope.of(context).unfocus();

                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //       builder: (context) =>
                                  //           LoginVerificationScreen(),
                                  //     ));
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 40),
                                  child: Center(
                                    child: Image.asset(
                                      ImageConstant.bitRummyLogo,
                                      height: 120,
                                      width: 120,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: AppSize.height(context, 3),
                              ),
                              Column(
                                children: [
                                  Container(
                                    width: AppSize.width(context, 92),
                                    //height: 180,
                                    // height: AppSize.height(context, 70),

                                    decoration: BoxDecoration(
                                        color: ColorConstant.darkmerron,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        boxShadow: [
                                          BoxShadow(
                                              color: ColorConstant.darkmerron,
                                              blurRadius: 70,
                                              spreadRadius: 3)
                                        ]),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height:
                                                AppSize.height(context, 2.8),
                                          ),
                                          Container(
                                            height: AppSize.height(context, 9),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: TextFormField(
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              controller:
                                                  viewModel.loginMailController,
                                              cursorColor:
                                                  ColorConstant.apptheme,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'email is required!';
                                                }
                                                return null;
                                              },
                                              decoration: InputDecoration(
                                                  filled: true,
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  contentPadding:
                                                      EdgeInsets.fromLTRB(20.0,
                                                          20.0, 20.0, 15.0),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          borderSide: BorderSide(
                                                              width: 2,
                                                              color: ColorConstant
                                                                  .darkmerron)),
                                                  enabledBorder: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      borderSide: BorderSide(
                                                          width: 2,
                                                          color: ColorConstant
                                                              .darkmerron)),
                                                  //  labelText: "Email",

                                                  hintText: "Email",
                                                  hintStyle: TextStyle(
                                                    fontSize: 15,
                                                  )),
                                              enableSuggestions: true,
                                              style: TextStyle(
                                                  decoration:
                                                      TextDecoration.none,
                                                  color:
                                                      ColorConstant.darkmerron,
                                                  fontSize: 15,
                                                  fontFamily: 'Nunito Sans'),
                                            ),
                                          ),
                                          SizedBox(
                                            height: AppSize.height(context, 1),
                                          ),
                                          Container(
                                            height: AppSize.height(context, 9),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: TextFormField(
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              controller: viewModel
                                                  .loginPasswordController,
                                              obscureText: obscure,
                                              cursorColor:
                                                  ColorConstant.apptheme,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Password is required!';
                                                }
                                                return null;
                                              },
                                              decoration: InputDecoration(
                                                  filled: true,
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  contentPadding:
                                                      EdgeInsets.fromLTRB(20.0,
                                                          20.0, 20.0, 15.0),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          borderSide: BorderSide(
                                                              width: 2,
                                                              color: ColorConstant
                                                                  .darkmerron)),
                                                  enabledBorder: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      borderSide: BorderSide(
                                                          width: 2,
                                                          color: ColorConstant
                                                              .darkmerron)),
                                                  //  labelText: "Email",
                                                  suffixIcon: IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          obscure = !obscure;
                                                        });
                                                      },
                                                      icon: obscure
                                                          ? Image.asset(
                                                              "assets/images/Invisible.png",
                                                              width: 30,
                                                            )
                                                          : Image.asset(
                                                              "assets/images/visible.png",
                                                              width: 30,
                                                            )),
                                                  hintText: "Enter Password",
                                                  hintStyle: TextStyle(
                                                    fontSize: 15,
                                                  )),
                                              enableSuggestions: true,
                                              style: TextStyle(
                                                  decoration:
                                                      TextDecoration.none,
                                                  color:
                                                      ColorConstant.darkmerron,
                                                  fontSize: 13,
                                                  fontFamily: 'Nunito Sans'),
                                            ),
                                          ),
                                          SizedBox(
                                            height:
                                                AppSize.height(context, 2.5),
                                          ),
                                          ConnectivityWidgetWrapper(
                                              stacked: false,
                                              disableInteraction: false,
                                              offlineWidget:
                                                  RoundedLoadingButton(
                                                height:
                                                    AppSize.height(context, 6),
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                controller: viewModel
                                                    .LoginButtonController,
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
                                                  if (isLoginEnabled()) {
                                                    WidgetsBinding.instance
                                                        .addPostFrameCallback(
                                                            (_) {
                                                      Provider.of<GetProfileVM>(
                                                              context,
                                                              listen: false)
                                                          .FetchProfile(
                                                              context);
                                                    });
                                                    viewModel
                                                        .fetchLogin(context);
                                                  }
                                                },
                                                height:
                                                    AppSize.height(context, 6),
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                controller: viewModel
                                                    .LoginButtonController,
                                                animateOnTap: isLoginEnabled(),
                                                elevation: 0,
                                                color: viewModel
                                                            .loginMailController
                                                            .text
                                                            .isNotEmpty &&
                                                        viewModel
                                                            .loginPasswordController
                                                            .text
                                                            .isNotEmpty
                                                    ? Color(0xffF5591F)
                                                    : Colors.grey[300],
                                                child: const Text("Login",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18)),
                                              )),
                                          SizedBox(
                                            height:
                                                AppSize.height(context, 2.8),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: 10, bottom: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Don't Have Any Account?  ",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                GestureDetector(
                                                  child: Text(
                                                    "Register Now",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xffF5591F)),
                                                  ),
                                                  onTap: () {
                                                    Navigator.of(context)
                                                        .pushAndRemoveUntil(
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  RegisterScreen(),
                                                            ),
                                                            (route) => false);
                                                  },
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: AppSize.height(context, 2),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                    return forgotPassword();
                                                  }));
                                                },
                                                child: Text(
                                                  'Forgot Password?',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15.0,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: AppSize.height(context, 3),
                                  ),
                                  // GestureDetector(
                                  //   onTap: () {
                                  //     formFillSts(true);
                                  //
                                  //     gusestRegisterVM.fetchRegisterGuest(
                                  //         context, id);
                                  //   },
                                  //   child: Padding(
                                  //     padding:
                                  //         const EdgeInsets.only(right: 20.0),
                                  //     child: Row(
                                  //       mainAxisAlignment:
                                  //           MainAxisAlignment.end,
                                  //       children: [
                                  //         Icon(
                                  //           Icons.touch_app,
                                  //           size: 25,
                                  //           color: Color(0xffF5591F),
                                  //         ),
                                  //         SizedBox(
                                  //           width: AppSize.width(context, 2),
                                  //         ),
                                  //         AppText(
                                  //           "Skip",
                                  //           fontSize: 18,
                                  //           color: Colors.white,
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  void formFillSts(bool sts) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("fillStatus", sts);
  }
}
