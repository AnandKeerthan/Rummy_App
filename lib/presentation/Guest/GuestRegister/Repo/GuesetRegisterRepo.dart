import 'package:dsrummy/api_service/Remote/Network/ApiEndPoints.dart';
import 'package:dsrummy/api_service/Remote/Network/NetworkApiService.dart';
import 'package:dsrummy/presentation/Guest/GuestRegisterModel.dart';

import '../../../../app_export/app_export.dart';

class GusestRegisterRepository {
  final NetworkApiService _apiService = NetworkApiService();

  Future<GuestRegisterModel> postRegister(Map<String, dynamic>? body) async {
    try {
      dynamic response = await _apiService
          .postResponse(ApiEndPoints().registerGuest, body: body);
      if (kDebugMode) {
        print("GuestRegisterModel $response");
      }
      final jsonData = GuestRegisterModel.fromJson(response);
      return jsonData;
    } catch (e) {
      throw e;
    }
  }
}
