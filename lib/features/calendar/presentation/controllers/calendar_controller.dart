import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:mark_your_attendance/features/attendance/data/models/attendance_model.dart';
import 'package:mark_your_attendance/features/calendar/data/services/calendar_service.dart';

class CalendarController extends GetxController {
  final CalendarService _calendarService;

  CalendarController(this._calendarService);

  final _focusedDay = DateTime.now().obs;
  final _selectedDay = Rxn<DateTime>();
  final _attendanceRecords = <DateTime, AttendanceModel>{}.obs;
  final _workingDays = <DateTime>[].obs;
  final _isLoading = false.obs;
  final _errorMessage = ''.obs;

  DateTime get focusedDay => _focusedDay.value;
  DateTime? get selectedDay => _selectedDay.value;
  Map<DateTime, AttendanceModel> get attendanceRecords => _attendanceRecords;
  List<DateTime> get workingDays => _workingDays;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;

  @override
  void onInit() {
    super.onInit();
    _loadMonthData(_focusedDay.value);
  }

  Future<void> _loadMonthData(DateTime month) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      // Get working days for the month
      _workingDays.value = _calendarService.getWorkingDays(month);

      // Get attendance records
      final records = await _calendarService.getMonthAttendance(month);
      
      // Clear previous records
      _attendanceRecords.clear();

      // Convert list to map with date as key
      for (var record in records) {
        final date = DateTime(
          record.checkInTime.year,
          record.checkInTime.month,
          record.checkInTime.day,
        );
        _attendanceRecords[date] = record;
      }
    } catch (e) {
      _errorMessage.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay.value, selectedDay)) {
      _selectedDay.value = selectedDay;
      _focusedDay.value = focusedDay;
    }
  }

  void onPageChanged(DateTime focusedDay) {
    _focusedDay.value = focusedDay;
    _loadMonthData(focusedDay);
  }

  Color getDateColor(DateTime date) {
    // Future dates are white
    if (date.isAfter(DateTime.now())) {
      return Colors.white;
    }

    // Weekend dates are grey
    if (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday) {
      return Colors.grey.shade200;
    }

    // Check if it's a working day with attendance
    if (_attendanceRecords.containsKey(date)) {
      return Colors.green.shade100; // Present
    }

    // Working day without attendance (absent)
    if (_workingDays.any((day) => isSameDay(day, date))) {
      return Colors.red.shade100;
    }

    return Colors.white;
  }

  AttendanceModel? getAttendanceForDay(DateTime date) {
    return _attendanceRecords[date];
  }
} 