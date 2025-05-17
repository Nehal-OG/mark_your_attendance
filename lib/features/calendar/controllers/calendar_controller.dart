import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../core/services/attendance_service.dart';

class CalendarController extends GetxController {
  final AttendanceService _attendanceService = Get.find<AttendanceService>();

  final Rx<DateTime> focusedDay = DateTime.now().obs;
  final Rx<DateTime> selectedDay = DateTime.now().obs;
  final Rx<CalendarFormat> calendarFormat = CalendarFormat.month.obs;
  final RxMap<DateTime, bool> attendanceMap = <DateTime, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _loadMonthlyAttendance();
  }

  Future<void> _loadMonthlyAttendance() async {
    final monthlyAttendance = await _attendanceService.getMonthlyAttendance();
    attendanceMap.value = monthlyAttendance;
  }

  void onDaySelected(DateTime selected, DateTime focused) {
    selectedDay.value = selected;
    focusedDay.value = focused;
  }

  void onFormatChanged(CalendarFormat format) {
    calendarFormat.value = format;
  }

  Color getAttendanceColor(DateTime date) {
    if (date.isAfter(DateTime.now())) {
      return Colors.black;
    }
    return attendanceMap[DateTime(date.year, date.month, date.day)] == true
        ? Colors.green
        : Colors.red;
  }
} 