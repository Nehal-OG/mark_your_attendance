import 'package:get/get.dart';
import '../../../core/services/attendance_service.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AttendanceService>(() => AttendanceService());
    Get.lazyPut<HomeController>(() => HomeController());
  }
} 