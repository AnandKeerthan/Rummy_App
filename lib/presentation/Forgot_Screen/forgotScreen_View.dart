import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:dsrummy/app_export/app_export.dart';
import 'package:dsrummy/presentation/ResetPassword_Screen/View/ResetPassword_Screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import 'ViewModel/ForgotViewModel.dart';

class forgotPassword extends StatefulWidget {
  const forgotPassword({super.key});

  @override
  State<forgotPassword> createState() => _forgotPasswordState();
}

class _forgotPasswordState extends State<forgotPassword> {
  late ForgotVM viewModel;

  bool obscureText = true;
  bool isValidEmail(String email) {
    // Regular expression for validating email addresses
    // This regex pattern is a simplified version and may not cover all cases
    final RegExp emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
      caseSensitive: false,
      multiLine: false,
    );
    return emailRegex.hasMatch(email);
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  bool isLoginEnabled() {
    if (_autoValidate) {
      // Check _autoValidate before validating the form
      final formState = _formKey.currentState;
      if (formState != null) {
        final isValid = formState.validate();
        if (isValid) {
          formState.save();
          return viewModel.ForgotMailController.text.isNotEmpty &&
              viewModel.VCcontroller.text.isNotEmpty;
        }
      }
    }
    return false;
  }


  @override
  void dispose() {
    // Dispose of controllers when the widget is disposed
    viewModel.ForgotMailController.clear();
    viewModel.VCcontroller.clear();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<ForgotVM>();

    return ConnectivityScreenWrapper(
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: AppColors.white,
                            )),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 40),
                        child: Center(
                          child: Image.asset(
                            ImageConstant.bitRummyLogo,
                            height: 120,
                            width: 120,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: AppSize.height(context, 3),
                      ),
                      Container(
                        width: AppSize.width(context, 92),
                        //height: 180,
                        // height: AppSize.height(context, 70),

                        decoration: BoxDecoration(
                            color: ColorConstant.darkmerron,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
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
                                height: AppSize.height(context, 2),
                              ),
                              Container(
                                height: AppSize.height(context, 9),
                                width: MediaQuery.of(context).size.width,
                                child: TextFormField(
                                  controller: viewModel.ForgotMailController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Email is required!';
                                    }
                                    return null;
                                  },
                                  cursorColor: ColorConstant.apptheme,
                                  decoration: InputDecoration(
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      contentPadding: EdgeInsets.fromLTRB(
                                          20.0, 20.0, 20.0, 15.0),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              width: 2,
                                              color: ColorConstant.darkmerron)),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              width: 2,
                                              color: ColorConstant.darkmerron)),
                                      //  labelText: "Email",

                                      hintText: "Enter Email",
                                      suffixIcon: viewModel.ForgotMailController
                                              .text.isNotEmpty
                                          ? IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  viewModel.ForgotMailController
                                                      .clear();
                                                });
                                              },
                                              icon: Icon(Icons.clear_rounded),
                                            )
                                          : null,
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
                                height: AppSize.height(context, 9),
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: viewModel.VCcontroller,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'OTP is required!';
                                          }
                                          return null;
                                        },
                                        cursorColor: ColorConstant.apptheme,
                                        keyboardType: TextInputType.number,
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

                                            hintText: "Enter OTP",
                                            suffixIcon: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 12.0, top: 6),
                                              child: GestureDetector(
                                                onTap: () {
                                                  viewModel
                                                      .fetchForgot(context);
                                                },
                                                child: AppText("Get OTP",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xffF5591F),
                                                        fontSize: 18)),
                                              ),
                                            ),
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
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: AppSize.height(context, 1),
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
                                          viewModel.forgotButtonController,
                                      onPressed: null,
                                      animateOnTap: isLoginEnabled(),
                                      elevation: 5,
                                      color: isLoginEnabled()
                                          ? AppColors.primaryColor
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
                                          viewModel.fetchVerifyOTP(context);
                                        }
                                      },
                                      height: AppSize.height(context, 6),
                                      width: MediaQuery.of(context).size.width,
                                      controller:
                                          viewModel.forgotButtonController,
                                      animateOnTap: isLoginEnabled(),
                                      elevation: 0,
                                      color: isLoginEnabled()
                                          ? Color(0xffF5591F)
                                          : Colors.grey[300],
                                      child: const Text("Next",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18)),
                                    )),
                              ),
                              SizedBox(
                                height: AppSize.height(context, 2),
                              ),
                              // Align(
                              //   alignment: Alignment.bottomCenter,
                              //   child: GestureDetector(
                              //     onTap: () {
                              //       Navigator.push(context,
                              //           MaterialPageRoute(builder: (context) {
                              //         return Reset_Password_View();
                              //       }));
                              //     },
                              //     child: Padding(
                              //       padding: const EdgeInsets.all(8.0),
                              //       child: Text.rich(
                              //         TextSpan(
                              //           text:
                              //               'if you did\'n receive Verification code,please contact ',
                              //           style: TextStyle(
                              //             color: Colors.grey,
                              //             fontSize: 15.0,
                              //             fontWeight: FontWeight.w400,
                              //           ),
                              //           children: <TextSpan>[
                              //             TextSpan(
                              //               text: 'Customer Service',
                              //               style: TextStyle(
                              //                 color: Colors.blue,
                              //                 fontSize: 15.0,
                              //                 decoration:
                              //                     TextDecoration.underline,
                              //                 decorationColor: Colors.blue,
                              //               ),
                              //               recognizer: TapGestureRecognizer()
                              //                 ..onTap = () {
                              //                   print(
                              //                       'Navigate to service agreement page');
                              //                 },
                              //             ),
                              //           ],
                              //         ),
                              //         textAlign: TextAlign
                              //             .center, // Align text to the center
                              //       ),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
