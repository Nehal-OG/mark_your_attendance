import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mark_your_attendance/core/routes/app_routes.dart';
import 'package:mark_your_attendance/core/utils/phone_utils.dart';

class RegistrationController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Step tracking
  final RxInt currentStep = 0.obs;
  
  // Form data
  final RxString phoneNumber = ''.obs;
  final RxString name = ''.obs;
  final RxString verificationId = ''.obs;
  
  // Loading and error states
  final RxBool isLoading = false.obs;
  final RxString verificationError = ''.obs;
  
  // Clear error message
  void resetError() {
    verificationError.value = '';
  }

  // Update phone number with proper formatting
  void updatePhoneNumber(String value) {
    phoneNumber.value = PhoneUtils.formatForDisplay(value);
  }

  // Step 1: Send OTP
  Future<void> sendOTP(String phone) async {
    try {
      isLoading.value = true;
      verificationError.value = '';

      // Validate phone number
      final phoneError = PhoneUtils.validatePhoneNumber(phone);
      if (phoneError != null) {
        throw phoneError;
      }

      // Format phone number to E.164
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

      // Store formatted phone number
      phoneNumber.value = formattedPhone;

      await _auth.verifyPhoneNumber(
        phoneNumber: formattedPhone,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-verification (Android only)
          try {
            await _signInWithCredential(credential);
            currentStep.value = 2; // Skip OTP step on auto-verification
          } catch (e) {
            verificationError.value = e.toString();
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          String errorMessage = 'Verification failed';
          switch (e.code) {
            case 'invalid-phone-number':
              errorMessage = 'Invalid phone number format';
              break;
            case 'too-many-requests':
              errorMessage = 'Too many attempts. Please try again later';
              break;
            default:
              errorMessage = e.message ?? errorMessage;
          }
          throw errorMessage;
        },
        codeSent: (String verId, int? resendToken) {
          verificationId.value = verId;
          currentStep.value = 1; // Move to OTP step
          Get.toNamed(AppRoutes.VERIFY_OTP);
        },
        codeAutoRetrievalTimeout: (String verId) {
          verificationId.value = verId;
        },
      );
    } catch (e) {
      verificationError.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Step 2: Verify OTP
  Future<void> verifyOTP(String otp) async {
    try {
      isLoading.value = true;
      verificationError.value = '';

      if (otp.length != 6) {
        throw 'Please enter a valid 6-digit OTP';
      }

      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId.value,
        smsCode: otp,
      );

      await _signInWithCredential(credential);
      currentStep.value = 2; // Move to password step
    } catch (e) {
      if (e is FirebaseAuthException) {
        verificationError.value = e.message ?? 'Verification failed';
      } else {
        verificationError.value = e.toString();
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Step 3: Complete Registration
  Future<void> completeRegistration(String password) async {
    try {
      isLoading.value = true;
      verificationError.value = '';

      if (password.length < 6) {
        throw 'Password must be at least 6 characters';
      }

      final user = _auth.currentUser;
      if (user == null) throw 'Authentication error';

      // Create user document in Firestore
      await _firestore.collection('users').doc(user.uid).set({
        'phoneNumber': phoneNumber.value,
        'name': name.value,
        'password': password,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLoginAt': FieldValue.serverTimestamp(),
      });

      Get.offAllNamed(AppRoutes.MAIN);
    } catch (e) {
      verificationError.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Helper method for signing in with credential
  Future<void> _signInWithCredential(PhoneAuthCredential credential) async {
    try {
      await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-verification-code':
          throw 'Invalid OTP code';
        case 'invalid-verification-id':
          throw 'Invalid verification session';
        default:
          throw e.message ?? 'Authentication failed';
      }
    }
  }
} 