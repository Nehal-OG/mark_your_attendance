import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mark_your_attendance/features/attendance/data/models/attendance_model.dart';

class AttendanceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user's attendance for today
  Future<AttendanceModel?> getTodayAttendance() async {
    final user = _auth.currentUser;
    if (user == null) throw 'User not authenticated';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    final snapshot = await _firestore
        .collection('attendance')
        .where('userId', isEqualTo: user.uid)
        .where('checkInTime', isGreaterThanOrEqualTo: Timestamp.fromDate(today))
        .where('checkInTime', isLessThan: Timestamp.fromDate(tomorrow))
        .get();

    if (snapshot.docs.isEmpty) return null;
    return AttendanceModel.fromMap(snapshot.docs.first.data());
  }

  // Check in
  Future<void> checkIn() async {
    final user = _auth.currentUser;
    if (user == null) throw 'User not authenticated';

    // Get current location
    final position = await getCurrentPosition();
    
    final attendance = AttendanceModel(
      userId: user.uid,
      checkInTime: DateTime.now(),
      checkInLocation: GeoPoint(position.latitude, position.longitude),
      status: 'checked_in',
    );

    await _firestore.collection('attendance').add(attendance.toMap());
  }

  // Check out
  Future<void> checkOut() async {
    final user = _auth.currentUser;
    if (user == null) throw 'User not authenticated';

    final todayAttendance = await getTodayAttendance();
    if (todayAttendance == null) throw 'No check-in record found for today';

    // Get current location
    final position = await getCurrentPosition();

    await _firestore
        .collection('attendance')
        .where('userId', isEqualTo: user.uid)
        .where('checkInTime', isEqualTo: Timestamp.fromDate(todayAttendance.checkInTime))
        .get()
        .then((snapshot) async {
      if (snapshot.docs.isEmpty) throw 'Attendance record not found';
      
      await snapshot.docs.first.reference.update({
        'checkOutTime': Timestamp.fromDate(DateTime.now()),
        'checkOutLocation': GeoPoint(position.latitude, position.longitude),
        'status': 'checked_out',
      });
    });
  }

  // Get current position
  Future<Position> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Location services are disabled';
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'Location permissions are denied';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw 'Location permissions are permanently denied';
    }

    return await Geolocator.getCurrentPosition();
  }
} 