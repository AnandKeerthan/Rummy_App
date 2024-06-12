import 'package:shared_preferences/shared_preferences.dart';

import '../../../App_Export/app_export.dart';
import '../../../api_service/Remote/Response/ApiResponse.dart';
import '../Model/GetModel.dart';
import '../Repo/GetProfileRepo.dart';

class GetProfileVM extends ChangeNotifier {
  final _myRepo = GetProfileRepository();

  ApiResponse<GetProfileModel> ffeaturedProductsModelModel =
      ApiResponse.loading();

  void _setCoin(ApiResponse<GetProfileModel> response) {
    print("gettttgetProfile :: $response");
    ffeaturedProductsModelModel = response;
    print("WWWWWWWWWW  :: ${response.data?.data?.user?.email}");

    notifyListeners();
  }

  Future<void> FetchProfile(BuildContext context) async {
    _setCoin(ApiResponse.loading());
    await _myRepo.featuredProductsHome().then((value) {
      userID.$ = value.data?.user?.sId.toString();
      walletAddress.$ = value.data?.user?.userAddress.toString();
      formFillSts(value.data?.user?.mobileVerifyStatus == 2 ? true : false);
      _setCoin(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      _setCoin(ApiResponse.error(error.toString()));
    });
  }

  void formFillSts(bool sts) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("fillStatus", sts);
  }
}
