import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dsrummy/app_export/app_export.dart';
import 'package:dsrummy/presentation/DeviceIdVM/DeviceIDVM.dart';
import 'package:dsrummy/presentation/Login_Screen/View/loginScreen_View.dart';
import 'package:dsrummy/presentation/RegisterScreen/View/RegisterScreen.dart';
import 'package:dsrummy/presentation/RootScreen.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';

class AnimatedSplashScreen extends StatefulWidget {
  const AnimatedSplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<AnimatedSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late StreamController<int> _streamController;
  bool _isLoadingComplete = false;
  late DeviceInfoViewModel _deviceInfoViewModel;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2), // Change the duration as needed
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {}); // Update the UI when the animation value changes
      });

    _streamController = StreamController<int>();
    _streamController.stream.listen((value) {
      _controller.forward().whenComplete(() {
        if (value == 100) {
          setState(() {
            _isLoadingComplete = true;
          });
          Timer(Duration(milliseconds: 10), () {
            onTimerFinished();
          });
        }
      });
    });

    _deviceInfoViewModel = DeviceInfoViewModel();
    _initializeDeviceInfo();
    // initPlatformState();
    // _getAppBarTitle();
    _startAnimation();
  }

  Future<void> _initializeDeviceInfo() async {
    await _deviceInfoViewModel.initDeviceInfo();
    // Now you can access _deviceInfoViewModel.deviceId and use it across your app
    print('Device  99999999999 : ${_deviceInfoViewModel.deviceId}');
    // Navigate to the next screen
    // Navigator.push(context, MaterialPageRoute(builder: (context) => NextScreen()));
  }

  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};
  Future<void> initPlatformState() async {
    var deviceData = <String, dynamic>{};

    try {
      if (kIsWeb) {
        deviceData = _readWebBrowserInfo(await deviceInfoPlugin.webBrowserInfo);
      } else {
        switch (defaultTargetPlatform) {
          case TargetPlatform.android:
            deviceData =
                _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
            break;
          case TargetPlatform.iOS:
            deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
            break;
          case TargetPlatform.linux:
            deviceData = _readLinuxDeviceInfo(await deviceInfoPlugin.linuxInfo);
            break;
          case TargetPlatform.windows:
            deviceData =
                _readWindowsDeviceInfo(await deviceInfoPlugin.windowsInfo);
            break;
          case TargetPlatform.macOS:
            deviceData = _readMacOsDeviceInfo(await deviceInfoPlugin.macOsInfo);
            break;
          default:
            deviceData = <String, dynamic>{'Error': 'Platform not supported'};
        }
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
    });

    // Print device ID here
    print('Device ID: ${_deviceData["id"] ?? "Not available"}');
  }

  String _getAppBarTitle() => kIsWeb
      ? 'Web Browser info'
      : switch (defaultTargetPlatform) {
          TargetPlatform.android => 'Android Device Info',
          TargetPlatform.iOS => 'iOS Device Info',
          TargetPlatform.linux => 'Linux Device Info',
          TargetPlatform.windows => 'Windows Device Info',
          TargetPlatform.macOS => 'MacOS Device Info',
          TargetPlatform.fuchsia => 'Fuchsia Device Info',
        };
  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'systemFeatures': build.systemFeatures,
      'serialNumber': build.serialNumber,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  Map<String, dynamic> _readLinuxDeviceInfo(LinuxDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'version': data.version,
      'id': data.id,
      'idLike': data.idLike,
      'versionCodename': data.versionCodename,
      'versionId': data.versionId,
      'prettyName': data.prettyName,
      'buildId': data.buildId,
      'variant': data.variant,
      'variantId': data.variantId,
      'machineId': data.machineId,
    };
  }

  Map<String, dynamic> _readWebBrowserInfo(WebBrowserInfo data) {
    return <String, dynamic>{
      'browserName': data.browserName.name,
      'appCodeName': data.appCodeName,
      'appName': data.appName,
      'appVersion': data.appVersion,
      'deviceMemory': data.deviceMemory,
      'language': data.language,
      'languages': data.languages,
      'platform': data.platform,
      'product': data.product,
      'productSub': data.productSub,
      'userAgent': data.userAgent,
      'vendor': data.vendor,
      'vendorSub': data.vendorSub,
      'hardwareConcurrency': data.hardwareConcurrency,
      'maxTouchPoints': data.maxTouchPoints,
    };
  }

  Map<String, dynamic> _readMacOsDeviceInfo(MacOsDeviceInfo data) {
    return <String, dynamic>{
      'computerName': data.computerName,
      'hostName': data.hostName,
      'arch': data.arch,
      'model': data.model,
      'kernelVersion': data.kernelVersion,
      'majorVersion': data.majorVersion,
      'minorVersion': data.minorVersion,
      'patchVersion': data.patchVersion,
      'osRelease': data.osRelease,
      'activeCPUs': data.activeCPUs,
      'memorySize': data.memorySize,
      'cpuFrequency': data.cpuFrequency,
      'systemGUID': data.systemGUID,
    };
  }

  Map<String, dynamic> _readWindowsDeviceInfo(WindowsDeviceInfo data) {
    return <String, dynamic>{
      'numberOfCores': data.numberOfCores,
      'computerName': data.computerName,
      'systemMemoryInMegabytes': data.systemMemoryInMegabytes,
      'userName': data.userName,
      'majorVersion': data.majorVersion,
      'minorVersion': data.minorVersion,
      'buildNumber': data.buildNumber,
      'platformId': data.platformId,
      'csdVersion': data.csdVersion,
      'servicePackMajor': data.servicePackMajor,
      'servicePackMinor': data.servicePackMinor,
      'suitMask': data.suitMask,
      'productType': data.productType,
      'reserved': data.reserved,
      'buildLab': data.buildLab,
      'buildLabEx': data.buildLabEx,
      'digitalProductId': data.digitalProductId,
      'displayVersion': data.displayVersion,
      'editionId': data.editionId,
      'installDate': data.installDate,
      'productId': data.productId,
      'productName': data.productName,
      'registeredOwner': data.registeredOwner,
      'releaseId': data.releaseId,
      'deviceId': data.deviceId,
    };
  }

  void onTimerFinished() async {
    // SharePreference call to get login status
    bool loginStatus = await getLogInStatus();
    bool fillFormSts = await getFormSts();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => fillFormSts == false
            ? Login()
            : loginStatus
                ? RootScreen()
                : Login(),
      ),
      (route) => false,
    );

    // if (loginStatus) {
    //   SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    // }
  }

  PackageInfo? _packageInfo;
  void _startAnimation() async {
    for (int i = 1; i <= 100; i++) {
      _streamController.add(i);
      await Future.delayed(Duration(milliseconds: 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstant.black,
        body: Padding(
          padding: const EdgeInsets.only(top: 4.0, bottom: 4),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ImageConstant.splashGif),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ));
  }

  Future<bool> getLogInStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("Loginstatus") ?? false;
  }

  Future<bool> getFormSts() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("fillStatus") ?? false;
  }
}
