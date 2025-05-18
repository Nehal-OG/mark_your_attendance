import 'package:get/get.dart';
import 'package:mark_your_attendance/core/services/attendance_service.dart';
import 'package:mark_your_attendance/features/calendar/controllers/calendar_controller.dart';
import 'package:mark_your_attendance/features/home/controllers/home_controller.dart';
import 'package:mark_your_attendance/features/more/controllers/more_controller.dart';
import 'package:mark_your_attendance/features/navigation/presentation/controllers/navigation_controller.dart';

class NavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NavigationController());
    // Home
    Get.lazyPut<AttendanceService>(() => AttendanceService());
    Get.lazyPut<HomeController>(() => HomeController());

    // Calendar    
    Get.lazyPut<CalendarController>(() => CalendarController());

    // More
    Get.lazyPut<MoreController>(() => MoreController());
  }
} 