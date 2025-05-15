import 'package:get/get.dart';
import 'package:mark_your_attendance/features/auth/data/services/password_reset_service.dart';
import 'package:mark_your_attendance/core/routes/app_routes.dart';

class PasswordResetController extends GetxController {
  final PasswordResetService _passwordResetService;
  
  final _isLoading = false.obs;
  final _currentStep = 0.obs;
  final _phoneNumber = ''.obs;
  final _errorMessage = ''.obs;

  PasswordResetController(this._passwordResetService);

  bool get isLoading => _isLoading.value;
  int get currentStep => _currentStep.value;
  String get phoneNumber => _phoneNumber.value;
  String get errorMessage => _errorMessage.value;

  // Step 1: Send OTP
  Future<void> sendOTP(String phone) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      _phoneNumber.value = phone;

      // Validate phone number format
      if (!_isValidPhoneNumber(phone)) {
        throw 'Invalid phone number format';
      }

      await _passwordResetService.sendOTP(phone);
      _currentStep.value = 1; // Move to OTP verification step
    } catch (e) {
      _errorMessage.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  // Step 2: Verify OTP
  Future<void> verifyOTP(String otp) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      await _passwordResetService.verifyOTP(otp);
      _currentStep.value = 2; // Move to password reset step
    } catch (e) {
      _errorMessage.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  // Step 3: Update Password
  Future<void> updatePassword(String newPassword, String confirmPassword) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      // Validate passwords
      if (newPassword.length < 6) {
        throw 'Password must be at least 6 characters';
      }

      if (newPassword != confirmPassword) {
        throw 'Passwords do not match';
      }

      await _passwordResetService.updatePassword(_phoneNumber.value, newPassword);
      Get.offAllNamed(AppRoutes.LOGIN);
      Get.snackbar('Success', 'Password has been reset successfully');
    } catch (e) {
      _errorMessage.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  bool _isValidPhoneNumber(String phoneNumber) {
    final phoneRegex = RegExp(r'^\+?[1-9]\d{1,14}$');
    return phoneRegex.hasMatch(phoneNumber);
  }

  void resetError() {
    _errorMessage.value = '';
  }
} 