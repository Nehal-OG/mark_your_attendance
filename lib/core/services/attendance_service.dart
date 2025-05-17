import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import '../utils/app_utils.dart';

class AttendanceService extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxString checkInTime = ''.obs;
  final RxString checkOutTime = ''.obs;
  final RxString attendanceStatus = ''.obs;
  final RxDouble registeredLat = 0.0.obs;
  final RxDouble registeredLng = 0.0.obs;
  final RxDouble currentLat = 0.0.obs;
  final RxDouble currentLng = 0.0.obs;

  Future<void> checkIn() async {
    if (!await AppUtils.ensureInternetAccess()) return;
    if (!await AppUtils.ensureLocationAccess()) return;
    
    try {
      isLoading.value = true;
      error.value = '';

      final position = await Geolocator.getCurrentPosition();
      final now = DateTime.now();
      final String formattedDate = DateFormat('yyyy-MM-dd').format(now);
      final String formattedTime = DateFormat('HH:mm:ss').format(now);

      await _firestore
          .collection('attendance')
          .doc(_auth.currentUser?.uid)
          .collection('records')
          .doc(formattedDate)
          .set({
        'checkInTime': formattedTime,
        'checkInLocation': GeoPoint(position.latitude, position.longitude),
        'date': formattedDate,
        'status': 'Checked In',
      });

      checkInTime.value = formattedTime;
      attendanceStatus.value = 'Checked In';
      currentLat.value = position.latitude;
      currentLng.value = position.longitude;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkOut() async {
    if (!await AppUtils.ensureInternetAccess()) return;

    try {
      isLoading.value = true;
      error.value = '';

      final position = await Geolocator.getCurrentPosition();
      final now = DateTime.now();
      final String formattedDate = DateFormat('yyyy-MM-dd').format(now);
      final String formattedTime = DateFormat('HH:mm:ss').format(now);

      await _firestore
          .collection('attendance')
          .doc(_auth.currentUser?.uid)
          .collection('records')
          .doc(formattedDate)
          .update({
        'checkOutTime': formattedTime,
        'checkOutLocation': GeoPoint(position.latitude, position.longitude),
        'status': 'Checked Out',
      });

      checkOutTime.value = formattedTime;
      attendanceStatus.value = 'Checked Out';
      currentLat.value = position.latitude;
      currentLng.value = position.longitude;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<Map<DateTime, bool>> getMonthlyAttendance() async {
    if (!await AppUtils.ensureInternetAccess()) return {};

    try {
      final Map<DateTime, bool> attendanceMap = {};
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);
      final endOfMonth = DateTime(now.year, now.month + 1, 0);

      final querySnapshot = await _firestore
          .collection('attendance')
          .doc(_auth.currentUser?.uid)
          .collection('records')
          .where('date',
              isGreaterThanOrEqualTo:
                  DateFormat('yyyy-MM-dd').format(startOfMonth))
          .where('date',
              isLessThanOrEqualTo: DateFormat('yyyy-MM-dd').format(endOfMonth))
          .get();

      for (var doc in querySnapshot.docs) {
        final date = DateFormat('yyyy-MM-dd').parse(doc['date'] as String);
        attendanceMap[date] = true;
      }

      return attendanceMap;
    } catch (e) {
      error.value = e.toString();
      return {};
    }
  }

  Future<List<Map<String, dynamic>>> getAttendanceRecords() async {
    if (!await AppUtils.ensureInternetAccess()) return [];

    try {
      final querySnapshot = await _firestore
          .collection('attendance')
          .doc(_auth.currentUser?.uid)
          .collection('records')
          .orderBy('date', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => {
                'date': doc['date'],
                'checkInTime': doc['checkInTime'],
                'checkOutTime': doc['checkOutTime'] ?? '',
                'status': doc['status'],
              })
          .toList();
    } catch (e) {
      error.value = e.toString();
      return [];
    }
  }

  Future<void> loadTodayAttendance() async {
    if (!await AppUtils.ensureInternetAccess()) return;

    try {
      final String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final doc = await _firestore
          .collection('attendance')
          .doc(_auth.currentUser?.uid)
          .collection('records')
          .doc(today)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        checkInTime.value = data['checkInTime'] ?? '';
        checkOutTime.value = data['checkOutTime'] ?? '';
        attendanceStatus.value = data['status'] ?? '';
      } else {
        checkInTime.value = '';
        checkOutTime.value = '';
        attendanceStatus.value = '';
      }
    } catch (e) {
      error.value = e.toString();
    }
  }
} 