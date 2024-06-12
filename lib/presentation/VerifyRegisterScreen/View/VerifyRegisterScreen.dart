import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:dsrummy/app_export/app_export.dart';
import 'package:dsrummy/presentation/RegisterScreen/ViewModel/RegisterViewModel.dart';
import 'package:dsrummy/presentation/ResetPassword_Screen/View/ResetPassword_Screen.dart';
import 'package:dsrummy/presentation/VerifyRegisterScreen/ViewModel/VerifyRegisterVm.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class VerifyRegisterView extends StatefulWidget {
  String Email;
  String Password;
  VerifyRegisterView({super.key, required this.Email, required this.Password});

  @override
  State<VerifyRegisterView> createState() => _VerifyRegisterViewState();
}

class _VerifyRegisterViewState extends State<VerifyRegisterView> {
  late VerifyRegisterVM viewModel;

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

  bool isLoginEnabled() {
    return viewModel.newPinController.text.isNotEmpty;
  }

  late RegisterVM registerVM;

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<VerifyRegisterVM>();
    registerVM = context.watch<RegisterVM>();

    return ConnectivityScreenWrapper(
      positionOnScreen: PositionOnScreen.TOP,
      message: "Check Your Internet Connection",
      height: MediaQuery.of(context).viewPadding.top,
      disableInteraction: false,
      child: WillPopScope(
        onWillPop: () async {
          final shouldPop = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: Color(0xff111613),
                title: const Text(
                  'Are you sure want to go back?',
                  style: TextStyle(color: Colors.white),
                ),
                actionsAlignment: MainAxisAlignment.spaceBetween,
                actions: [
                  TextButton(
                    onPressed: () {
                      viewModel.newPinController.clear();
                      Navigator.pop(context, true);
                    },
                    child: const Text('Yes'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: const Text('No'),
                  ),
                ],
              );
            },
          );
          return shouldPop!;
        },
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
                          "OTP Verification",
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
                              height: AppSize.height(context, 3),
                            ),
                            Center(
                              child: Pinput(
                                controller: viewModel.newPinController,
                                length: 6,
                                defaultPinTheme: resetPinTheme(context),
                                onCompleted: (pin) {
                                  //viewModel.createMPin();
                                },
                              ),
                            ),
                            SizedBox(
                              height: AppSize.height(context, 2),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  child: AppText(
                                    "Resend OTP",
                                    color: Color(0xffF5591F),
                                  ),
                                  onTap: () {
                                    registerVM.fetchRegister(context);
                                  },
                                ),
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
                                        viewModel.regiterButtonController,
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
                                      isLoginEnabled()? viewModel.fetchVerify(context,
                                          email: widget.Email,
                                          password: widget.Password):  ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          backgroundColor: Colors.red,
                                          duration: const Duration(seconds: 2),
                                          content: AppText(
                                            'Enter your OTP first',
                                            color: Colors.white,
                                          ),
                                        ),
                                      );
                                    },
                                    height: AppSize.height(context, 6),
                                    width: MediaQuery.of(context).size.width,
                                    controller:
                                        viewModel.regiterButtonController,
                                    animateOnTap: isLoginEnabled(),
                                    elevation: 0,
                                    color: isLoginEnabled()
                                        ? Color(0xffF5591F)
                                        : Colors.grey[300],
                                    child: const Text("Verify OTP",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18)),
                                  )),
                            ),
                            SizedBox(
                              height: AppSize.height(context, 3),
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
    );
  }
}
