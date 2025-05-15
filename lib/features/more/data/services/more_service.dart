import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mark_your_attendance/features/attendance/data/models/attendance_model.dart';

class MoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get all attendance records for current user
  Future<List<AttendanceModel>> getAllAttendance() async {
    final user = _auth.currentUser;
    if (user == null) throw 'User not authenticated';

    final snapshot = await _firestore
        .collection('attendance')
        .where('userId', isEqualTo: user.uid)
        .orderBy('checkInTime', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => AttendanceModel.fromMap(doc.data()))
        .toList();
  }

  // Verify old password
  Future<bool> verifyPassword(String oldPassword) async {
    final user = _auth.currentUser;
    if (user == null) throw 'User not authenticated';

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) throw 'User data not found';

    return doc.data()?['password'] == oldPassword;
  }

  // Update password
  Future<void> updatePassword(String newPassword) async {
    final user = _auth.currentUser;
    if (user == null) throw 'User not authenticated';

    await _firestore.collection('users').doc(user.uid).update({
      'password': newPassword,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }
} 