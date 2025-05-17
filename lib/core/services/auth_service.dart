import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';

class AuthService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  final Rx<User?> user = Rx<User?>(null);
  final RxString verificationId = ''.obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    user.value = _auth.currentUser;
    _auth.authStateChanges().listen((User? user) {
      this.user.value = user;
    });
    super.onInit();
  }

  Future<void> sendOTP(String phoneNumber) async {
    try {
      isLoading.value = true;
      error.value = '';
      
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          error.value = e.message ?? 'Verification failed';
        },
        codeSent: (String vId, int? resendToken) {
          verificationId.value = vId;
        },
        codeAutoRetrievalTimeout: (String vId) {
          verificationId.value = vId;
        },
      );
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> verifyOTP(String otp) async {
    try {
      isLoading.value = true;
      error.value = '';

      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId.value,
        smsCode: otp,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      
      if (userCredential.user != null) {
        await _saveUserLocation(userCredential.user!.phoneNumber!);
        return true;
      }
      return false;
    } catch (e) {
      error.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _saveUserLocation(String phoneNumber) async {
    try {
      final position = await Geolocator.getCurrentPosition();
      
      await _firestore.collection('users').doc(_auth.currentUser?.uid).set({
        'phoneNumber': phoneNumber,
        'location': GeoPoint(position.latitude, position.longitude),
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error saving user location: $e');
    }
  }

  Future<void> updatePhoneNumber(String newPhoneNumber, String otp) async {
    try {
      isLoading.value = true;
      error.value = '';

      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId.value,
        smsCode: otp,
      );

      await _auth.currentUser?.updatePhoneNumber(credential);
      await _saveUserLocation(newPhoneNumber);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      error.value = e.toString();
    }
  }

  bool isAuthenticated() {
    return _auth.currentUser != null;
  }
} 