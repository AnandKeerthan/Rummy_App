import '../../../api_service/Remote/Network/ApiEndPoints.dart';
import '../../../api_service/Remote/Network/NetworkApiService.dart';
import '../../../app_export/app_export.dart';
import '../Model/ResetModel.dart';

class ResetRepository {
  final NetworkApiService _apiService = NetworkApiService();

  Future<ResetModel> postRegister(Map<String, dynamic>? body) async {
    try {
      dynamic response = await _apiService
          .postResponse(ApiEndPoints().postResetPassword, body: body);
      if (kDebugMode) {
        print("Register $response");
      }
      final jsonData = ResetModel.fromJson(response);
      return jsonData;
    } catch (e) {
      throw e;
    }
  }
}
