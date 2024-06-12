import 'package:dsrummy/Utlilities/Images/image_constant.dart';
import 'package:dsrummy/Utlilities/Mediaquery/Mediaquery.dart';
import 'package:dsrummy/presentation/GetProfile_Screen/ViewModel/GetProfileVm.dart';
import 'package:dsrummy/presentation/PlayNow/PlayBattle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class PlayNow extends StatefulWidget {
  bool? playerStatus;
  dynamic amount;
  bool? cpu = false;

  PlayNow({Key? key, this.playerStatus = false, required this.amount, this.cpu})
      : super(key: key);

  @override
  State<PlayNow> createState() => _PlayNowState();
}

class _PlayNowState extends State<PlayNow> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        //endDrawer: drawer(),
        key: _key,
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ImageConstant.bg),
                  fit: BoxFit.fill,
                ),
              ),
              child: Stack(
                children: [
                  // Align(
                  // alignment: Alignment.topCenter,
                  // child: Container(
                  // width: FibitSize.width(context, 100),
                  // height: FibitSize.height(context, 10.5),
                  // decoration: BoxDecoration(
                  // image: DecorationImage(
                  // alignment: Alignment.bottomCenter,
                  // image: AssetImage(
                  // ImageConstant.bb,
                  // ),
                  // fit: BoxFit.fill,
                  // ),
                  // ),
                  // ),
                  // )
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: 400,
                      color: Colors.black,
                      height: 27,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 3.0,
                              right: 3,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  children: [
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: '',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontFamily: 'Kanit',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          TextSpan(
                                            text: '',
                                            style: TextStyle(
                                              color: Color(0xFFFFC600),
                                              fontSize: 12,
                                              fontFamily: 'Kanit',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  // Padding(
                  //   padding:
                  //       const EdgeInsets.only(left: 15.0, right: 15, top: 8),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       SizedBox(),
                  //       GestureDetector(
                  //           onTap: () {
                  //             _key.currentState!.openEndDrawer();
                  //           },
                  //           child: Image.asset(ImageConstant.meni1)),
                  //     ],
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        widget.playerStatus == true
                            ? Align(
                                alignment: Alignment.topCenter,
                                child: Image.asset(
                                  ImageConstant.userr,
                                  height: 40,
                                ))
                            : SizedBox(),
                        Align(
                            alignment: Alignment.topCenter,
                            child: Image.asset(
                              ImageConstant.userr,
                              height: 40,
                            )),
                        widget.playerStatus == true
                            ? Align(
                                alignment: Alignment.topCenter,
                                child: Image.asset(
                                  ImageConstant.userr,
                                  height: 40,
                                ))
                            : SizedBox(),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 0.0,
                    right: 0.0,
                    top: 55.66,
                    child: Column(
                      children: [
                        Container(
                          width: AppSize.width(context, 100),
                          height: AppSize.height(context, 70.5),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(ImageConstant.board),
                              fit: BoxFit.fill,
                            ),
                          ),
                          child: Stack(
                            clipBehavior: Clip.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: AppSize.width(context, 100),
                      height: AppSize.height(context, 20.5),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          alignment: Alignment.bottomCenter,
                          image: AssetImage(ImageConstant.blackbox),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: AppSize.width(context, 100),
                      height: AppSize.height(context, 10.5),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          alignment: Alignment.bottomCenter,
                          image: AssetImage(ImageConstant.bb),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Align(
                              alignment: Alignment.bottomCenter,
                              child: SizedBox(
                                height: 100,
                                width: 150,
                                child: Image.asset(
                                  ImageConstant.userr,
                                  height: 100,
                                ),
                              )),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            PlayBattle(
                playerStatus: widget.playerStatus!,
                amount: widget.amount,
                cpu: widget.cpu ?? false)
          ],
        ),
      ),
    );
  }
}

class ShapesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    double height = 45;
    double width = 280;

    // set the paint color to be white
    paint.color = Colors.white;

    paint.color = Colors.yellow;

    // create a path
    var path = Path();
    path.lineTo(height - 20, height - 20);
    path.quadraticBezierTo(width - 30, height - 20, width - 30, height - 20);
    path.lineTo(
      width - 10,
      1,
    );
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
