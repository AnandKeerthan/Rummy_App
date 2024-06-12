import 'package:dsrummy/Utlilities/Toast/ToastMessage.dart';
import 'package:dsrummy/api_service/Remote/Response/ApiResponse.dart';
import 'package:dsrummy/presentation/PlanPackage/Repository/PackageListRepo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dsrummy/presentation/PlanPackage/Model/PackageListModel.dart';

class PackageListVM extends ChangeNotifier {
  PackageListModel? packageListModel;

  bool isLoading = false;
  setLoading(bool loader) {
    isLoading = loader;
    notifyListeners();
  }

  PackageListVM() {}
  setPackageList(PackageListModel? profileScreenModel, context) async {
    packageListModel = profileScreenModel;
  }

  getPackage(BuildContext context) async {
    setLoading(true);
    var params = {};
    var contactResponse = await packageListRepository.getPackage();
    var decodeResponse = ApiResponse.completed(contactResponse);

    switch (decodeResponse.status?.index ?? 2) {
      case 0:
        break;
      case 1:
        setPackageList(decodeResponse.data, context);
        setLoading(false);
        break;
      default:
        Future.delayed(Duration.zero, (() {
          ToastCommon.errorMessage("Something went wrong");
        }));
    }
  }
}
