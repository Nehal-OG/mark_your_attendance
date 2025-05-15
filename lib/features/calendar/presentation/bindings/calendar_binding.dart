import 'package:get/get.dart';
import 'package:mark_your_attendance/features/calendar/data/services/calendar_service.dart';
import 'package:mark_your_attendance/features/calendar/presentation/controllers/calendar_controller.dart';

class CalendarBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CalendarService());
    Get.put(CalendarController(Get.find<CalendarService>()));
  }
} 