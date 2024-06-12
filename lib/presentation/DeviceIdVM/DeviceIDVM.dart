import 'package:device_info_plus/device_info_plus.dart';

import '../../App_Export/app_export.dart';

class DeviceInfoViewModel extends ChangeNotifier {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  String? _deviceId;
  Future<void> initDeviceInfo() async {
    try {
      if (kIsWeb) {
        _deviceId = (await deviceInfoPlugin.webBrowserInfo).userAgent;
      } else {
        switch (defaultTargetPlatform) {
          case TargetPlatform.android:
            _deviceId = (await deviceInfoPlugin.androidInfo)
                .id; // Use 'id' instead of 'androidId'
            break;
          case TargetPlatform.iOS:
            _deviceId = (await deviceInfoPlugin.iosInfo).identifierForVendor;
            break;
          // Add cases for other platforms if needed
          default:
            _deviceId = 'Unknown platform';
        }
      }
    } catch (e) {
      print('Failed to get device info: $e');
    }
  }

  String? get deviceId => _deviceId;
}
