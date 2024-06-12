import 'package:dsrummy/App_Export/app_export.dart';
import 'package:dsrummy/Utlilities/Toast/StatusMessages.dart';
import 'package:dsrummy/api_service/Remote/Response/ApiResponse.dart';
import 'package:dsrummy/presentation/Guest/GuestRegister/Repo/GuesetRegisterRepo.dart';
import 'package:dsrummy/presentation/Guest/GuestRegisterModel.dart';
import 'package:dsrummy/presentation/RootScreen.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GusestRegisterVM extends ChangeNotifier {
  final _myRepo = GusestRegisterRepository();

  ApiResponse<GuestRegisterModel> loginModel = ApiResponse.loading();

  bool _loading = false;
  bool get loading => _loading;

  bool _signUpLoading = false;
  bool get signUpLoading => _signUpLoading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  setSignUpLoading(bool value) {
    _signUpLoading = value;
    notifyListeners();
  }

  Future<void> fetchRegisterGuest(BuildContext context, String deviceId) async {
    setLoading(true);
    Map<String, dynamic> params = {"deviceID": deviceId};
    print("paramsparams:::::::::::::${params}");
    _myRepo.postRegister(params).then((value) {
      setLoading(false);

      if (value.message == "Guest Account already registered") {
        storeDeviceId(deviceId);

        formFillSts(true);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RootScreen(),
            ));
      } else if (value.status == true) {
        formFillSts(true);
        storeDeviceId(deviceId);

        Get.snackbar("Support ", value.message!.toString(),
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 2),
            backgroundColor: AppColors.green,
            margin: const EdgeInsets.all(10),
            colorText: Colors.white);

        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RootScreen(),
            ));

        if (kDebugMode) {
          print("!!!!!!!!!!!!!!!!!!${value.toString()}");
        }
      } else if (value.status == false) {
        formFillSts(true);
        storeDeviceId(deviceId);

        // Utils.snackBar(value.message!);
        Get.snackbar("Support", value.message.toString(),
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 2),
            backgroundColor: AppColors.red,
            margin: const EdgeInsets.all(10),
            colorText: Colors.white);

        if (kDebugMode) {
          print(value.toString());
          print("=========${value.toString()}");
        }
      } else {
        Utils.snackBar(value.message!);
      }
    }).onError((error, stackTrace) {
      setLoading(false);
      //Utils.snackBarErrorMessage(error.toString());

      Get.snackbar("Support", error.toString(),
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 2),
          backgroundColor: AppColors.red,
          margin: const EdgeInsets.all(10),
          colorText: Colors.white);
      if (kDebugMode) {
        print(error.toString());

        print("+++++++++${error.toString()}");
      }
    });
  }

  void formFillSts(bool sts) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("fillStatus", sts);
  }

  void storeDeviceId(String DeviceId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("DeviceId", DeviceId);
  }
}
