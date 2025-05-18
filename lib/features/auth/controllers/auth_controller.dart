import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mark_your_attendance/core/routes/app_pages.dart';
import 'package:mark_your_attendance/core/services/auth_service.dart';
import 'package:mark_your_attendance/core/utils/phone_utils.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxString verificationId = ''.obs;

  @override
  void onClose() {
    phoneController.dispose();
    otpController.dispose();
    super.onClose();
  }

  Future<void> sendOTP({required bool isLogin}) async {
    final original = phoneController.text;

    if (original.isEmpty) {
      error.value = 'Please enter a phone number';
      return;
    }

    isLoading.value = true;
    error.value = '';

    try {
      // Format for display (remove +91 if user added it)
      final displayPhone = PhoneUtils.formatForDisplay(original);
      phoneController.value = TextEditingValue(
        text: displayPhone,
        selection: TextSelection.collapsed(offset: displayPhone.length),
      );

      // Format for backend (always E.164 with +91)
      final formatted = PhoneUtils.formatPhoneNumber(original);

      await _authService.sendOTP(formatted);
      verificationId.value = _authService.verificationId.value;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOTP({required bool isLogin}) async {
    if (otpController.text.isEmpty) {
      error.value = 'Please enter the OTP';
      return;
    }

    isLoading.value = true;
    error.value = '';

    try {
      final success = await _authService.verifyOTP(otpController.text);
      if (success) {
        Get.offAllNamed(AppRoutes.MAIN);
        if (!isLogin) {
          Get.snackbar(
            'Success',
            'Registration successful!',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else {
        error.value = 'Invalid OTP';
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updatePhoneNumber(
    String oldPhone,
    String newPhone,
    String otp,
  ) async {
    if (newPhone.isEmpty || otp.isEmpty) {
      error.value = 'Please fill all fields';
      return;
    }

    // Validate new phone number
    final phoneError = PhoneUtils.validatePhoneNumber(newPhone);
    if (phoneError != null) {
      error.value = phoneError;
      return;
    }

    isLoading.value = true;
    error.value = '';

    try {
      // Format new number for Firebase (+91XXXXXXXXXX)
      final formattedNewPhone = PhoneUtils.formatPhoneNumber(newPhone);

      await _authService.updatePhoneNumber(formattedNewPhone, otp);

      Get.back();
      Get.snackbar(
        'Success',
        'Phone number updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
      Get.offAllNamed(AppRoutes.LOGIN);
    } catch (e) {
      error.value = e.toString();
    }
  }
}
