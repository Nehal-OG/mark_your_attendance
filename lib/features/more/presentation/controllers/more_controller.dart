import 'package:get/get.dart';
import 'package:mark_your_attendance/core/routes/app_pages.dart';
import 'package:mark_your_attendance/features/attendance/data/models/attendance_model.dart';
import 'package:mark_your_attendance/features/more/data/services/more_service.dart';

class MoreController extends GetxController {
  final MoreService _moreService;

  MoreController(this._moreService);

  final _attendanceRecords = <AttendanceModel>[].obs;
  final _isLoading = false.obs;
  final _errorMessage = ''.obs;

  List<AttendanceModel> get attendanceRecords => _attendanceRecords;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;

  Future<void> loadAttendanceRecords() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      final records = await _moreService.getAllAttendance();
      _attendanceRecords.value = records;
    } catch (e) {
      _errorMessage.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> changePassword(
    String oldPassword,
    String newPassword,
    String confirmPassword,
  ) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      // Validate passwords
      if (newPassword.length < 6) {
        throw 'New password must be at least 6 characters';
      }

      if (newPassword != confirmPassword) {
        throw 'New passwords do not match';
      }

      // Verify old password
      final isValid = await _moreService.verifyPassword(oldPassword);
      if (!isValid) {
        throw 'Current password is incorrect';
      }

      // Update password
      await _moreService.updatePassword(newPassword);
      Get.back(); // Close the change password screen
      Get.snackbar('Success', 'Password updated successfully');
    } catch (e) {
      _errorMessage.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      await _moreService.logout();
      Get.offAllNamed(AppRoutes.LOGIN);
    } catch (e) {
      _errorMessage.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  void resetError() {
    _errorMessage.value = '';
  }
} 