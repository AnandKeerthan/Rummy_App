import 'package:dsrummy/presentation/ResetPassword_Screen/View/ResetPassword_Screen.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Utlilities/Toast/StatusMessages.dart';
import '../../../api_service/Remote/Response/ApiResponse.dart';
import '../../../app_export/app_export.dart';
import '../Model/ForgetModel.dart';
import '../Model/VerifyOtpModel.dart';
import '../Repo/ForgotRepo.dart';

class ForgotVM extends ChangeNotifier {
  final _myRepo = ForgotRepository();
  final _myRepo1 = VerifyOtpRepository();

  TextEditingController ForgotMailController = TextEditingController();
  TextEditingController VCcontroller = TextEditingController();
  bool obscureText = true;
  RoundedLoadingButtonController forgotButtonController =
      RoundedLoadingButtonController();

  ApiResponse<ForgotModel> loginModel = ApiResponse.loading();
  ApiResponse<VerifyOtpModel> verifyModel = ApiResponse.loading();

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

  Future<void> fetchForgot(BuildContext context) async {
    setLoading(true);
    Map<String, dynamic> params = {
      "email": ForgotMailController.text,
    };
    print("222222222222222${params}");
    _myRepo.postRegister(params).then((value) {
      setLoading(false);

      if (value.status == true) {
        //Utils.snackBar(value.message!);
        storeID(value.token.toString());
        print("222222222222222${value.token.toString()}");

        Get.snackbar("Forgot", value.message!.toString(),
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 2),
            backgroundColor: AppColors.green,
            margin: const EdgeInsets.all(10),
            colorText: Colors.white);

        // Navigator.of(context).pushAndRemoveUntil(
        //   MaterialPageRoute(builder: (context) => Reset_Password_View()),
        //       (route) => false,
        // );
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
      } else {
        Utils.snackBar(value.message!);
      }
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

  Future<void> fetchVerifyOTP(BuildContext context) async {
    setLoading(true);
    Map<String, dynamic> params = {
      "encryptOTP": int.tryParse(VCcontroller.text) ?? 0,
      "email": ForgotMailController.text,
    };
    print("222222222222222${params}");
    _myRepo1.postRegister(params).then((value) {
      setLoading(false);

      if (value.status == true) {
        //Utils.snackBar(value.message!);

        Get.snackbar("Forgot", value.message!.toString(),
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 2),
            backgroundColor: AppColors.green,
            margin: const EdgeInsets.all(10),
            colorText: Colors.white);

        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => Reset_Password_View()),

        );
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
        forgotButtonController.reset();

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

      Get.snackbar("Forgot", error.toString(),
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 2),
          backgroundColor: AppColors.red,
          margin: const EdgeInsets.all(10),
          colorText: Colors.white);
      forgotButtonController.reset();
      if (kDebugMode) {
        print(error.toString());

        print("+++++++++${error.toString()}");
      }
    });
  }

  void storeID(String Token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("userToken", Token);
  }
}
