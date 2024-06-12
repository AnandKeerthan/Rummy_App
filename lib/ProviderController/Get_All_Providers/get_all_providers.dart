import 'package:dsrummy/presentation/2FA/ViewModel/2FAViewModel.dart';
import 'package:dsrummy/presentation/DeleteAccount/ViewModel/DeleteAccountVM.dart';
import 'package:dsrummy/presentation/DeviceIdVM/DeviceIDVM.dart';
import 'package:dsrummy/presentation/Forgot_Screen/ViewModel/ForgotViewModel.dart';
import 'package:dsrummy/presentation/GetProfile_Screen/ViewModel/GetProfileVm.dart';
import 'package:dsrummy/presentation/Guest/GetRegisterGuest/ViewModel/GetRegisterGuestViewModel.dart';
import 'package:dsrummy/presentation/Guest/GuestRegister/ViewModel/GusestViewModel.dart';
import 'package:dsrummy/presentation/Id_Verification/KycVm/KycVm.dart';
import 'package:dsrummy/presentation/LoginVerificationScreen/ViewModel/LoginVerifyVM.dart';
import 'package:dsrummy/presentation/Login_Screen/ViewModel/LoginViewModel.dart';
import 'package:dsrummy/presentation/PlanPackage/ViewModel/PackageListVM.dart';
import 'package:dsrummy/presentation/RegisterScreen/ViewModel/RegisterViewModel.dart';
import 'package:dsrummy/presentation/ResetPassword_Screen/ViewModel/ResetViewModel.dart';
import 'package:dsrummy/presentation/SupportScreen/ViewModel/SupportVM.dart';
import 'package:dsrummy/presentation/VerifyRegisterScreen/ViewModel/VerifyRegisterVm.dart';
import 'package:provider/provider.dart';
import '../../Utlilities/ThemeMode/ThemeProvider/ThemeProvider.dart';

getAllProviders() {
  return [
    ChangeNotifierProvider(
      create: (_) => PackageListVM(),
    ),
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => RegisterVM(),
    ),
    ChangeNotifierProvider(
      create: (_) => LoginVM(),
    ),
    ChangeNotifierProvider(
      create: (_) => ResetVM(),
    ),
    ChangeNotifierProvider(
      create: (_) => ForgotVM(),
    ),
    ChangeNotifierProvider(
      create: (_) => VerifyRegisterVM(),
    ),
    ChangeNotifierProvider(
      create: (_) => KycVM(),
    ),
    ChangeNotifierProvider(
      create: (_) => GetProfileVM(),
    ),
    ChangeNotifierProvider(
      create: (_) => VerifyLoginVM(),
    ),
    ChangeNotifierProvider(
      create: (_) => SupportVM(),
    ),
    ChangeNotifierProvider(
      create: (_) => DeleteAccountVM(),
    ),
    ChangeNotifierProvider(
      create: (_) => TFaVM(),
    ),
    ChangeNotifierProvider(
      create: (_) => DeviceInfoViewModel(),
    ),
    ChangeNotifierProvider(
      create: (_) => GusestRegisterVM(),
    ),
    ChangeNotifierProvider(
      create: (_) => GetGusestRegisterVM(),
    ),
  ];
}
