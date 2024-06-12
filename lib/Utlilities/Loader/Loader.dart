import 'package:flutter/material.dart';

import '../Images/image_constant.dart';

Widget loaderWidget() {
  return const SizedBox(
    child: Center(
      child: CircularProgressIndicator(),
    ),
  );
}

Widget buildCustomColumn(Color backgroundColor, double radius, IconData icon,
    String text, TextStyle textStyle, BuildContext context) {
  return Column(
    children: [
      CircleAvatar(
        backgroundColor: Theme.of(context).canvasColor,
        radius: radius,
        child: Icon(
          icon, color: Theme.of(context).backgroundColor,
          size: 25,
        ),
      ),
      SizedBox(height: 4), // Add some space between the icon and the text

      Text(
        text,
        style: textStyle,
      )
    ],
  );
}

class LoadingWidget extends StatefulWidget {
  double? height;
  LoadingWidget({Key? key, this.height}) : super(key: key);

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Center(
        child: Image.asset(
          ImageConstant.cardLoader,
          height: 50,
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }
}
