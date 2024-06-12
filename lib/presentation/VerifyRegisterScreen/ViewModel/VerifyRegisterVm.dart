import 'package:dsrummy/Utlilities/Toast/StatusMessages.dart';
import 'package:dsrummy/api_service/Remote/Response/ApiResponse.dart';
import 'package:dsrummy/app_export/app_export.dart';
import 'package:dsrummy/presentation/Login_Screen/View/loginScreen_View.dart';
import 'package:dsrummy/presentation/VerifyRegisterScreen/Model/VerifyRegisterOtp.dart';
import 'package:dsrummy/presentation/VerifyRegisterScreen/Repo/VerifyRegisterOtpRepo.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class VerifyRegisterVM extends ChangeNotifier {
  final _myRepo = VerifyOtpRegisterRepository();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController newPinController = TextEditingController();

  RoundedLoadingButtonController regiterButtonController =
      RoundedLoadingButtonController();

  ApiResponse<VerifyRegisterModel> registerModel = ApiResponse.loading();

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

  Future<void> fetchVerify(BuildContext context,
      {required String email, required String password}) async {
    setLoading(true);
    Map<String, dynamic> params = {
      "email": email,
      "password": password,
      "encryptOTP": int.parse(newPinController.text)
    };
    //print("222222222222222${params}");
    _myRepo.postRegister(params).then((value) {
      setLoading(false);

      if (value.status == true) {
        Get.snackbar("Verify OTP", value.message!.toString(),
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 2),
            backgroundColor: AppColors.green,
            margin: const EdgeInsets.all(10),
            colorText: Colors.white);
        newPinController.clear();
        regiterButtonController.reset();

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Login()),
          (route) => false,
        );
        if (kDebugMode) {
          // print("!!!!!!!!!!!!!!!!!!${value.toString()}");
        }
      } else if (value.status == false) {
        // Utils.snackBar(value.message!);
        Get.snackbar("Invalid OTP", value.message.toString(),
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 2),
            backgroundColor: AppColors.red,
            margin: const EdgeInsets.all(10),
            colorText: Colors.white);
        regiterButtonController.reset();

        if (kDebugMode) {
          print(value.toString());
          // print("=========${value.toString()}");
        }
      } else {
        Utils.snackBar(value.message!);
      }
    }).onError((error, stackTrace) {
      setLoading(false);
      //Utils.snackBarErrorMessage(error.toString());

      Get.snackbar("Invalid OTP", error.toString(),
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 2) ,
          backgroundColor: AppColors.red,
          margin: const EdgeInsets.all(10),
          colorText: Colors.white);
      regiterButtonController.reset();

      if (kDebugMode) {
        print(error.toString());

        // print("+++++++++${error.toString()}");
      }
    });
  }
}
