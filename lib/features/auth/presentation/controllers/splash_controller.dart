import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mark_your_attendance/core/routes/app_routes.dart';

class SplashController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      await Future.delayed(const Duration(seconds: 2)); // Splash screen delay

      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        _navigateToLogin();
        return;
      }

      // Check if user has valid metadata
      final metadata = currentUser.metadata;
      final lastSignInTime = metadata.lastSignInTime;
      
      // If last sign in was more than 30 days ago or doesn't exist, force logout
      if (lastSignInTime == null || 
          DateTime.now().difference(lastSignInTime).inDays > 30) {
        print('Debug: Session expired - Last sign in: $lastSignInTime'); // Debug log
        await _forceLogout();
        return;
      }

      // Verify user exists in Firestore
      final userDoc = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (!userDoc.exists) {
        print('Debug: User document not found in Firestore'); // Debug log
        await _forceLogout();
        return;
      }

      // All checks passed, proceed to main screen
      print('Debug: Auto-login successful for user: ${currentUser.uid}'); // Debug log
      Get.offAllNamed(AppRoutes.MAIN);
    } catch (e) {
      print('Debug: Error during auth check - $e'); // Debug log
      await _forceLogout();
    }
  }

  Future<void> _forceLogout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Debug: Error during force logout - $e'); // Debug log
    } finally {
      _navigateToLogin();
    }
  }

  void _navigateToLogin() {
    Get.offAllNamed(AppRoutes.LOGIN);
  }
} 