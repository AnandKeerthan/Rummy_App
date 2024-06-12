import 'package:dsrummy/app_export/app_export.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({Key? key}) : super(key: key);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
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
                              "RESULT",
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
                            AppText(
                              "Game ID :",
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: ColorConstant.yellow,
                            ),
                            SizedBox(
                              width: AppSize.width(context, 2),
                            ),
                            AppText(
                              "454125888",
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: ColorConstant.white,
                            ),
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
                    ResultImage(),
                  ],
                ),
                SizedBox(
                  height: AppSize.height(context, 3.5),
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
                          AppText(
                            "Please get ready.Game beginning in 3 second(s) ",
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: ColorConstant.ResultText,
                          ),
                          SizedBox(
                            width: AppSize.width(context, 3),
                          ),
                          Row(
                            children: [
                              AppText(
                                "JOKER",
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: ColorConstant.ResultText,
                              ),
                              SizedBox(
                                width: AppSize.width(context, 2),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Container(
                                  height: 45,
                                  width: 30,
                                  color: Colors.orange,
                                ),
                              )
                            ],
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

  Widget ResultImage() {
    return Column(
      children: [
        Container(
          height: AppSize.height(context, 15),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: ColorConstant.darkmerron,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    AppText(
                      "USERNAME",
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: ColorConstant.ResultText,
                    ),
                    SizedBox(
                      width: AppSize.width(context, 2),
                    ),
                    SizedBox(
                      height: AppSize.height(context, 15),
                      width: 1.5,
                      child: Container(
                        color: ColorConstant.apptheme,
                      ),
                    ),
                    SizedBox(
                      width: AppSize.width(context, 2),
                    ),
                    AppText(
                      "RESULT",
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: ColorConstant.ResultText,
                    ),
                    SizedBox(
                      width: AppSize.width(context, 2),
                    ),
                    SizedBox(
                      height: AppSize.height(context, 15),
                      width: 1.5,
                      child: Container(
                        color: ColorConstant.apptheme,
                      ),
                    ),
                    SizedBox(
                      width: AppSize.width(context, 2),
                    ),
                    AppText(
                      "CARDS",
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: ColorConstant.ResultText,
                    ),
                    SizedBox(
                      width: AppSize.width(context, 2),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      height: AppSize.height(context, 15),
                      width: 1.5,
                      child: Container(
                        color: ColorConstant.apptheme,
                      ),
                    ),
                    SizedBox(
                      width: AppSize.width(context, 2),
                    ),
                    AppText(
                      "SCORE",
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: ColorConstant.ResultText,
                    ),
                    SizedBox(
                      width: AppSize.width(context, 2),
                    ),
                    SizedBox(
                      height: AppSize.height(context, 15),
                      width: 1.5,
                      child: Container(
                        color: ColorConstant.apptheme,
                      ),
                    ),
                    SizedBox(
                      width: AppSize.width(context, 2),
                    ),
                    AppText(
                      "WON",
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: ColorConstant.ResultText,
                    ),
                    SizedBox(
                      width: AppSize.width(context, 2),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Container(
          height: AppSize.height(context, 15),
          decoration: BoxDecoration(
            color: ColorConstant.apptheme,
            // image: DecorationImage(
            //   image: AssetImage(ImageConstant.bg),
            //   fit: BoxFit.fill,
            // ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(ImageConstant.you),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: AppSize.width(context, 1),
                        ),
                        AppText(
                          "YOU",
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: ColorConstant.ResultText,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: AppSize.width(context, 3.4),
                    ),
                    SizedBox(
                      height: AppSize.height(context, 15),
                      width: 1.5,
                      child: Container(
                        color: ColorConstant.apptheme,
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 80,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(ImageConstant.winnerlabel),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: AppSize.height(context, 15),
                      width: 1.5,
                      child: Container(
                        color: ColorConstant.apptheme,
                      ),
                    ),
                    SizedBox(
                      width: AppSize.width(context, 2),
                    ),
                    AppText(
                      "",
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: ColorConstant.ResultText,
                    ),
                    SizedBox(
                      width: AppSize.width(context, 2),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      height: AppSize.height(context, 15),
                      width: 1.5,
                      child: Container(
                        color: ColorConstant.apptheme,
                      ),
                    ),
                    SizedBox(
                      width: AppSize.width(context, 5),
                    ),
                    AppText(
                      "0",
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: ColorConstant.ResultText,
                    ),
                    SizedBox(
                      width: AppSize.width(context, 4),
                    ),
                    SizedBox(
                      height: AppSize.height(context, 15),
                      width: 1.5,
                      child: Container(
                        color: ColorConstant.apptheme,
                      ),
                    ),
                    SizedBox(
                      width: AppSize.width(context, 2),
                    ),
                    AppText(
                      "-540",
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: ColorConstant.ResultText,
                    ),
                    SizedBox(
                      width: AppSize.width(context, 2),
                    ),
                  ],
                )
              ],
            ),
          ),
          width: MediaQuery.of(context).size.width,
        ),
        Container(
            height: AppSize.height(context, 15),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: ColorConstant.darkmerron,
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: SizedBox(
                              child: AppText(
                                "8938439735",
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                overflow: TextOverflow.ellipsis,
                                color: ColorConstant.ResultText,
                              ),
                              width: 70,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: AppSize.width(context, 3.4),
                      ),
                      SizedBox(
                        height: AppSize.height(context, 15),
                        width: 1.5,
                        child: Container(
                          color: ColorConstant.apptheme,
                        ),
                      ),
                      Container(
                        height: 40,
                        width: 80,
                        color: Colors.transparent,
                        child: Center(
                          child: AppText(
                            "Lost",
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: ColorConstant.ResultText,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: AppSize.height(context, 15),
                        width: 1.5,
                        child: Container(
                          color: ColorConstant.apptheme,
                        ),
                      ),
                      SizedBox(
                        width: AppSize.width(context, 2),
                      ),
                      AppText(
                        "",
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: ColorConstant.ResultText,
                      ),
                      SizedBox(
                        width: AppSize.width(context, 2),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: AppSize.height(context, 15),
                        width: 1.5,
                        child: Container(
                          color: ColorConstant.apptheme,
                        ),
                      ),
                      SizedBox(
                        width: AppSize.width(context, 5),
                      ),
                      AppText(
                        "545",
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: ColorConstant.ResultText,
                      ),
                      SizedBox(
                        width: AppSize.width(context, 3),
                      ),
                      SizedBox(
                        height: AppSize.height(context, 15),
                        width: 1.5,
                        child: Container(
                          color: ColorConstant.apptheme,
                        ),
                      ),
                      SizedBox(
                        width: AppSize.width(context, 2),
                      ),
                      AppText(
                        "-540",
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: ColorConstant.ResultText,
                      ),
                      SizedBox(
                        width: AppSize.width(context, 2),
                      ),
                    ],
                  )
                ],
              ),
            )),
      ],
    );
  }
}
