import 'package:dsrummy/App_Export/app_export.dart';
import 'package:flutter/material.dart';

class ProfileMenu extends StatefulWidget {
  const ProfileMenu({Key? key}) : super(key: key);

  @override
  State<ProfileMenu> createState() => _ProfileMenuState();
}

class _ProfileMenuState extends State<ProfileMenu> {
  String userId = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                userId,
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 25,
              width: 45,
              child: Image.asset(
                ImageConstant.person,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText(
                  'Online: ',
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
                // StreamBuilder(
                //     stream: onlineUser.getResponse,
                //     builder: (context, snapshot) {
                //       if (snapshot.hasData) {
                //         return AppText(
                //           snapshot.data.toString(),
                //           color: Color(0xFFFFC600),
                //           fontSize: 12,
                //           fontWeight: FontWeight.w400,
                //         );
                //       }
                //       return AppText(
                //         "0",
                //         color: Color(0xFFFFC600),
                //         fontSize: 12,
                //         fontWeight: FontWeight.w400,
                //       );
                //     }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
