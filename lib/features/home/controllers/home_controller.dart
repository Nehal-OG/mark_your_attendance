import 'dart:async';
import 'package:get/get.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/attendance_service.dart';

class HomeController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final AttendanceService _attendanceService = Get.find<AttendanceService>();

  final RxString userName = ''.obs;
  final RxString checkInTime = ''.obs;
  final RxString checkOutTime = ''.obs;
  final RxString attendanceStatus = ''.obs;
  final RxDouble registeredLat = 0.0.obs;
  final RxDouble registeredLng = 0.0.obs;
  final RxDouble currentLat = 0.0.obs;
  final RxDouble currentLng = 0.0.obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    userName.value = _authService.user.value?.phoneNumber ?? '';
    _loadTodayAttendance();
    _startTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      update(['currentTime']);
    });
  }

  final currentTime = DateTime.now().obs;

  void startClock() {
    Timer.periodic(const Duration(seconds: 60), (_) {
      currentTime.value = DateTime.now();
    });
  }

  Future<void> _loadTodayAttendance() async {
    await _attendanceService.loadTodayAttendance();
    checkInTime.value = _attendanceService.checkInTime.value;
    checkOutTime.value = _attendanceService.checkOutTime.value;
    attendanceStatus.value = _attendanceService.attendanceStatus.value;
    registeredLat.value = _attendanceService.registeredLat.value;
    registeredLng.value = _attendanceService.registeredLng.value;
    currentLat.value = _attendanceService.currentLat.value;
    currentLng.value = _attendanceService.currentLng.value;
  }

  Future<void> checkIn() async {
    await _attendanceService.checkIn();
    await _loadTodayAttendance();
  }

  Future<void> checkOut() async {
    await _attendanceService.checkOut();
    await _loadTodayAttendance();
  }
}
