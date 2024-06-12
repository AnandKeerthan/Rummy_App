import 'package:dsrummy/api_service/Remote/Network/ApiEndPoints.dart';
import 'package:dsrummy/api_service/Remote/Network/NetworkApiService.dart';
import 'package:dsrummy/presentation/PlanPackage/Model/PackageListModel.dart';
import 'package:flutter/foundation.dart';

class PackageListRepository {
  final NetworkApiService _apiService = NetworkApiService();

  Future<PackageListModel> getPackage() async {
    try {
      dynamic response =
          await _apiService.getResponse(ApiEndPoints().packageList);
      if (kDebugMode) {
        print("PackageList: $response");
      }
      final jsonData = PackageListModel.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }
}

PackageListRepository packageListRepository = PackageListRepository();
