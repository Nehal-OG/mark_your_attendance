import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mark_your_attendance/features/attendance/data/models/attendance_model.dart';

class CalendarService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<AttendanceModel>> getMonthAttendance(DateTime month) async {
    final user = _auth.currentUser;
    if (user == null) throw 'User not authenticated';

    // Get the first and last day of the month
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);

    final snapshot = await _firestore
        .collection('attendance')
        .where('userId', isEqualTo: user.uid)
        .where('checkInTime', isGreaterThanOrEqualTo: Timestamp.fromDate(firstDay))
        .where('checkInTime', isLessThanOrEqualTo: Timestamp.fromDate(lastDay))
        .get();

    return snapshot.docs
        .map((doc) => AttendanceModel.fromMap(doc.data()))
        .toList();
  }

  // Get working days (excluding weekends) for a given month
  List<DateTime> getWorkingDays(DateTime month) {
    final List<DateTime> workingDays = [];
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);

    for (var day = firstDay;
        day.isBefore(lastDay.add(const Duration(days: 1)));
        day = day.add(const Duration(days: 1))) {
      // Skip weekends (Saturday = 6, Sunday = 7)
      if (day.weekday != DateTime.saturday && day.weekday != DateTime.sunday) {
        workingDays.add(day);
      }
    }

    return workingDays;
  }
} 