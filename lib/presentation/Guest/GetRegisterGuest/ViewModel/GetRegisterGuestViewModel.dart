import 'package:dsrummy/App_Export/app_export.dart';
import 'package:dsrummy/Utlilities/Toast/StatusMessages.dart';
import 'package:dsrummy/api_service/Remote/Response/ApiResponse.dart';
import 'package:dsrummy/presentation/Guest/GetRegisterGuest/Model/GetRegisterGuestModel.dart';
import 'package:dsrummy/presentation/Guest/GetRegisterGuest/Repo/GetRegisterGuestRepo.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetGusestRegisterVM extends ChangeNotifier {
  final _myRepo = GetGusestRegisterRepository();

  ApiResponse<GetRegisterGuest> getRegisterGuestModel = ApiResponse.loading();

  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void _setCoin(ApiResponse<GetRegisterGuest> response) {
    print("gettttgetProfile :: $response");
    getRegisterGuestModel = response;

    print("message :::: ${response.message.toString()}");
    notifyListeners();
  }

  Future<void> fetchRegisterGuest(BuildContext context) async {
    String? deviceId = await getDeviceId();
    Map<String, dynamic> params = {"deviceID": deviceId};
    print("params ---- ?? ${params}");
    _setCoin(ApiResponse.loading());
    await _myRepo.postRegister(params).then((value) {
      userID.$ = value.data?.id.toString();
      walletAddress.$ = value.data?.userAddress.toString();
      _setCoin(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      _setCoin(ApiResponse.error(error.toString()));
    });
  }

  void formFillSts(bool sts) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("fillStatus", sts);
  }

  Future<String?> getDeviceId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("DeviceId");
  }
}
