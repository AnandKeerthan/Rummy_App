import 'package:dsrummy/App_Export/app_export.dart';
import 'package:dsrummy/api_service/Remote/Network/ApiEndPoints.dart';
import 'package:dsrummy/api_service/Remote/Network/NetworkApiService.dart';
import 'package:dsrummy/presentation/Guest/GetRegisterGuest/Model/GetRegisterGuestModel.dart';

class GetGusestRegisterRepository {
  final NetworkApiService _apiService = NetworkApiService();

  Future<GetRegisterGuest> postRegister(Map<String, dynamic>? body) async {
    try {
      dynamic response = await _apiService
          .postResponse(ApiEndPoints().getRegisterGuest, body: body);
      if (kDebugMode) {
        print("GuestRegisterModel $response");
      }
      final jsonData = GetRegisterGuest.fromJson(response);
      return jsonData;
    } catch (e) {
      throw e;
    }
  }
}
