import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:dsrummy/app_export/app_export.dart';
import 'package:dsrummy/presentation/Login_Screen/View/loginScreen_View.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../ViewModel/ResetViewModel.dart';

class Reset_Password_View extends StatefulWidget {
  const Reset_Password_View({super.key});

  @override
  State<Reset_Password_View> createState() => _Reset_Password_ViewState();
}

class _Reset_Password_ViewState extends State<Reset_Password_View> {
  late ResetVM viewModel;

  bool obscureText = true;


  // bool isLoginEnabled() {
  //   return _formKey.currentState?.validate() ?? false;
  // }
  bool _autoValidate = false;

  // bool isLoginEnabled() {
  //   return viewModel.PasswordController.text.isNotEmpty &&
  //       viewModel.ConfirmPasswordController.text.isNotEmpty;
  // }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoginEnabled() {
    if (_autoValidate) {
      // Check _autoValidate before validating the form
      final formState = _formKey.currentState;
      if (formState != null) {
        final isValid = formState.validate();
        if (isValid) {
          formState.save();
          return viewModel.PasswordController.text.isNotEmpty &&
              viewModel.ConfirmPasswordController.text.isNotEmpty;
        }
      }
    }
    return false;
  }
  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<ResetVM>();

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
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
                                return Login();
                              }), (route) => false);
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
                                height: AppSize.height(context, 10),
                                width: MediaQuery.of(context).size.width,
                                child: TextFormField(
                                  controller: viewModel.PasswordController,
                                  cursorColor: ColorConstant.apptheme,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
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

                                      hintText: "Enter new password",
                                      suffixIcon: viewModel.PasswordController
                                              .text.isNotEmpty
                                          ? IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  viewModel.PasswordController
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
                                child: TextFormField(
                                  controller:
                                      viewModel.ConfirmPasswordController,
                                  cursorColor: ColorConstant.apptheme,
                                  validator: (value) {
                                    if (value!.isEmpty
                                       ) {
                                      return 'Confirm Password is required!';
                                    }else if ( value !=
                                        viewModel.PasswordController.text){
                                      return 'Password do not match';
                                    }
                                  },
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

                                      hintText: "Confirm new password",
                                      suffixIcon: viewModel
                                              .ConfirmPasswordController
                                              .text
                                              .isNotEmpty
                                          ? IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  viewModel
                                                          .ConfirmPasswordController
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
                                          viewModel.resetButtonController,
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
                                          viewModel.fetchReset(context);
                                        }
                                      },
                                      height: AppSize.height(context, 6),
                                      width: MediaQuery.of(context).size.width,
                                      controller:
                                          viewModel.resetButtonController,
                                      animateOnTap: isLoginEnabled(),
                                      elevation: 0,
                                      color: isLoginEnabled()
                                          ? Color(0xffF5591F)
                                          : Colors.grey[300],
                                      child: const Text("Confirm",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18)),
                                    )),
                              ),
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
