import '../../../api_service/Remote/Network/ApiEndPoints.dart';
import '../../../api_service/Remote/Network/NetworkApiService.dart';
import '../../../app_export/app_export.dart';
import '../Model/RegisterModel.dart';

class RegisterRepository {
  final NetworkApiService _apiService = NetworkApiService();

  Future<RegisterModel> postRegister(Map<String, dynamic>? body) async {
    try {
      dynamic response = await _apiService
          .postResponse(ApiEndPoints().postRegister, body: body);
      if (kDebugMode) {
        print("Register $response");
      }
      final jsonData = RegisterModel.fromJson(response);
      return jsonData;
    } catch (e) {
      throw e;
    }
  }
}
