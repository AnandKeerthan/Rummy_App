import 'package:dsrummy/App_Export/app_export.dart';
import 'package:dsrummy/api_service/Remote/Network/ApiEndPoints.dart';
import 'package:dsrummy/api_service/Remote/Network/NetworkApiService.dart';
import 'package:dsrummy/presentation/DeleteAccount/Model/DeleteAccountModel.dart';

class DeleteAccountRepository {
  final NetworkApiService _apiService = NetworkApiService();

  Future<DeleteAccount> postRegister() async {
    try {
      dynamic response = await _apiService
          .postResponseTokenWithoutParams(ApiEndPoints().deleteAccount);
      if (kDebugMode) {
        print("DeleteAccount $response");
      }
      print(response);
      final jsonData = DeleteAccount.fromJson(response);
      return jsonData;
    } catch (e) {
      throw e;
    }
  }
}
