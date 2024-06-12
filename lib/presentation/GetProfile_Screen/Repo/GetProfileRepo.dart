import '../../../App_Export/app_export.dart';
import '../../../api_service/Remote/Network/ApiEndPoints.dart';
import '../../../api_service/Remote/Network/NetworkApiService.dart';
import '../Model/GetModel.dart';

class GetProfileRepository {
  final NetworkApiService _apiService = NetworkApiService();

  Future<GetProfileModel> featuredProductsHome() async {
    try {
      dynamic response =
          await _apiService.getResponse(ApiEndPoints().getProfile);
      if (kDebugMode) {
        print("Get ProfileGet : $response");
      }
      final jsonData = GetProfileModel.fromJson(response);
      return jsonData;
    } catch (e) {
      throw e;
    }
  }
}
