import 'package:flutter/material.dart';

import '../SharedPreference/SharedPerferance.dart';

class ThemeProvider with ChangeNotifier {
  DarkThemePreference darkThemePreference = DarkThemePreference();

  bool isDarkTheme = false;
  bool get darkTheme => isDarkTheme;

  set darkTheme(bool isOn) {
    isDarkTheme = isOn;
    darkThemePreference.setDarkTheme(isOn);
    // themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
