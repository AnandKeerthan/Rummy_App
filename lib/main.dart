import 'package:dsrummy/ProviderController/Get_All_Providers/get_all_providers.dart';
import 'package:dsrummy/Utlilities/ThemeMode/ThemeProvider/ThemeProvider.dart';
import 'package:dsrummy/Utlilities/ThemeMode/ThemeStyle/ThemeStyle.dart';
import 'package:dsrummy/app_export/app_export.dart';
import 'package:dsrummy/presentation/PlayNow/SequenceList.dart';
import 'package:flutter/material.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';

import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:get/get.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:shared_value/shared_value.dart';

import 'presentation/SplashScreen/Splashscreen.dart';

final samllCardSpriteSheet =
    SpriteSheet.fromColumnsAndRows(image: b.value, columns: 13, rows: 5);
var image;
ValueNotifier<dynamic> b = ValueNotifier("");

Future<void> fetchData() async {
  if (sequence54.$.isEmpty) {
    String jsonString =
        await rootBundle.loadString('assets/json/sequence.json');
    List<List<int>> convertedData = List<List<int>>.from(
        json.decode(jsonString).map((list) => List<int>.from(list)));
    sequence54.$ = convertedData;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  b.value = await Flame.images.load("sprint_cards_small.png");
  image = await Flame.images
      .load("sprint_cards_small.png")
      .then((value) => samllCardSpriteSheet.getSprite(1, 1));
  runApp(ConnectivityAppWrapper(app: SharedValue.wrapApp(MyApp())));
  await fetchData();
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  ThemeProvider themeChangeProvider = ThemeProvider();
  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: getAllProviders(),
      child: ChangeNotifierProvider(
        create: (_) => themeChangeProvider,
        child: Consumer<ThemeProvider>(builder: (context, value, child) {
          return Sizer(builder: (context, orientation, deviceType) {
            return GetMaterialApp(
              builder: (context, child) => ResponsiveWrapper.builder(child,
                  maxWidth: 1280,
                  minWidth: 480,
                  defaultScale: true,
                  breakpoints: [
                    /* ResponsiveBreakpoint.resize(480, name: MOBILE),
                          ResponsiveBreakpoint.autoScale(800, name: TABLET),
                          ResponsiveBreakpoint.resize(1000, name: DESKTOP),*/
                    const ResponsiveBreakpoint.resize(450, name: MOBILE),
                    const ResponsiveBreakpoint.autoScale(800, name: MOBILE),
                    const ResponsiveBreakpoint.autoScale(1000, name: TABLET),
                  ],
                  background: Container(
                    color: Colors.black,
                  )),
              scaffoldMessengerKey: scaffoldMessengerKey,
              title: 'DsRummy',
              debugShowCheckedModeBanner: false,
              home: AnimatedSplashScreen(),
            );
          });
        }),
      ),
    );
  }
}
