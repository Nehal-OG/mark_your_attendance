import 'package:get/get.dart';
import 'package:mark_your_attendance/features/auth/data/services/password_reset_service.dart';
import 'package:mark_your_attendance/features/auth/presentation/controllers/password_reset_controller.dart';

class PasswordResetBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PasswordResetService());
    Get.put(PasswordResetController(Get.find<PasswordResetService>()));
  }
} 