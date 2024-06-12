import '../../../api_service/Remote/Network/ApiEndPoints.dart';
import '../../../api_service/Remote/Network/NetworkApiService.dart';
import '../../../app_export/app_export.dart';
import '../Model/LoginModel.dart';

class LoginRepository {
  final NetworkApiService _apiService = NetworkApiService();

  Future<LoginModel> postRegister(Map<String, dynamic>? body) async {
    try {
      dynamic response =
          await _apiService.postResponse(ApiEndPoints().postLogin, body: body);
      if (kDebugMode) {
        print("Register $response");
      }
      final jsonData = LoginModel.fromJson(response);
      return jsonData;
    } catch (e) {
      throw e;
    }
  }
}
