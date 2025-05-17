import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/attendance_service.dart';

class MoreController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final AttendanceService _attendanceService = Get.find<AttendanceService>();

  final oldPhoneController = TextEditingController();
  final newPhoneController = TextEditingController();
  final otpController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxString verificationId = ''.obs;
  final RxList<Map<String, dynamic>> attendanceRecords = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    oldPhoneController.text = _authService.user.value?.phoneNumber ?? '';
    _loadAttendanceRecords();
  }

  @override
  void onClose() {
    oldPhoneController.dispose();
    newPhoneController.dispose();
    otpController.dispose();
    super.onClose();
  }

  Future<void> _loadAttendanceRecords() async {
    try {
      final records = await _attendanceService.getAttendanceRecords();
      attendanceRecords.value = records;
    } catch (e) {
      error.value = e.toString();
    }
  }

  Future<void> sendOTP() async {
    if (newPhoneController.text.isEmpty) {
      error.value = 'Please enter a new phone number';
      return;
    }

    isLoading.value = true;
    error.value = '';

    try {
      await _authService.sendOTP(newPhoneController.text);
      verificationId.value = _authService.verificationId.value;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOTP(BuildContext context) async {
    if (otpController.text.isEmpty) {
      error.value = 'Please enter the OTP';
      return;
    }

    isLoading.value = true;
    error.value = '';

    try {
      await _authService.updatePhoneNumber(newPhoneController.text, otpController.text);
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
      Get.offAllNamed('/login');
    } catch (e) {
      error.value = e.toString();
    }
  }
} 