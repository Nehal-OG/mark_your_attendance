import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PasswordResetService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _verificationId;

  // Send OTP
  Future<void> sendOTP(String phoneNumber) async {
    try {
      // First check if user exists
      final userDoc = await _firestore
          .collection('users')
          .where('phoneNumber', isEqualTo: phoneNumber)
          .limit(1)
          .get();

      if (userDoc.docs.isEmpty) {
        throw 'No account found with this phone number';
      }

      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-verification if possible (Android only)
        },
        verificationFailed: (FirebaseAuthException e) {
          throw e.message ?? 'Verification failed';
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      throw e.toString();
    }
  }

  // Verify OTP
  Future<void> verifyOTP(String otp) async {
    try {
      if (_verificationId == null) {
        throw 'Please request OTP first';
      }

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );

      await _auth.signInWithCredential(credential);
    } catch (e) {
      throw e.toString();
    }
  }

  // Update password
  Future<void> updatePassword(String phoneNumber, String newPassword) async {
    try {
      // Find user document
      final userDoc = await _firestore
          .collection('users')
          .where('phoneNumber', isEqualTo: phoneNumber)
          .limit(1)
          .get();

      if (userDoc.docs.isEmpty) {
        throw 'User not found';
      }

      // Update password in Firestore
      await _firestore
          .collection('users')
          .doc(userDoc.docs.first.id)
          .update({
        'password': newPassword, // Note: In production, use proper password hashing
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Sign out the user after password update
      await _auth.signOut();
    } catch (e) {
      throw e.toString();
    }
  }
} 