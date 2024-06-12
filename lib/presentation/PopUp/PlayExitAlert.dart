import 'package:dsrummy/app_export/app_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class PlayExitAlert extends StatefulWidget {
  void Function() onTap;
  PlayExitAlert({Key? key, required this.onTap}) : super(key: key);

  @override
  State<PlayExitAlert> createState() => _PlayExitAlertState();
}

class _PlayExitAlertState extends State<PlayExitAlert> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ColorConstant.apptheme,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.orange, width: 3),
          borderRadius: BorderRadius.all(Radius.circular(6.0))),
      content: Container(
          height: AppSize.height(context, 100),
          width: AppSize.width(context, 100),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ImageConstant.bg),
              fit: BoxFit.fill,
            ),
          ),
          // decoration:
          //     BoxDecoration(border: Border.all(color: Colors.orange, width: 3)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            AppText(
                              "LEAVE TABLE",
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: ColorConstant.yellow,
                            ),
                            SizedBox(
                              width: AppSize.width(context, 2),
                            ),
                            SizedBox(
                              height: 15,
                              width: 2,
                              child: Container(
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: AppSize.width(context, 1),
                            ),
                            // AppText(
                            //   "Game ID :",
                            //   fontSize: 13,
                            //   fontWeight: FontWeight.w700,
                            //   color: ColorConstant.yellow,
                            // ),
                            // SizedBox(
                            //   width: AppSize.width(context, 2),
                            // ),
                            // AppText(
                            //   "454125888",
                            //   fontSize: 13,
                            //   fontWeight: FontWeight.w700,
                            //   color: ColorConstant.white,
                            //),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                              child: Center(
                                  child: Icon(
                                Icons.close,
                                color: Colors.amber,
                              )),
                              decoration: ShapeDecoration(
                                  shape: CircleBorder(
                                      side: BorderSide(
                                          width: 1, color: Colors.amber)))),
                        )
                      ],
                    ),
                    SizedBox(
                      height: AppSize.height(context, 1),
                    ),
                  ],
                ),
                Container(
                  height: AppSize.height(context, 33),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: ColorConstant.darkmerron,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText(
                          "If you leave the table now, you will be dropped from the current game. The remaining amount will be credited back to your account.",
                          color: ColorConstant.ResultText,
                          textAlign: TextAlign.justify,
                        ),
                        SizedBox(
                          height: AppSize.height(context, 2.5),
                        ),
                        Center(
                          child: AppText(
                            "Are you sure you want to drop and leave .",
                            color: ColorConstant.ResultText,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: AppSize.height(context, 2.5),
                ),
                Container(
                  height: AppSize.height(context, 12),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: ColorConstant.darkmerron,
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          buttonRummy(
                            onPressed: widget.onTap,
                            color: ColorConstant.gren,
                            width: 150,
                            height: AppSize.height(context, 8),
                            child: AppText(
                              "DROP && LEAVE",
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: AppSize.width(context, 3),
                          ),
                          buttonRummy(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            width: 150,
                            height: AppSize.height(context, 8),
                            child: AppText(
                              "No",
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: AppSize.width(context, 3),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
