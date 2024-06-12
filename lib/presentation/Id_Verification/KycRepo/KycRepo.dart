import '../../../App_Export/app_export.dart';
import '../../../api_service/Remote/Network/NetworkApiService.dart';
import '../Model/KycModel.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class KYCRepository {
  final NetworkApiService _apiService = NetworkApiService();

  Future<KYCModel> aadhaarVerification(
      {List<http.MultipartFile>? file, Map<String, dynamic>? body}) async {
    try {
      dynamic response = await _apiService
          .multipartProcedureV1(ApiEndPoints().kyc, file!, body: body);
      if (kDebugMode) {
        print("KYC Aadhaar: $response");
      }
      final jsonData = KYCModel.fromJson(response);
      return jsonData;
    } catch (e) {
      throw e;
    }
  }
}
