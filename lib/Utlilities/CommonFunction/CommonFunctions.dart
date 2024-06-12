import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CommonFunctions {
  static String maskedAddress(String? value) {
    return value != null
        ? "${value.substring(0, 2)}...${value.substring(value.length - 4, value.length)}"
        : "";
  }

  static List<TextInputFormatter> eightDecimals() {
    return [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,8}'))];
  }

  static String maskedEmail(String input) {
    String first = "${input.substring(0, 2)}**";
    String mid = "${input.substring(input.indexOf("@")).substring(0, 1)}**";
    String last = input.substring(input.lastIndexOf("."));
    return first + mid + last;
  }

  static String formatDateTimeGMTIndia(String input) {
    DateTime dateTime =
        DateTime.parse(input).add(const Duration(hours: 5, minutes: 30));
    var formattedTime = DateFormat('yyyy-MMM-dd').add_jms().format(dateTime);
    return formattedTime.toString();
  }
}
