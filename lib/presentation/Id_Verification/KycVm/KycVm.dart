import 'package:dsrummy/presentation/GetProfile_Screen/ViewModel/GetProfileVm.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../../App_Export/app_export.dart';
import '../../../Utlilities/Toast/StatusMessages.dart';
import '../../../api_service/Remote/Response/ApiResponse.dart';
import '../KycRepo/KycRepo.dart';
import '../Model/KycModel.dart';

class KycVM extends ChangeNotifier {
  final _myRepo = KYCRepository();

  TextEditingController nameController = TextEditingController();
  TextEditingController noController = TextEditingController();

  RoundedLoadingButtonController nextButtonController =
      RoundedLoadingButtonController();

  ApiResponse<KYCModel> loginModel = ApiResponse.loading();

  late ImagePicker picker = ImagePicker();
  File? pickedImage;
  void openGallery() async {
    final _pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (_pickedImage != null) {
      pickedImage = File(_pickedImage.path);
      notifyListeners();
    }
    const int maxSize = 5120 * 1024;
    final int fileSize1 = await pickedImage!.length();
    if (fileSize1 > maxSize) {
      file1 = false;
      Utils.snackBarErrorMessage('Image file size should be less than 5MB.');
      notifyListeners();
    } else {
      file1 = true;
    }
    notifyListeners();
  }

  bool file1 = true;
  bool file2 = true;
  late ImagePicker picker1 = ImagePicker();
  File? pickedImage1;
  void openGallery1() async {
    final _pickedImage = await picker1.pickImage(source: ImageSource.gallery);
    if (_pickedImage != null) {
      pickedImage1 = File(_pickedImage.path);
      notifyListeners();
    }
    const int maxSize = 5120 * 1024;
    final int fileSize2 = await pickedImage1!.length();
    if (fileSize2 > maxSize) {
      file2 = false;

      Utils.snackBarErrorMessage('Image file size should be less than 5MB.');
      notifyListeners();
    } else {
      file2 = true;
    }
    notifyListeners();
  }

  bool _loading = false;
  bool get loading => _loading;

  bool _signUpLoading = false;
  bool get signUpLoading => _signUpLoading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  setSignUpLoading(bool value) {
    _signUpLoading = value;
    notifyListeners();
  }

  String? selectedIdType;
  Future<void> fetchKyc(BuildContext context) async {
    setLoading(true);

    Map<String, dynamic> params = {
      "IdType": selectedIdType,
      "Name": nameController.text,
      "Number": noController.text,
    };
    print("gender:::::::::::::${params}");

    List<http.MultipartFile> files = [];

    files.add(await http.MultipartFile.fromPath('Images', pickedImage!.path));

    files.add(await http.MultipartFile.fromPath('Images', pickedImage1!.path));

    _myRepo.aadhaarVerification(file: files, body: params).then((value) {
      setLoading(false);

      if (value.status == true) {
        Get.snackbar("Update Profile", value.message!.toString(),
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 2),
            backgroundColor: AppColors.green,
            margin: const EdgeInsets.all(10),
            colorText: Colors.white);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Provider.of<GetProfileVM>(context, listen: false)
              .FetchProfile(context);
        });
        nameController.clear();
        noController.clear();
        pickedImage = null;
        pickedImage1 = null;
        nextButtonController.reset();

        if (kDebugMode) {
          print("!!!!!!!!!!!!!!!!!!${value.toString()}");
        }
      } else if (value.status == false) {
        Get.snackbar("Update Profile", value.message.toString(),
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 2),
            backgroundColor: AppColors.red,
            margin: const EdgeInsets.all(10),
            colorText: Colors.white);
        nextButtonController.reset();
        nameController.clear();
        noController.clear();
        pickedImage = null;
        pickedImage1 = null;
        nextButtonController.reset();
        if (kDebugMode) {
          print(value.toString());
          print("=========${value.toString()}");
        }
      } else {
        Utils.snackBar(value.message!);
      }
    }).onError((error, stackTrace) {
      setLoading(false);

      Get.snackbar("Update Profile", error.toString(),
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 2),
          backgroundColor: AppColors.red,
          margin: const EdgeInsets.all(10),
          colorText: Colors.white);
      nextButtonController.reset();
      nameController.clear();
      noController.clear();
      pickedImage = null;
      pickedImage1 = null;
      nextButtonController.reset();
      if (kDebugMode) {
        print(error.toString());

        print("+++++++++${error.toString()}");
      }
    });
  }
}
