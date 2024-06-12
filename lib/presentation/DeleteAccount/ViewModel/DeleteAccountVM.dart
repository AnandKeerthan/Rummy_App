import 'package:dsrummy/App_Export/app_export.dart';
import 'package:dsrummy/Utlilities/AppColors/AppColors.dart';
import 'package:dsrummy/api_service/Remote/Response/ApiResponse.dart';
import 'package:dsrummy/presentation/DeleteAccount/Model/DeleteAccountModel.dart';
import 'package:dsrummy/presentation/DeleteAccount/Repo/DeleteAccountRepo.dart';
import 'package:dsrummy/presentation/RegisterScreen/View/RegisterScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeleteAccountVM extends ChangeNotifier {
  final _myRepo1 = DeleteAccountRepository();

  ApiResponse<DeleteAccount> verifyModel = ApiResponse.loading();

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

  Future<void> fetchDeteleAccount(BuildContext context) async {
    setLoading(true);

    await _myRepo1.postRegister().then((value) async {
      setLoading(false);
      if (value.status == true) {
        await clearSharedPreferences();
        storeLogInStatus(false);
        Get.snackbar("Delete Account", value.message!.toString(),
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 2),
            backgroundColor: AppColors.green,
            margin: const EdgeInsets.all(10),
            colorText: Colors.white);

        if (context.mounted) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => RegisterScreen()),
              (route) => false);
        }
        if (kDebugMode) {
          print("!!!!!!!!!!!!!!!!!!${value.toString()}");
        }
      } else if (value.status == false) {
        // Utils.snackBar(value.message!);
        Get.snackbar("Forgot", value.message.toString(),
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 2),
            backgroundColor: AppColors.red,
            margin: const EdgeInsets.all(10),
            colorText: Colors.white);

        if (kDebugMode) {
          print(value.toString());
          print("=========${value.toString()}");
        }
      } else {}
    }).onError((error, stackTrace) {
      setLoading(false);
      //Utils.snackBarErrorMessage(error.toString());

      Get.snackbar("Forgot", error.toString(),
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

  Future<void> clearSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  void storeLogInStatus(bool loginstatus) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("Loginstatus", loginstatus);
  }

  void storeID(String Token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("userToken", Token);
  }
}
