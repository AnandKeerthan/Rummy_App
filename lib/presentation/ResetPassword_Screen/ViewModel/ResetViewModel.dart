import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Utlilities/Toast/StatusMessages.dart';
import '../../../api_service/Remote/Response/ApiResponse.dart';
import '../../../app_export/app_export.dart';
import '../../Login_Screen/View/loginScreen_View.dart';
import '../Model/ResetModel.dart';
import '../Repo/ResetRepo.dart';

class ResetVM extends ChangeNotifier {
  final _myRepo = ResetRepository();
  TextEditingController PasswordController = TextEditingController();
  TextEditingController ConfirmPasswordController = TextEditingController();
  bool obscureText = true;
  RoundedLoadingButtonController resetButtonController =
      RoundedLoadingButtonController();

  ApiResponse<ResetModel> loginModel = ApiResponse.loading();

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

  Future<void> fetchReset(BuildContext context) async {
    setLoading(true);
    String? token = await getUserToken();

    Map<String, dynamic> params = {
      "password": PasswordController.text,
      "confirmPassword": ConfirmPasswordController.text,
      "emailToken": token
    };
    print("Reset:::::::::::::${params}");
    _myRepo.postRegister(params).then((value) {
      setLoading(false);

      if (value.status == true) {
        Get.snackbar("Reset Password", value.message!.toString(),
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 2),
            backgroundColor: AppColors.green,
            margin: const EdgeInsets.all(10),
            colorText: Colors.white);
        resetButtonController.reset();
        PasswordController.clear();
        ConfirmPasswordController.clear();

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Login()),
          (route) => false,
        );
        if (kDebugMode) {
          print("!!!!!!!!!!!!!!!!!!${value.toString()}");
        }
      } else if (value.status == false) {
        // Utils.snackBar(value.message!);
        Get.snackbar("Reset Password", value.message.toString(),
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 2),
            backgroundColor: AppColors.red,
            margin: const EdgeInsets.all(10),
            colorText: Colors.white);
        resetButtonController.reset();

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

      Get.snackbar("Reset Password", error.toString(),
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 2),
          backgroundColor: AppColors.red,
          margin: const EdgeInsets.all(10),
          colorText: Colors.white);
      resetButtonController.reset();
      if (kDebugMode) {
        print(error.toString());

        print("+++++++++${error.toString()}");
      }
    });
  }

  Future<String?> getUserToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("userToken");
  }
}
