import 'package:dsrummy/api_service/Remote/Network/NetworkApiService.dart';

import '../../../api_service/Remote/Network/ApiEndPoints.dart';
import '../../../app_export/app_export.dart';
import '../Model/ForgetModel.dart';
import '../Model/VerifyOtpModel.dart';

class ForgotRepository {
  final NetworkApiService _apiService = NetworkApiService();

  Future<ForgotModel> postRegister(Map<String, dynamic>? body) async {
    try {
      dynamic response =
          await _apiService.postResponse(ApiEndPoints().postForgot, body: body);
      if (kDebugMode) {
        print("Register $response");
      }
      final jsonData = ForgotModel.fromJson(response);
      return jsonData;
    } catch (e) {
      throw e;
    }
  }
}

class VerifyOtpRepository {
  final NetworkApiService _apiService = NetworkApiService();

  Future<VerifyOtpModel> postRegister(Map<String, dynamic>? body) async {
    try {
      dynamic response = await _apiService
          .postResponseToken(ApiEndPoints().postVerifyOtp, body: body);
      if (kDebugMode) {
        print("Register $response");
      }
      print(response);
      final jsonData = VerifyOtpModel.fromJson(response);
      return jsonData;
    } catch (e) {
      throw e;
    }
  }
}
