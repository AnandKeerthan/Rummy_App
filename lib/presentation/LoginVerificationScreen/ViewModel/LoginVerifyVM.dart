import 'package:dsrummy/api_service/Remote/Response/ApiResponse.dart';
import 'package:dsrummy/app_export/app_export.dart';
import 'package:dsrummy/presentation/GetProfile_Screen/ViewModel/GetProfileVm.dart';
import 'package:dsrummy/presentation/LoginVerificationScreen/Model/OtpVerifyLogin.dart';
import 'package:dsrummy/presentation/LoginVerificationScreen/Model/SendOTPModel.dart';
import 'package:dsrummy/presentation/LoginVerificationScreen/Repo/SendOTPRepo.dart';
import 'package:dsrummy/presentation/RootScreen.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyLoginVM extends ChangeNotifier {
  TextEditingController nameMailController = TextEditingController();
  TextEditingController lastMailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController VCcontroller = TextEditingController();
  bool obscureText = true;
  RoundedLoadingButtonController ButtonButtonController =
      RoundedLoadingButtonController();
  final _myRepo = SendOTPRepository();
  final _myRepo1 = VerifyOTPRepository();

  ApiResponse<SendOTPModel> loginModel = ApiResponse.loading();
  ApiResponse<OtpVerifyLogin> verify = ApiResponse.loading();

  bool _loading = false;
  bool get loading => _loading;

  bool _signUpLoading = false;
  bool get signUpLoading => _signUpLoading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  // Navigator.push(
  // context,
  // MaterialPageRoute(
  // builder: (context) => RootScreen(),
  // ));
  setSignUpLoading(bool value) {
    _signUpLoading = value;
    notifyListeners();
  }

  Future<void> fetchSendOTP(
    BuildContext context,
  ) async {
    setLoading(true);
    String? email = await getMail();
    print("getMai//// ${email}");
    int mobileNumber = int.tryParse(mobileController.text) ?? 0;

    Map<String, dynamic> params = {
      "firstName": nameMailController.text,
      "lastName": lastMailController.text,
      "mobileNumber": mobileNumber,
      "email": email
    };
    print("fetchSendOTP ::: ${params}");
    _myRepo.postRegister(params).then((value) {
      setLoading(false);
      if (value.status == true) {
        Get.snackbar("SendOTP", value.message!.toString(),
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 2),
            backgroundColor: AppColors.green,
            margin: const EdgeInsets.all(10),
            colorText: Colors.white);

        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => RootScreen()),
        // );

        if (kDebugMode) {
          print("!!!!!!!!!!!!!!!!!!${value.toString()}");
        }
      } else if (value.status == false) {
        // Utils.snackBar(value.message!);
        Get.snackbar("Login", value.message.toString(),
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
      Get.snackbar("Login", error.toString(),
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

  Future<void> fetchverifymobileotp(
    BuildContext context,
  ) async {
    String? email = await getMail();
    print("getMai//// ${email}");

    setLoading(true);
    Map<String, dynamic> params = {
      "email": email,
      "mobileOTP": VCcontroller.text
    };
    print("222222222222222${params}");
    _myRepo1.postRegister(params).then((value) {
      setLoading(false);
      if (value.status == true) {
        formFillSts(true);

        Get.snackbar("VerifyOTP", value.message!.toString(),
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 2),
            backgroundColor: AppColors.green,
            margin: const EdgeInsets.all(10),
            colorText: Colors.white);
        ButtonButtonController.reset();
        VCcontroller.clear();
        nameMailController.clear();
        mobileController.clear();
        lastMailController.clear();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Provider.of<GetProfileVM>(context, listen: false)
              .FetchProfile(context);
        });
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => RootScreen()),
        // );
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => RootScreen()),
          (route) => false,
        );
        if (kDebugMode) {
          print("!!!!!!!!!!!!!!!!!!${value.toString()}");
        }
      } else if (value.status == false) {
        // Utils.snackBar(value.message!);
        Get.snackbar("VerifyOTP", value.message.toString(),
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 2),
            backgroundColor: AppColors.red,
            margin: const EdgeInsets.all(10),
            colorText: Colors.white);
        ButtonButtonController.reset();

        if (kDebugMode) {
          print(value.toString());
          print("=========${value.toString()}");
        }
      } else {}
    }).onError((error, stackTrace) {
      setLoading(false);
      //Utils.snackBarErrorMessage(error.toString());
      Get.snackbar("VerifyOTP", error.toString(),
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 2),
          backgroundColor: AppColors.red,
          margin: const EdgeInsets.all(10),
          colorText: Colors.white);
      ButtonButtonController.reset();

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

  void formFillSts(bool sts) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("fillStatus", sts);
  }

  Future<String?> getMail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("loginMail");
  }
}
