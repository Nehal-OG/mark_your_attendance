import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:mark_your_attendance/core/routes/app_routes.dart';

class SplashController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onReady() {
    super.onReady();
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    await Future.delayed(const Duration(seconds: 2)); // Splash screen duration

    // Check if user is logged in
    final User? user = _auth.currentUser;
    
    if (user != null) {
      // User is logged in, verify if email is verified if required
      // if (user.emailVerified) {
      Get.offAllNamed(AppRoutes.HOME);
      // } else {
      //   Get.offAllNamed(AppRoutes.VERIFY_EMAIL);
      // }
    } else {
      // User is not logged in
      Get.offAllNamed(AppRoutes.LOGIN);
    }
  }
} 