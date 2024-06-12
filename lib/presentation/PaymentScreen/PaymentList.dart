import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:dsrummy/App_Export/app_export.dart';
import 'package:dsrummy/Utlilities/Toast/ToastMessage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
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
                        "Payments Methods",
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
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                        width: MediaQuery.sizeOf(context).width,
                        decoration: listBox(context),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/images/goo.png",
                                    height: 30,
                                    width: 30,
                                  ),
                                  SizedBox(
                                    width: AppSize.width(context, 3),
                                  ),
                                  AppText(
                                    'Google Pay',
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  AppText(
                                    'Connect',
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ],
                          ),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                        width: MediaQuery.sizeOf(context).width,
                        decoration: listBox(context),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/images/phonepe1.png",
                                    height: 30,
                                    width: 30,
                                  ),
                                  SizedBox(
                                    width: AppSize.width(context, 3),
                                  ),
                                  AppText(
                                    'PhonePe',
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  AppText(
                                    'Connect',
                                    color: Colors.white,
                                  )
                                ],
                              )
                            ],
                          ),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                        width: MediaQuery.sizeOf(context).width,
                        decoration: listBox(context),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/images/paytm1.png",
                                    height: 30,
                                    width: 30,
                                  ),
                                  SizedBox(
                                    width: AppSize.width(context, 3),
                                  ),
                                  AppText(
                                    'Paytm',
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  AppText(
                                    'Connect',
                                    color: Colors.white,
                                  )
                                ],
                              )
                            ],
                          ),
                        )),
                  ),
                  Expanded(child: SizedBox()),
                  GestureDetector(
                    onTap: () async {
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      var status = prefs.getBool("Loginstatus") ?? false;
                      if (status == false) {
                        ToastCommon.errorMessage("Please login to continue!");
                      }
                      ToastCommon.message("Coming Soon");
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: listBox(context),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: AppText(
                            'Continue',
                            color: Colors.white,
                            textAlign: TextAlign.center,
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
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
