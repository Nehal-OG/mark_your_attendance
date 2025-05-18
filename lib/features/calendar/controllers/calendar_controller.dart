import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../core/services/attendance_service.dart';

class CalendarController extends GetxController {
  final AttendanceService _attendanceService = Get.find<AttendanceService>();

  final DateTime _firstDay = DateTime(2024, 1, 1);
  final DateTime _lastDay = DateTime(2030, 12, 31);
  final RxBool isLoading = true.obs;

  DateTime getNowInIST() {
    final nowUtc = DateTime.now().toUtc();
    final nowIST = nowUtc.add(const Duration(hours: 5, minutes: 30));
    return DateTime(nowIST.year, nowIST.month, nowIST.day);
  }

  late final Rx<DateTime> focusedDay;
  late final Rx<DateTime> selectedDay;
  final Rx<CalendarFormat> calendarFormat = CalendarFormat.month.obs;
  final RxMap<DateTime, bool> attendanceMap = <DateTime, bool>{}.obs;

  // Clamps a date between firstDay and lastDay (inclusive)
  DateTime clampDate(DateTime date) {
    if (date.isBefore(_firstDay)) return _firstDay;
    if (date.isAfter(_lastDay)) return _lastDay;
    return date;
  }

  @override
  void onInit() {
    super.onInit();
    final today = getNowInIST();
    final initialDay = clampDate(today);
    focusedDay = Rx<DateTime>(initialDay);
    selectedDay = Rx<DateTime>(initialDay);

    _loadMonthlyAttendance();
  }

  Future<void> _loadMonthlyAttendance() async {
    isLoading.value = true;
    final monthlyAttendanceRaw =
        await _attendanceService.getMonthlyAttendance();

    final normalizedMap = <DateTime, bool>{};
    monthlyAttendanceRaw.forEach((key, value) {
      final normalizedKey = DateTime(key.year, key.month, key.day);
      normalizedMap[normalizedKey] = value;
    });

    attendanceMap.value = normalizedMap;
    isLoading.value = false;
  }

  void onDaySelected(DateTime selected, DateTime focused) {
    final today = getNowInIST();

    if (selected.isAfter(today)) {
      // Optionally: show a snackbar or dialog here
      return;
    }

    selectedDay.value = selected;
    focusedDay.value = clampDate(focused);
  }

  void onFormatChanged(CalendarFormat format) {
    calendarFormat.value = format;
  }

  Color getAttendanceColor(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);

    if (normalizedDate.isAfter(getNowInIST())) {
      return Colors.black; // future
    }

    return attendanceMap[normalizedDate] == true ? Colors.green : Colors.red;
  }
}
