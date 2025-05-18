import 'dart:developer';
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
      log('📍 Current Location - Lat: ${position.latitude}, Lng: ${position.longitude}');

      final now = DateTime.now();
      final String formattedDate = DateFormat('yyyy-MM-dd').format(now);
      final String formattedTime = DateFormat('HH:mm:ss').format(now);

      log('🕒 Writing check-in data to Firestore...');
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
      }, SetOptions(merge: true));
      log('✅ Check-in data written successfully');

      checkInTime.value = formattedTime;
      attendanceStatus.value = 'Checked In';
      currentLat.value = position.latitude;
      currentLng.value = position.longitude;
    } catch (e) {
      error.value = e.toString();
      log('❌ Error during check-in: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkOut() async {
    if (!await AppUtils.ensureInternetAccess()) return;
    if (!await AppUtils.ensureLocationAccess()) return;

    try {
      isLoading.value = true;
      error.value = '';

      final position = await Geolocator.getCurrentPosition();
      final now = DateTime.now();
      final formattedDate = DateFormat('yyyy-MM-dd').format(now);
      final formattedTime = DateFormat('HH:mm:ss').format(now);

      final docRef = _firestore
          .collection('attendance')
          .doc(_auth.currentUser?.uid)
          .collection('records')
          .doc(formattedDate);

      final docSnapshot = await docRef.get();

      if (!docSnapshot.exists) {
        error.value = 'You must check in first before checking out.';
        return;
      }

      // Optional: Check if already checked out
      final data = docSnapshot.data();
      if (data != null && data.containsKey('checkOutTime')) {
        error.value = 'You have already checked out for today.';
        return;
      }

      await docRef.update({
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
      // Get current device location
      final position = await Geolocator.getCurrentPosition();
      currentLat.value = position.latitude;
      currentLng.value = position.longitude;
      log(
          '📍 Current location (load): ${position.latitude}, ${position.longitude}');

      final String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final doc = await _firestore
          .collection('attendance')
          .doc(_auth.currentUser?.uid)
          .collection('records')
          .doc(today)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        log('📄 Attendance Data Found: $data');

        checkInTime.value = data['checkInTime'] ?? '';
        checkOutTime.value = data['checkOutTime'] ?? '';
        attendanceStatus.value = data['status'] ?? '';

        if (data['checkInLocation'] != null) {
          GeoPoint location = data['checkInLocation'];
          registeredLat.value = location.latitude;
          registeredLng.value = location.longitude;
        } else {
          registeredLat.value = 0.0;
          registeredLng.value = 0.0;
        }
      } else {
        log('ℹ️ No attendance record for today');
        checkInTime.value = '';
        checkOutTime.value = '';
        attendanceStatus.value = '';
        registeredLat.value = 0.0;
        registeredLng.value = 0.0;
      }
    } catch (e) {
      error.value = e.toString();
      log('❌ Error loading today\'s attendance: $e');
    }
  }
}
