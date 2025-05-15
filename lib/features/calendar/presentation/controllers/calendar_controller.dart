import 'package:get/get.dart';
import 'package:mark_your_attendance/features/attendance/data/models/attendance_model.dart';

class CalendarController extends GetxController {
  final _selectedDate = DateTime.now().obs;
  final _events = <DateTime, List<AttendanceModel>>{}.obs;
  final _isLoading = false.obs;

  DateTime get selectedDate => _selectedDate.value;
  Map<DateTime, List<AttendanceModel>> get events => _events;
  bool get isLoading => _isLoading.value;

  void selectDate(DateTime date) {
    _selectedDate.value = date;
  }

  Future<void> fetchMonthEvents(DateTime month) async {
    try {
      _isLoading.value = true;
      // TODO: Implement fetch month events logic
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      _isLoading.value = false;
    }
  }

  List<AttendanceModel> getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }
} 