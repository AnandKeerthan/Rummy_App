import 'package:http/http.dart' as http;

import '../../../../App_Export/app_export.dart';
import '../../../../api_service/Remote/Network/ApiEndPoints.dart';
import '../../../../api_service/Remote/Network/NetworkApiService.dart';
import '../Model/EditProfileModel.dart';

class EditProfileRepo {
  final NetworkApiService _apiService = NetworkApiService();

  Future<EditProfileModel> UpdateProfileVerification(
      {http.MultipartFile? file, Map<String, dynamic>? body}) async {
    try {
      dynamic response = await _apiService
          .multipartProcedure(ApiEndPoints().editProfile, file!, body: body);
      if (kDebugMode) {
        print("Update Profile Repo: $response");
      }
      final jsonData = EditProfileModel.fromJson(response);
      return jsonData;
    } catch (e) {
      throw e;
    }
  }
}
