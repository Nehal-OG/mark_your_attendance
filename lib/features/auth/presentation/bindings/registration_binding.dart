import 'package:get/get.dart';
import 'package:mark_your_attendance/features/auth/data/services/phone_auth_service.dart';
import 'package:mark_your_attendance/features/auth/presentation/controllers/registration_controller.dart';

class RegistrationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PhoneAuthService());
    Get.put(RegistrationController(Get.find<PhoneAuthService>()));
  }
} 