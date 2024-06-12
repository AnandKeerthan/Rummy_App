import 'package:dsrummy/App_Export/app_export.dart';
import 'package:dsrummy/api_service/Remote/Network/ApiEndPoints.dart';
import 'package:dsrummy/api_service/Remote/Network/NetworkApiService.dart';
import 'package:dsrummy/presentation/LoginVerificationScreen/Model/OtpVerifyLogin.dart';
import 'package:dsrummy/presentation/LoginVerificationScreen/Model/SendOTPModel.dart';

class SendOTPRepository {
  final NetworkApiService _apiService = NetworkApiService();

  Future<SendOTPModel> postRegister(Map<String, dynamic>? body) async {
    try {
      dynamic response =
          await _apiService.postResponse(ApiEndPoints().sentOTP, body: body);
      if (kDebugMode) {
        print("SendOTP $response");
      }
      final jsonData = SendOTPModel.fromJson(response);
      return jsonData;
    } catch (e) {
      throw e;
    }
  }
}

class VerifyOTPRepository {
  final NetworkApiService _apiService = NetworkApiService();

  Future<OtpVerifyLogin> postRegister(Map<String, dynamic>? body) async {
    try {
      dynamic response = await _apiService
          .postResponse(ApiEndPoints().verifyMobileOTP, body: body);
      if (kDebugMode) {
        print("OtpVerifyLogin $response");
      }
      final jsonData = OtpVerifyLogin.fromJson(response);
      return jsonData;
    } catch (e) {
      throw e;
    }
  }
}
