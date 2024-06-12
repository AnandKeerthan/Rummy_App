import 'package:dsrummy/app_export/app_export.dart';
import 'package:flutter/services.dart';

class Styles {
  static ThemeData themeData(
    bool isDarkTheme,
    BuildContext context,
  ) {
    return ThemeData(
      primaryColor: Color(0xFFf8c702),
      backgroundColor: isDarkTheme ? Colors.white : Colors.black,
      canvasColor: isDarkTheme ? Color(0xFF172330) : Color(0xFFfcfcfc),
      cardColor: isDarkTheme ? Color(0xFF1d2b3b) : Color(0xFFf9f9f9),
      chipTheme: ChipThemeData(
        backgroundColor: isDarkTheme ? Color(0xFF566675) : Colors.grey.shade100,
      ),
      iconTheme: IconThemeData(
        color: isDarkTheme
            ? Color(0xFF5D5955)
            : Color(
                0xFFF5F5F5), // Set your desired icon color based on the theme
        size: 24, // Set your desired icon size
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDarkTheme ? Colors.black : Colors.white,
        selectedItemColor: Color(0xFFf8c702),
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        unselectedItemColor: isDarkTheme ? Colors.grey : Colors.grey,
        elevation: 0,
      ),
    );
  }
}
