import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Login with phone and password
  Future<UserCredential> loginWithPhoneAndPassword(
    String phoneNumber,
    String password,
  ) async {
    try {
      // First, find the user document by phone number
      final userDoc = await _firestore
          .collection('users')
          .where('phoneNumber', isEqualTo: phoneNumber)
          .limit(1)
          .get();

      if (userDoc.docs.isEmpty) {
        throw 'User not found';
      }

      // Check if password matches
      final userData = userDoc.docs.first.data();
      if (userData['password'] != password) { // Note: In production, use proper password hashing
        throw 'Invalid password';
      }

      // Create custom token or use phone auth
      // For this example, we'll use anonymous sign in
      // In production, you should use proper phone authentication
      return await _auth.signInAnonymously();
    } catch (e) {
      throw e.toString();
    }
  }

  // Get current user data
  Future<Map<String, dynamic>?> getCurrentUserData() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final userDoc = await _firestore
          .collection('users')
          .where('phoneNumber', isEqualTo: user.phoneNumber)
          .limit(1)
          .get();

      if (userDoc.docs.isEmpty) return null;

      return userDoc.docs.first.data();
    } catch (e) {
      return null;
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }
} 