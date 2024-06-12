import 'package:dsrummy/Utlilities/Toast/StatusMessages.dart';
import 'package:dsrummy/api_service/Remote/Response/ApiResponse.dart';
import 'package:dsrummy/app_export/app_export.dart';
import 'package:dsrummy/presentation/GetProfile_Screen/ViewModel/GetProfileVm.dart';
import 'package:dsrummy/presentation/SupportScreen/Model/SupportModel.dart';
import 'package:dsrummy/presentation/SupportScreen/Repo/SupportRepo.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SupportVM extends ChangeNotifier {
  final _myRepo = SupportRepository();
  String mail = "";
  TextEditingController emailController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool obscureText = true;
  RoundedLoadingButtonController supportButtonController =
      RoundedLoadingButtonController();

  ApiResponse<supportModel> loginModel = ApiResponse.loading();
  GetProfileVM getProfileVM = GetProfileVM();

  bool _loading = false;
  bool get loading => _loading;

  bool _signUpLoading = false;
  bool get signUpLoading => _signUpLoading;

  int charCount = 0;
  final int maxCharCount = 1000;

  void updateCharCount(int count) {
    charCount = count;
    notifyListeners();
    // Notify the UI to update the character count
  }

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  setSignUpLoading(bool value) {
    _signUpLoading = value;
    notifyListeners();
  }

  Future<void> fetchSupport(BuildContext context) async {
    setLoading(true);
    String? token = await getUserToken();
    String? emails = await getUserEmail();
    print("!!!!!!!${emails}");
    Map<String, dynamic> params = {
      "email": mail,
      "description": descriptionController.text
    };
    print("paramsparams:::::::::::::${params}");
    _myRepo.postRegister(params).then((value) {
      setLoading(false);

      if (value.status == true) {
        Get.snackbar("Support ", value.message!.toString(),
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 2),
            backgroundColor: AppColors.green,
            margin: const EdgeInsets.all(10),
            colorText: Colors.white);
        supportButtonController.reset();
        descriptionController.clear();
        if (kDebugMode) {
          print("!!!!!!!!!!!!!!!!!!${value.toString()}");
        }
      } else if (value.status == false) {
        // Utils.snackBar(value.message!);
        Get.snackbar("Support", value.message.toString(),
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 2),
            backgroundColor: AppColors.red,
            margin: const EdgeInsets.all(10),
            colorText: Colors.white);
        supportButtonController.reset();

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
      supportButtonController.reset();
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

  Future<String?> getUserEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("email");
  }
}
