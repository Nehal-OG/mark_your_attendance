import 'package:get/get.dart';
import 'package:mark_your_attendance/features/attendance/data/services/attendance_service.dart';
import 'package:mark_your_attendance/features/calendar/data/services/calendar_service.dart';
import 'package:mark_your_attendance/features/calendar/presentation/controllers/calendar_controller.dart';
import 'package:mark_your_attendance/features/home/controllers/home_controller.dart';
import 'package:mark_your_attendance/features/more/data/services/more_service.dart';
import 'package:mark_your_attendance/features/more/presentation/controllers/more_controller.dart';
import 'package:mark_your_attendance/features/navigation/presentation/controllers/navigation_controller.dart';

class NavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NavigationController());
    // Home
    Get.lazyPut<AttendanceService>(() => AttendanceService());
    Get.lazyPut<HomeController>(() => HomeController());

    // Calendar    
    Get.put(CalendarService());
    Get.put(CalendarController(Get.find<CalendarService>()));

    // More
    Get.put(MoreService());
    Get.put(MoreController(Get.find<MoreService>()));
  }
} 