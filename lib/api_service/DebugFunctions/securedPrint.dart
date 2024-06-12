// ignore_for_file: file_names

import 'package:dsrummy/app_export/app_export.dart';

class SecurePrint {
  SecurePrint(dynamic message) {
    if (kDebugMode) {
      print(message);
    }
  }
}
