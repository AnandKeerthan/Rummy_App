import 'package:dsrummy/api_service/Remote/Network/ApiEndPoints.dart';
import 'package:dsrummy/api_service/Remote/Network/NetworkApiService.dart';
import 'package:dsrummy/presentation/2FA/Model/2FAModel.dart';

import '../../../app_export/app_export.dart';

class TFARepository {
  final NetworkApiService _apiService = NetworkApiService();

  Future<TwoFaModel> postRegister(Map<String, dynamic>? body) async {
    try {
      dynamic response =
          await _apiService.postResponseToken(ApiEndPoints().tfa, body: body);
      if (kDebugMode) {
        print("TwoFaModel $response");
      }
      print(response);
      final jsonData = TwoFaModel.fromJson(response);
      return jsonData;
    } catch (e) {
      throw e;
    }
  }
}
