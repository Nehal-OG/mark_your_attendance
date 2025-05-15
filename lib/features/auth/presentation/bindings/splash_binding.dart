import 'package:get/get.dart';
import 'package:mark_your_attendance/features/auth/presentation/controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashController());
  }
} 