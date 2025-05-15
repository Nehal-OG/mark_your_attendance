import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mark_your_attendance/core/routes/app_routes.dart';
import 'package:mark_your_attendance/core/utils/phone_utils.dart';

class RegistrationController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final _isLoading = false.obs;
  final _errorMessage = ''.obs;
  final _phoneNumber = ''.obs;
  final _verificationId = ''.obs;

  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  String get phoneNumber => _phoneNumber.value;

  // Update phone number with formatting
  void updatePhoneNumber(String value) {
    _phoneNumber.value = PhoneUtils.formatForDisplay(value);
  }

  // Register new user
  Future<void> register(String name, String phone, String password) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      // Validate phone number
      final phoneError = PhoneUtils.validatePhoneNumber(phone);
      if (phoneError != null) {
        throw phoneError;
      }

      // Format phone number
      final formattedPhone = PhoneUtils.formatPhoneNumber(phone);

      // Check if phone number already exists
      final existingUser = await _firestore
          .collection('users')
          .where('phoneNumber', isEqualTo: formattedPhone)
          .limit(1)
          .get();

      if (existingUser.docs.isNotEmpty) {
        throw 'Phone number already registered';
      }

      // Send OTP
      await _sendOTP(formattedPhone);

      // Store registration data temporarily
      Get.toNamed(AppRoutes.VERIFY_OTP, arguments: {
        'name': name,
        'phoneNumber': formattedPhone,
        'password': password,
      });
    } catch (e) {
      _errorMessage.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  // Send OTP
  Future<void> _sendOTP(String phoneNumber) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-verification if possible (Android only)
        },
        verificationFailed: (FirebaseAuthException e) {
          throw e.message ?? 'Verification failed';
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId.value = verificationId;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId.value = verificationId;
        },
      );
    } catch (e) {
      throw e.toString();
    }
  }

  // Verify OTP and complete registration
  Future<void> verifyOTP(String otp, Map<String, dynamic> userData) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      // Verify OTP
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId.value,
        smsCode: otp,
      );

      // Sign in with credential
      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user == null) throw 'Registration failed';

      // Create user document in Firestore
      await _firestore.collection('users').doc(user.uid).set({
        'name': userData['name'],
        'phoneNumber': userData['phoneNumber'],
        'password': userData['password'],
        'createdAt': FieldValue.serverTimestamp(),
        'lastLoginAt': FieldValue.serverTimestamp(),
      });

      Get.offAllNamed(AppRoutes.MAIN);
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