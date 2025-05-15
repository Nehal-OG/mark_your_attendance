import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mark_your_attendance/core/routes/app_routes.dart';
import 'package:mark_your_attendance/core/utils/phone_utils.dart';

class LoginController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final _isLoading = false.obs;
  final _errorMessage = ''.obs;
  final _phoneNumber = ''.obs;

  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  String get phoneNumber => _phoneNumber.value;

  // Update phone number with formatting
  void updatePhoneNumber(String value) {
    _phoneNumber.value = PhoneUtils.formatForDisplay(value);
  }

  // Login with phone and password
  Future<void> login(String phone, String password) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      // Validate phone number
      final phoneError = PhoneUtils.validatePhoneNumber(phone);
      if (phoneError != null) {
        throw phoneError;
      }

      // Format phone number
      final formattedPhone = PhoneUtils.formatPhoneNumber(phone);

      // Check if user exists
      final userQuery = await _firestore
          .collection('users')
          .where('phoneNumber', isEqualTo: formattedPhone)
          .limit(1)
          .get();

      if (userQuery.docs.isEmpty) {
        throw 'No account found with this phone number';
      }

      final userData = userQuery.docs.first.data();
      if (userData['password'] != password) {
        throw 'Invalid password';
      }

      // Create custom token or use phone auth here
      // For now, we'll use anonymous sign in
      await _auth.signInAnonymously();

      // Update last login time
      await userQuery.docs.first.reference.update({
        'lastLoginAt': FieldValue.serverTimestamp(),
      });

      Get.offAllNamed(AppRoutes.MAIN);
    } catch (e) {
      _errorMessage.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  void resetError() {
    _errorMessage.value = '';
  }

  void navigateToRegister() {
    Get.toNamed(AppRoutes.REGISTER);
  }

  void navigateToForgotPassword() {
    Get.toNamed(AppRoutes.FORGOT_PASSWORD);
  }
} 