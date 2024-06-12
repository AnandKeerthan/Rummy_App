import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ThemeProvider/ThemeProvider.dart';

class ThemeButton extends StatefulWidget {
  const ThemeButton({Key? key}) : super(key: key);

  @override
  State<ThemeButton> createState() => _ThemeButtonState();
}

class _ThemeButtonState extends State<ThemeButton> {
  @override
  Widget build(BuildContext context) {
    //final themeProvider = Provider.of<ThemeProvider>(context);

    return Consumer(builder: (context, ThemeProvider themeNotifier, child) {
      return IconButton(
        color: Theme.of(context).backgroundColor,
        icon: Icon(
          themeNotifier.darkTheme ? Icons.brightness_3_sharp : Icons.wb_sunny,
          size: 30,
        ),
        onPressed: () {
          setState(() {
            themeNotifier.darkTheme
                ? themeNotifier.darkTheme = false
                : themeNotifier.darkTheme = true;
          });
        },
      );
    });
  }
}
