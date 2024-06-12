import 'package:dsrummy/api_service/Remote/Network/ApiEndPoints.dart';
import 'package:dsrummy/api_service/Remote/Network/NetworkApiService.dart';
import 'package:dsrummy/app_export/app_export.dart';
import 'package:dsrummy/presentation/VerifyRegisterScreen/Model/VerifyRegisterOtp.dart';

class VerifyOtpRegisterRepository {
  final NetworkApiService _apiService = NetworkApiService();

  Future<VerifyRegisterModel> postRegister(Map<String, dynamic>? body) async {
    try {
      dynamic response = await _apiService
          .postResponse(ApiEndPoints().VerifyRegister, body: body);
      if (kDebugMode) {
        print("VerifyRegisterModel $response");
      }
      final jsonData = VerifyRegisterModel.fromJson(response);
      return jsonData;
    } catch (e) {
      throw e;
    }
  }
}
