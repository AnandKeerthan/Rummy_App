import 'package:dsrummy/App_Export/app_export.dart';
import 'package:dsrummy/api_service/Remote/Response/ApiResponse.dart';
import 'package:dsrummy/presentation/2FA/Model/2FAModel.dart';
import 'package:dsrummy/presentation/2FA/Repo/2FARepo.dart';
import 'package:dsrummy/presentation/GetProfile_Screen/ViewModel/GetProfileVm.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class TFaVM extends ChangeNotifier {
  final _myRepo = TFARepository();

  TextEditingController otpController = TextEditingController();

  RoundedLoadingButtonController regiterButtonController =
      RoundedLoadingButtonController();

  ApiResponse<TwoFaModel> registerModel = ApiResponse.loading();

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
      {required String secret}) async {
    setLoading(true);
    Map<String, dynamic> params = {
      "secret": secret,
      "code": otpController.text
    };
    print("secret ${params}");
    _myRepo.postRegister(params).then((value) {
      setLoading(false);

      if (value.status == true) {
        Get.snackbar("2FA", value.message!.toString(),
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 2),
            backgroundColor: AppColors.green,
            margin: const EdgeInsets.all(10),
            colorText: Colors.white);
        otpController.clear();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Provider.of<GetProfileVM>(context, listen: false)
              .FetchProfile(context);
        });

        regiterButtonController.reset();

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
        otpController.clear();
        regiterButtonController.reset();

        if (kDebugMode) {
          print(value.toString());
          // print("=========${value.toString()}");
        }
      } else {}
    }).onError((error, stackTrace) {
      setLoading(false);
      //Utils.snackBarErrorMessage(error.toString());

      Get.snackbar("Invalid OTP", error.toString(),
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 2),
          backgroundColor: AppColors.red,
          margin: const EdgeInsets.all(10),
          colorText: Colors.white);
      otpController.clear();
      regiterButtonController.reset();

      if (kDebugMode) {
        print(error.toString());

        // print("+++++++++${error.toString()}");
      }
    });
  }
}
