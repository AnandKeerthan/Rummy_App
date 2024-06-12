import 'package:dsrummy/presentation/GetProfile_Screen/ViewModel/GetProfileVm.dart';
import 'package:dsrummy/presentation/LoginVerificationScreen/View/LoginVerificationScreen.dart';
import 'package:dsrummy/presentation/RootScreen.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Utlilities/Toast/StatusMessages.dart';
import '../../../api_service/Remote/Response/ApiResponse.dart';
import '../../../app_export/app_export.dart';
import '../Model/LoginModel.dart';
import '../Repo/LoginRepo.dart';

class LoginVM extends ChangeNotifier {
  final _myRepo = LoginRepository();
  TextEditingController loginMailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();
  bool obscureText = true;
  RoundedLoadingButtonController LoginButtonController =
      RoundedLoadingButtonController();
  ApiResponse<LoginModel> loginModel = ApiResponse.loading();
  bool get signUpLoading => _signUpLoading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  GetProfileVM getProfileVM = GetProfileVM();

  bool close = false;
  bool _loading = false;
  bool get loading => _loading;

  bool _signUpLoading = false;

  setSignUpLoading(bool value) {
    _signUpLoading = value;
    notifyListeners();
  }

  Future<void> fetchLogin(BuildContext context) async {
    setLoading(true);
    Map<String, dynamic> params = {
      "email": loginMailController.text,
      "password": loginPasswordController.text
    };

    try {
      var loginResponse = await _myRepo.postRegister(params);

      if (loginResponse.status == true) {
        formFillSts(false);

        storeLogInStatus(true);
        storeLoginMail(loginMailController.text);
        storeID(loginResponse.token.toString());

        Get.snackbar("Login", loginResponse.message!.toString(),
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 2),
            backgroundColor: AppColors.green,
            margin: const EdgeInsets.all(10),
            colorText: Colors.white);
        loginMailController.clear();
        loginPasswordController.clear();

        LoginButtonController.reset();
        // WidgetsBinding.instance.addPostFrameCallback((_) {
        //   Provider.of<GetProfileVM>(context, listen: false)
        //       .FetchProfile(context);
        // });
        // print(
        //     "33333333${getProfileVM.ffeaturedProductsModelModel.data?.data?.user?.mobileVerifyStatus}");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RootScreen(),
          ),
        );
      } else {
        Get.snackbar("Login", loginResponse.message.toString(),
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 2),
            backgroundColor: AppColors.red,
            margin: const EdgeInsets.all(10),
            colorText: Colors.white);
        LoginButtonController.reset();
      }
    } catch (error) {
      Get.snackbar("Login", error.toString(),
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 2),
          backgroundColor: AppColors.red,
          margin: const EdgeInsets.all(10),
          colorText: Colors.white);
      LoginButtonController.reset();
    } finally {
      setLoading(false);
    }
  }

  void storeID(String Token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("userToken", Token);
  }

  void storeLogInStatus(bool loginstatus) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("Loginstatus", loginstatus);
  }

  void storeLoginMail(String loginMail) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("loginMail", loginMail);
  }

  void formFillSts(bool sts) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("fillStatus", sts);
  }
}
/*
String? userId = await storeID();
void storeID(String Id) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString("userID", Id);
}
*/
