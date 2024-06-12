import 'package:dsrummy/Utlilities/Toast/StatusMessages.dart';
import 'package:dsrummy/api_service/Remote/Response/ApiResponse.dart';
import 'package:dsrummy/app_export/app_export.dart';
import 'package:dsrummy/presentation/Login_Screen/View/loginScreen_View.dart';
import 'package:dsrummy/presentation/RegisterScreen/Model/RegisterModel.dart';
import 'package:dsrummy/presentation/RegisterScreen/Repo/RegisterRepo.dart';
import 'package:dsrummy/presentation/VerifyRegisterScreen/View/VerifyRegisterScreen.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class RegisterVM extends ChangeNotifier {
  final _myRepo = RegisterRepository();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController RefferalController = TextEditingController();

  bool obscureText = true;
  RoundedLoadingButtonController regiterButtonController =
      RoundedLoadingButtonController();

  ApiResponse<RegisterModel> registerModel = ApiResponse.loading();
  bool close = false;
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

  Future<void> fetchRegister(BuildContext context) async {
    setLoading(true);
    Map<String, dynamic> params = {
      "email": emailController.text,
      "password": passwordController.text,
    };
    //print("222222222222222${params}");
    _myRepo.postRegister(params).then((value) {
      setLoading(false);

      if (value.status == true) {
        // emailController.clear();
        // passwordController.clear();
        // RefferalController.clear();

        Get.snackbar("Register", value.message!.toString(),
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 2),
            backgroundColor: AppColors.green,
            margin: const EdgeInsets.all(10),
            colorText: Colors.white);
        regiterButtonController.reset();
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerifyRegisterView(
                Email: emailController.text,
                Password: passwordController.text,
              ),
            ));
        // Navigator.of(context).pushAndRemoveUntil(
        //   MaterialPageRoute(builder: (context) => Login()),
        //   (route) => false,
        // );
        if (kDebugMode) {
          // print("!!!!!!!!!!!!!!!!!!${value.toString()}");
        }
      } else if (value.status == false) {
        // Utils.snackBar(value.message!);
        Get.snackbar("Register", value.message.toString(),
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

      Get.snackbar("Register", error.toString(),
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 2),
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
