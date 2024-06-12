import 'package:dsrummy/App_Export/app_export.dart';
import 'package:dsrummy/api_service/Remote/Network/ApiEndPoints.dart';
import 'package:dsrummy/api_service/Remote/Network/NetworkApiService.dart';
import 'package:dsrummy/presentation/SupportScreen/Model/SupportModel.dart';

class SupportRepository {
  final NetworkApiService _apiService = NetworkApiService();

  Future<supportModel> postRegister(Map<String, dynamic>? body) async {
    try {
      dynamic response =
          await _apiService.postResponse(ApiEndPoints().support, body: body);
      if (kDebugMode) {
        print("Register $response");
      }
      final jsonData = supportModel.fromJson(response);
      return jsonData;
    } catch (e) {
      throw e;
    }
  }
}
