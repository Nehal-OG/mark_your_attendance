import 'package:get/get.dart';
import 'package:mark_your_attendance/features/auth/data/services/auth_service.dart';
import 'package:mark_your_attendance/features/auth/presentation/controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthService());
    Get.put(LoginController(Get.find<AuthService>()));
  }
} 