import 'package:dsrummy/app_export/app_export.dart';
import 'package:dsrummy/presentation/GetProfile_Screen/ViewModel/GetProfileVm.dart';
import 'package:dsrummy/presentation/Lobby/Lobby.dart';
import 'package:dsrummy/presentation/Menu/View/ProfileMenu.dart';
import 'package:dsrummy/presentation/UserScreen/BeforeLoginUserScreen/BeforeLoginUser.dart';
import 'package:dsrummy/presentation/UserScreen/View/UserScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'LoginVerificationScreen/View/LoginVerificationScreen.dart';

class RootScreen extends StatefulWidget {
  RootScreen({
    Key? key,
  }) : super(key: key);

  @override
  RootScreenState createState() => RootScreenState();
}

class RootScreenState extends State<RootScreen> {
  var currentIndex = 0;
  GetProfileVM getProfileVM = GetProfileVM();

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  DateTime? _lastBackPressedTime;
  bool? loginStatus;
  bool? loginFromStatus;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      loginStatus = await getLogInStatus();

      if (loginStatus == true && mounted) {
        await Provider.of<GetProfileVM>(context, listen: false)
            .FetchProfile(context);
        print(
            "@@@Profile: ${getProfileVM.ffeaturedProductsModelModel.data?.toJson()}");

        if (getProfileVM.ffeaturedProductsModelModel.data?.data?.user
                ?.mobileVerifyStatus !=
            2) {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginVerificationScreen(Email: ""),
              ),
            );
          }
        }
      }
      // print("1111111${loginFromStatus}");
      // Provider.of<GetProfileVM>(context, listen: false).FetchProfile(context);
      // loginStatus = await getLogInStatus();
      // loginFromStatus = await getFormSts();

      // setState(() {
      // loginStatus;
      // loginFromStatus;

      // print(
      //     "222${getProfileVM.ffeaturedProductsModelModel.data?.data?.user?.mobileVerifyStatus}");
      // loginFromStatus == false &&
      //         getProfileVM.ffeaturedProductsModelModel.data?.data?.user
      //                 ?.mobileVerifyStatus ==
      //             0
      //     ? Navigator.pushReplacement(
      //         context,
      //         MaterialPageRoute(
      //           builder: (context) => LoginVerificationScreen(Email: ""),
      //         ),
      //       )
      //     : null;
      // });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getProfileVM = context.watch<GetProfileVM>();

    Widget? child;
    switch (currentIndex) {
      case 0:
        child = loginStatus == true ? User() : BeforeLoginUser();
        break;
      case 1:
        child = Lobby();
        break;
      // case 2:
      //   child = ProfileMenu();
      //   // child = DeviceIdWidget();
      //   break;
    }

    void ontabbar(int index) {
      setState(() {
        currentIndex = index;
      });
    }

    double _width = MediaQuery.of(context).size.width;
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
          SystemNavigator.pop();
        }

        SystemNavigator.pop(); // Close the app

        return true;
      },
      child: Scaffold(
        //backgroundColor: ColorConstant.apptheme,
        key: _key,

        body: SizedBox.expand(child: child),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: ColorConstant.gray300,
                blurRadius: 10,
              ),
            ],
          ),
          child: BottomNavigationBar(
            selectedLabelStyle: TextStyle(
              color: ColorConstant.apptheme,
            ),
            unselectedLabelStyle: TextStyle(
              color: ColorConstant.gray300,
            ),
            onTap: ontabbar,
            //onTap: (newIndex) => setState(() => currentIndex = newIndex),
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            items: [
              BottomNavigationBarItem(
                // icon: ImageIcon(AssetImage(ImageConstant.user)),

                icon: Container(
                  width: 33,
                  height: 33,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(ImageConstant.userp),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),

                // icon: SvgPicture.asset(ImageConstant.user),

                label: "user",
              ),
              BottomNavigationBarItem(
                  icon: SvgPicture.asset(ImageConstant.lobby), label: "lobby"),
              // BottomNavigationBarItem(
              //   icon: SvgPicture.asset(
              //     ImageConstant.menu,
              //   ),
              //   label: "menu",
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> getLogInStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("Loginstatus") ?? false;
  }

  Future<bool> getFormSts() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("fillStatus") ?? false;
  }
}
