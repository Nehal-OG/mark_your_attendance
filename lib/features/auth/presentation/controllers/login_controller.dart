import 'package:get/get.dart';
import 'package:mark_your_attendance/features/auth/data/services/auth_service.dart';
import 'package:mark_your_attendance/core/routes/app_routes.dart';

class LoginController extends GetxController {
  final AuthService _authService;
  
  final _isLoading = false.obs;
  final _errorMessage = ''.obs;

  LoginController(this._authService);

  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;

  Future<void> login(String phoneNumber, String password) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      // Validate phone number format
      if (!_isValidPhoneNumber(phoneNumber)) {
        throw 'Invalid phone number format';
      }

      // Validate password
      if (password.length < 6) {
        throw 'Password must be at least 6 characters';
      }

      // Attempt login
      await _authService.loginWithPhoneAndPassword(phoneNumber, password);
      
      // Navigate to home on success
      Get.offAllNamed(AppRoutes.HOME);
    } catch (e) {
      _errorMessage.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  bool _isValidPhoneNumber(String phoneNumber) {
    // Basic phone number validation
    // You might want to use a more sophisticated validation in production
    final phoneRegex = RegExp(r'^\+?[1-9]\d{1,14}$');
    return phoneRegex.hasMatch(phoneNumber);
  }

  void resetError() {
    _errorMessage.value = '';
  }
} 