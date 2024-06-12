import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:dsrummy/App_Export/app_export.dart';
import 'package:dsrummy/Utlilities/AppColors/AppColors.dart';
import 'package:dsrummy/Utlilities/AppColors/color_constant.dart';
import 'package:dsrummy/Utlilities/Images/image_constant.dart';
import 'package:dsrummy/Utlilities/Mediaquery/Mediaquery.dart';
import 'package:dsrummy/presentation/DeviceIdVM/DeviceIDVM.dart';
import 'package:dsrummy/presentation/Guest/GuestRegister/ViewModel/GusestViewModel.dart';
import 'package:dsrummy/presentation/Login_Screen/View/loginScreen_View.dart';
import 'package:dsrummy/presentation/RootScreen.dart';
import 'package:dsrummy/presentation/VerifyRegisterScreen/View/VerifyRegisterScreen.dart';
import 'package:dsrummy/presentation/termsandcondition_screen/privacyPolicy.dart';
import 'package:dsrummy/presentation/termsandcondition_screen/terms&condition.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ViewModel/RegisterViewModel.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  bool obscure = true;
  bool obscure2 = true;
  late RegisterVM viewModel;  GusestRegisterVM gusestRegisterVM = GusestRegisterVM();

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

  bool isLoginEnabled() {
    if (_autoValidate) { // Check _autoValidate before validating the form
      final formState = _formKey.currentState;
      if (formState != null) {
        final isValid = formState.validate();
        if (isValid) {
          formState.save();
          return viewModel.emailController.text.isNotEmpty &&
              viewModel.passwordController.text.isNotEmpty;
        }
      }
    }
    return false;
  }
  @override
  void dispose() {
    // Dispose of controllers when the widget is disposed
    viewModel.emailController.clear();
    viewModel.passwordController.clear();
    super.dispose();
  }

  bool _isChecked = false;
  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<RegisterVM>();
    gusestRegisterVM = context.watch<GusestRegisterVM>();

    return WillPopScope(
      onWillPop: () async {
        // Implement navigation logic here
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return Login();
        }));
        return true;
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
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
                  child: Form(
                    key: _formKey,
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
                                                // Navigator.push(
                                                //     context,
                                                //     MaterialPageRoute(
                                                //       builder: (context) =>
                                                //           RegisterScreen(),
                                                //     ));
                                              },
                                            ),
                                            SizedBox(
                                              width: AppSize.width(context, 2),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
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
                        GestureDetector(
                          onTap: () {},
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
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
                                      height: AppSize.height(context, 2.8),
                                    ),
                                    Container(
                                      height: AppSize.height(context, 10),
                                      width: MediaQuery.of(context).size.width,
                                      child: TextFormField(
                                        controller: viewModel.emailController,
                                        cursorColor: ColorConstant.apptheme,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'email is required!';
                                          } else if (!RegExp(
                                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                              .hasMatch(value!)) {
                                            return 'Enter a valid email!';
                                          }
                                          return null;
                                        },
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
                                                    color: ColorConstant
                                                        .darkmerron)),
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
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
                                            decoration: TextDecoration.none,
                                            color: ColorConstant.darkmerron,
                                            fontSize: 15,
                                            fontFamily: 'Nunito Sans'),
                                      ),
                                    ),
                                    SizedBox(
                                      height: AppSize.height(context, 1),
                                    ),
                                    Container(
                                      height: AppSize.height(context, 10),
                                      width: MediaQuery.of(context).size.width,
                                      child: TextFormField(
                                        controller:
                                            viewModel.passwordController,
                                        obscureText: obscure,
                                        cursorColor: ColorConstant.apptheme,

                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Password is required!';
                                          } else if (!RegExp(
                                                  (r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$'))
                                              .hasMatch(value!)) {
                                            return 'Must Contain 8 Characters, One Uppercase, One Lower\ncase,One Number and One Special Case Character';
                                          }
                                          return null;
                                        },
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
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
                                                    color: ColorConstant
                                                        .darkmerron)),
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
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
                                            decoration: TextDecoration.none,
                                            color: ColorConstant.darkmerron,
                                            fontSize: 13,
                                            fontFamily: 'Nunito Sans'),
                                      ),
                                    ),
                                    SizedBox(
                                      height: AppSize.height(context, 1),
                                    ),
                                    Container(
                                      height: AppSize.height(context, 10),
                                      width: MediaQuery.of(context).size.width,
                                      child: TextFormField(
                                        cursorColor: ColorConstant.apptheme,
                                        obscureText: obscure2,
                                        validator: (value) {
                                          if (value !=
                                              viewModel
                                                  .passwordController.text) {
                                            return 'Password and confirm password is mismatch!';
                                          } else if (value!.isEmpty) {
                                            return 'confirm password is required!';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                            filled: true,
                                            isDense:
                                                true, // Reduces the height of input field when no error message is displayed
                                            errorMaxLines: 2,
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
                                                    color: ColorConstant
                                                        .darkmerron)),
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide(
                                                    width: 2,
                                                    color: ColorConstant
                                                        .darkmerron)),
                                            //  labelText: "Email",
                                            suffixIcon: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    obscure2 = !obscure2;
                                                  });
                                                },
                                                icon: obscure2
                                                    ? Image.asset(
                                                        "assets/images/Invisible.png",
                                                        width: 30,
                                                      )
                                                    : Image.asset(
                                                        "assets/images/visible.png",
                                                        width: 30,
                                                      )),
                                            hintText: "Confirm password",
                                            hintStyle: TextStyle(
                                              fontSize: 15,
                                            )),
                                        enableSuggestions: true,
                                        style: TextStyle(
                                            decoration: TextDecoration.none,
                                            color: ColorConstant.darkmerron,
                                            fontSize: 13,
                                            fontFamily: 'Nunito Sans'),
                                      ),
                                    ),

                                    Row(mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Checkbox(
                                          value: _isChecked,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              _isChecked = value!;
                                            });
                                          },
                                          activeColor: Color(0xffF5591F),

                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            AppText('I have read and agree Ds Rummy\'s', color: Colors.white),

                                          ],
                                        ),

                                      ],
                                    ),
                                    Row(mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: (){
                                            Navigator.push(context, MaterialPageRoute(builder: (context){
                                              return termscondition();
                                            }));
                                          },
                                            child: AppText('Terms & Conditions', color: Color(0xffF5591F))),
                                        AppText(' and', color: Colors.white),
                                        InkWell(
                                          onTap: (){
                                            Navigator.push(context, MaterialPageRoute(builder: (context){
                                              return PrivacyPolicy();
                                            }));
                                          },
                                            child: AppText(' Privacy Policy', color: Color(0xffF5591F))),
                                      ],
                                    ),
                                    SizedBox(
                                      height: AppSize.height(context, 2),
                                    ),
                                    ConnectivityWidgetWrapper(
                                        stacked: false,
                                        disableInteraction: false,
                                        offlineWidget: RoundedLoadingButton(
                                          height: AppSize.height(context, 6),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          controller:
                                              viewModel.regiterButtonController,
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
                                              _autoValidate = true; // Enable validation when login button is pressed
                                            });
                                            if (isLoginEnabled() && _isChecked==true ) {
                                              viewModel.fetchRegister(context);
                                            }
                                            else if(_isChecked==false){
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  backgroundColor: Colors.red,
                                                  duration: const Duration(seconds: 2),
                                                  content: AppText(
                                                    'Please Accept the Terms & Policy To Proceed',
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                          height: AppSize.height(context, 6),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          controller:
                                              viewModel.regiterButtonController,
                                          animateOnTap: isLoginEnabled() && _isChecked == true,
                                          elevation: 0,
                                          color: viewModel.emailController.text.isNotEmpty &&
                                              viewModel.passwordController.text.isNotEmpty
                                              ? Color(0xffF5591F)
                                              : Colors.grey[300],
                                          child: const Text("Register",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18)),
                                        )),
                                    SizedBox(
                                      height: AppSize.height(context, 2.8),
                                    ),

                                    Container(
                                      margin:
                                          EdgeInsets.only(top: 10, bottom: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Have Already Member?  ",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          GestureDetector(
                                            child: Text(
                                              "Login Now",
                                              style: TextStyle(
                                                  color: Color(0xffF5591F)),
                                            ),
                                            onTap: () {
                                              Navigator.of(context)
                                                  .pushAndRemoveUntil(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            Login(),
                                                      ),
                                                      (route) => false);

                                              // Write Tap Code Here.
                                            },
                                          )
                                        ],
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
                            //     padding: const EdgeInsets.only(right: 20.0),
                            //     child: Row(
                            //       mainAxisAlignment: MainAxisAlignment.end,
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
                            // )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }void formFillSts(bool sts) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("fillStatus", sts);
  }
}
