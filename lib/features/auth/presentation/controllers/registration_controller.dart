import 'package:get/get.dart';
import 'package:mark_your_attendance/features/auth/data/services/phone_auth_service.dart';
import 'package:mark_your_attendance/core/routes/app_routes.dart';

class RegistrationController extends GetxController {
  final PhoneAuthService _phoneAuthService;
  
  final _isLoading = false.obs;
  final _currentStep = 0.obs;
  final _phoneNumber = ''.obs;
  final _verificationError = ''.obs;

  RegistrationController(this._phoneAuthService);

  bool get isLoading => _isLoading.value;
  int get currentStep => _currentStep.value;
  String get phoneNumber => _phoneNumber.value;
  String get verificationError => _verificationError.value;

  // Step 1: Send OTP
  Future<void> sendOTP(String phone) async {
    try {
      _isLoading.value = true;
      _verificationError.value = '';
      _phoneNumber.value = phone;
      
      await _phoneAuthService.sendOTP(phone);
      _currentStep.value = 1; // Move to OTP verification step
    } catch (e) {
      _verificationError.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  // Step 2: Verify OTP
  Future<void> verifyOTP(String otp) async {
    try {
      _isLoading.value = true;
      _verificationError.value = '';
      
      await _phoneAuthService.verifyOTP(otp);
      _currentStep.value = 2; // Move to password creation step
    } catch (e) {
      _verificationError.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  // Step 3: Complete Registration
  Future<void> completeRegistration(String password) async {
    try {
      _isLoading.value = true;
      _verificationError.value = '';
      
      final user = await _phoneAuthService.verifyOTP(password);
      await _phoneAuthService.completeRegistration(
        uid: user.user!.uid,
        phoneNumber: _phoneNumber.value,
        password: password,
      );
      
      Get.offAllNamed(AppRoutes.HOME);
    } catch (e) {
      _verificationError.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  void resetError() {
    _verificationError.value = '';
  }
} 