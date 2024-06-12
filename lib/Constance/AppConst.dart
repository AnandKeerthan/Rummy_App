import 'package:flutter/material.dart';

class AppConst {
  static Duration balanceUpdateDuration = const Duration(seconds: 5);
}

ValueNotifier<bool> netConnection = ValueNotifier(false);

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static GlobalKey<ScaffoldMessengerState> scafoldKey =
      GlobalKey<ScaffoldMessengerState>();
}
