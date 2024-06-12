import 'package:dsrummy/presentation/LoginVerificationScreen/ViewModel/LoginVerifyVM.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:dsrummy/App_Export/app_export.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class LoginVerificationScreen extends StatefulWidget {
  String Email;
  LoginVerificationScreen({Key? key, required this.Email}) : super(key: key);

  @override
  State<LoginVerificationScreen> createState() =>
      _LoginVerificationScreenState();
}

class _LoginVerificationScreenState extends State<LoginVerificationScreen> {
  late VerifyLoginVM viewModel;

  // bool isLoginEnabled() {
  //   return (viewModel.mobileController.text.isNotEmpty) &&
  //       viewModel.nameMailController.text.isNotEmpty;
  // }
  bool _autoValidate = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoginEnabled() {
    if (_autoValidate) {
      // Check _autoValidate before validating the form
      final formState = _formKey.currentState;
      if (formState != null) {
        final isValid = formState.validate();
        if (isValid) {
          formState.save();
          return viewModel.nameMailController.text.isNotEmpty &&
              viewModel.lastMailController.text.isNotEmpty;
        }
      }
    }
    return false;
  }
  @override
  void dispose() {
    // Dispose of controllers when the widget is disposed
    viewModel.nameMailController.clear();
    viewModel.lastMailController.clear();
    viewModel.mobileController.clear();
    viewModel.VCcontroller.clear();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<VerifyLoginVM>();

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
                color: ColorConstant.darkmerron,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                      color: ColorConstant.darkmerron,
                      blurRadius: 70,
                      spreadRadius: 3)
                ]),
            child: Center(
              child: Column(
                children: [
                  Container(
                    height: 121,
                    decoration: topViewBgDecoration(),
                    child: const Center(
                      child: Text(
                        "Verification",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: AppSize.height(context, 3),
                  ),
                  Form(
                    key: _formKey,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 20.0,
                          right: 20,
                        ),
                        child: Container(
                          // height: 100,
                          width: MediaQuery.sizeOf(context).width,
                          decoration: BoxDecoration(
                            color: Color(0xffF5591F).withOpacity(0.2),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: AppSize.height(context, 2),
                                ),
                                Text(
                                  "* First name",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  height: AppSize.height(context, 1),
                                ),
                                Container(
                                  height: AppSize.height(context, 9),
                                  width: MediaQuery.of(context).size.width,
                                  child: TextFormField(
                                    controller: viewModel.nameMailController,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'First Name is required!';
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
                                SizedBox(
                                  height: AppSize.height(context, 1),
                                ),
                                Text(
                                  "* Last Name",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  height: AppSize.height(context, 1),
                                ),
                                Container(
                                  height: AppSize.height(context, 9),
                                  width: MediaQuery.of(context).size.width,
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Last Name is required!';
                                      }
                                      return null;
                                    },
                                    controller: viewModel.lastMailController,
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
                                SizedBox(
                                  height: AppSize.height(context, 1),
                                ),
                                Text(
                                  "* Mobile number",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  height: AppSize.height(context, 1),
                                ),
                                Container(
                                  height: AppSize.height(context, 9),
                                  width: MediaQuery.of(context).size.width,
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Mobile Number is required!';
                                      }
                                      return null;
                                    },
                                    controller: viewModel.mobileController,
                                    keyboardType: TextInputType.number,
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
                                SizedBox(
                                  height: AppSize.height(context, 1),
                                ),
                                Text(
                                  "* OTP",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  height: AppSize.height(context, 1),
                                ),
                                Container(
                                  height: AppSize.height(context, 9),
                                  width: MediaQuery.of(context).size.width,
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'OTP is required!';
                                      }
                                      return null;
                                    },
                                    controller: viewModel.VCcontroller,
                                    keyboardType: TextInputType.number,
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
                                        suffixIcon: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 12.0, top: 10),
                                          child: GestureDetector(
                                            onTap: () {
                                              if(viewModel.mobileController.text.isEmpty){
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    backgroundColor: Colors.red,
                                                    duration: const Duration(seconds: 2),
                                                    content: AppText(
                                                      'Enter Mobile Number First!',
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                );
                                              }

                                            else if(viewModel.mobileController.text.length!=10){
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    backgroundColor: Colors.red,
                                                    duration: const Duration(seconds: 2),
                                                    content: AppText(
                                                      'Enter 10 Digits Mobile Number!',
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                );
                                              }
                                             else  {
                                              viewModel.fetchSendOTP(
                                              context,
                                              );
                                              }

                                            },
                                            child: AppText("Get OTP",
                                                style: TextStyle(
                                                    color: Color(0xffF5591F),
                                                    fontSize: 15)),
                                          ),
                                        ),
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
                                            viewModel.ButtonButtonController,
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
                                            viewModel.fetchverifymobileotp(
                                              context,
                                            );
                                          }
                                        },
                                        height: AppSize.height(context, 6),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        controller:
                                            viewModel.ButtonButtonController,
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
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
