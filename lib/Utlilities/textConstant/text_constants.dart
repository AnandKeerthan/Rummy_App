import 'package:dsrummy/Utlilities/Images/image_constant.dart';
import 'package:dsrummy/app_export/app_export.dart';
import 'package:flutter/material.dart';

class AppStyle {
  static Widget rummy = Center(
      child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(ImageConstant.sport, height: 25),
        SizedBox(
          width: 2,
        ),
        AppText(
          textConstants.rummy,
          fontSize: 12,
          color: ColorConstant.white,
          fontWeight: FontWeight.bold,
        ),
      ],
    ),
  ));
}

class textConstants {
  textConstants._();

  static String user = 'user';
  static String lobby = 'Lobby';
  static String menu = 'Menu';
  static String rummy = 'RUMMY';
  static String points = 'POINTS';

  static String pool = 'POOL';
  static String cash = 'CASH';
  static String practice = 'PRACTICE';
  static String deals = 'DEALS';

  static const String server_url = 'https://yahfresh.azurewebsites.net/';

  static const String picture_default_url =
      'https://yahfreshstorage.blob.core.windows.net/website-storage/default-image_450.png';

  static const String banner_1_url =
      'https://yahfreshstorage.blob.core.windows.net/website-storage/banner/banner1.png';
  static const String banner_2_url =
      'https://yahfreshstorage.blob.core.windows.net/website-storage/banner/banner2.png';
  // static const String server_url =
  //     'https://yahfresh-marudhu.azurewebsites.net/';
  // static const String user_id = '115939386452914835370';

  static String appName = 'YahFresh';
  static String appkey = 'AIzaSyA8fzS6zpVIaQrjRoHuc2jq_HqDjxcj9bg';

  static const String yahfresh_site_api_userName = 'apiuser@yahfresh.com';
  static const String yahfresh_site_api_password = '5CW56q%Jq*H(nyPXMFkGnTy';
  //"email":"apiuser@yahfresh.com",
  //"password":"NUNXNTZxJUpxKkgobnlQWE1Ga0duVHk="  // base64 format of the password

  static const String elasticsearch_url =
      'https://34717fc3c6784aad9e813a680e3be5be.uksouth.azure.elastic-cloud.com:9243';
  static const String elasticsearch_user = 'apiuser';
  static const String elasticsearch_password = 'Xyjd5H73#\$ao2vTvs\$\$23';
  static const String elasticsearch_index = 'yahfresh';

  static const String page_link_url = "yahfresh.page.link";
  static const String page_url = "yahfresh.com";
  static const String page_apn_name = "com.yahfresh.shop";
  static const String page_ibn_name = "com.yahfresh.shop";

  static const String currency_code = "AED";
  static String mobile_number_prefix = '+971';
  static String mobile_number_callme = "+971-65779979";
  static String mobile_number_whatsapp = "971528839979";
  static bool is_search_required = true;

  static String storeId = '5f6592818c6fcb4987ea49ae';
  static String registeredCustomerRole = '5f65928a8c6fcb4987ea4b06';
  static String countryId = '5f6592878c6fcb4987ea4a5f'; //uae
  static String stateId = '5f6614481f4e3c4653e5a4f9'; //sharjah

  static String paymentBaseUrl =
      'https://api-gateway.sandbox.ngenius-payments.com';
  static String paymentApiKey =
      'MWY1YjdmNTEtN2VjNC00YWJiLWFmYTktZDEyYTFkZDFlOGQ2OjI5ODdjYjcxLTFkNzYtNDg0Yy1iNzZiLTllOTZhOGVjOGQyMQ==';
  static String outletId = '8979b916-89d5-448a-8236-27906dd03ced';
  static bool isDemo = true;

  //Colors for theme
  static Color lightPrimary = Color(0xfffcfcff);
  static Color darkPrimary = Colors.black;
  static Color lightAccent = Colors.blue;
  static Color darkAccent = Colors.blueAccent;
  static Color lightBG = Color(0xfffcfcff);
  static Color darkBG = Colors.black;
  static Color badgeColor = Colors.red;

  static const double Tax = 5.0;

  static const Color background = Color(0XFFFFFFFF);

  static const Color titleTextColor = Color(0xff1d2635);
  static const Color subTitleTextColor = Color(0xff797878);

  static const Color skyBlue = Color(0xff2890c8);
  static const Color lightBlue = Color(0xff5c3dff);

  static const Color orange = Color(0xffE65829);
  static const Color red = Color(0xffF72804);

  static const Color lightGrey = Color(0xffE1E2E4);
  static const Color grey = Color(0xffA1A3A6);
  static const Color darkgrey = Color(0xff747F8F);

  static const Color iconColor = Color(0xffa8a09b);
  static const Color yellowColor = Color(0xfffbba01);

  static const Color black = Color(0xff20262C);
  static const Color lightblack = Color(0xff5F5F60);

  static TextStyle titleStyle =
      const TextStyle(color: titleTextColor, fontSize: 14);
  static TextStyle subTitleStyle =
      const TextStyle(color: subTitleTextColor, fontSize: 12);

  static TextStyle h1Style =
      const TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
  static TextStyle h2Style = const TextStyle(fontSize: 22);
  static TextStyle h3Style = const TextStyle(fontSize: 20);
  static TextStyle h4Style = const TextStyle(fontSize: 18);
  static TextStyle h5Style = const TextStyle(fontSize: 16);
  static TextStyle h6Style = const TextStyle(fontSize: 14);

  static List<BoxShadow> shadow = <BoxShadow>[
    BoxShadow(color: Color(0xfff8f8f8), blurRadius: 10, spreadRadius: 15),
  ];

  static EdgeInsets padding =
      const EdgeInsets.symmetric(horizontal: 20, vertical: 10);
  static EdgeInsets hPadding = const EdgeInsets.symmetric(
    horizontal: 10,
  );

  static double fullWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double fullHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static InputBorder enabledBorder =
      UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFeaeaea)));
  static InputBorder focusedBorder =
      UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFeaeaea)));

  static ThemeData lightTheme = ThemeData(
      backgroundColor: background,
      primaryColor: background,
      cardTheme: CardTheme(color: background),
      textTheme: TextTheme(headline4: TextStyle(color: black)),
      iconTheme: IconThemeData(color: iconColor),
      bottomAppBarColor: background,
      dividerColor: lightGrey,
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: enabledBorder,
        focusedBorder: focusedBorder,
      ),
      primaryTextTheme: TextTheme(
        bodyText2: TextStyle(color: titleTextColor),
      ),
      appBarTheme: AppBarTheme(elevation: 0),
      fontFamily: 'Proxima-Nova');
}

const TextStyle boldText = TextStyle(
  fontWeight: FontWeight.bold,
);

extension Precision on double {
  double toMoney(double fractionDigits) {
    var fills = this.toDouble();
    print("Fills value ${fills}");
    var amount = ((fills / fractionDigits).roundToDouble() * fractionDigits);
    return amount;
  }

  double toAEDMoney() {
    return toMoney(0.25);
  }
}
