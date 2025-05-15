import 'package:get/get.dart';
import 'package:mark_your_attendance/features/attendance/data/services/attendance_service.dart';
import 'package:mark_your_attendance/features/home/presentation/controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AttendanceService());
    Get.put(HomeController(Get.find<AttendanceService>()));
  }
} 