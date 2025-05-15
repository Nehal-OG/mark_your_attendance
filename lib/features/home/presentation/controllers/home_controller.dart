import 'dart:async';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mark_your_attendance/features/attendance/data/models/attendance_model.dart';
import 'package:mark_your_attendance/features/attendance/data/services/attendance_service.dart';

class HomeController extends GetxController {
  final AttendanceService _attendanceService;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  HomeController(this._attendanceService);

  final _userName = ''.obs;
  final _currentTime = DateTime.now().obs;
  final _currentPosition = Rxn<Position>();
  final _todayAttendance = Rxn<AttendanceModel>();
  final _isLoading = false.obs;
  final _errorMessage = ''.obs;

  String get userName => _userName.value;
  DateTime get currentTime => _currentTime.value;
  Position? get currentPosition => _currentPosition.value;
  AttendanceModel? get todayAttendance => _todayAttendance.value;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  bool get isCheckedIn => _todayAttendance.value?.status == 'checked_in';

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
    _startTimer();
    _getCurrentLocation();
    _loadTodayAttendance();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _currentTime.value = DateTime.now();
    });
  }

  Future<void> _loadUserData() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final userData = await _firestore.collection('users').doc(user.uid).get();
        _userName.value = userData.data()?['name'] ?? 'User';
      }
    } catch (e) {
      _errorMessage.value = e.toString();
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await _attendanceService.getCurrentPosition();
      _currentPosition.value = position;
    } catch (e) {
      _errorMessage.value = e.toString();
    }
  }

  Future<void> _loadTodayAttendance() async {
    try {
      final attendance = await _attendanceService.getTodayAttendance();
      _todayAttendance.value = attendance;
    } catch (e) {
      _errorMessage.value = e.toString();
    }
  }

  Future<void> checkIn() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      await _attendanceService.checkIn();
      await _loadTodayAttendance();
    } catch (e) {
      _errorMessage.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> checkOut() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      await _attendanceService.checkOut();
      await _loadTodayAttendance();
    } catch (e) {
      _errorMessage.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  void resetError() {
    _errorMessage.value = '';
  }
} 