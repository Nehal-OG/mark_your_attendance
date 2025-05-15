import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceModel {
  final String userId;
  final DateTime checkInTime;
  final DateTime? checkOutTime;
  final GeoPoint checkInLocation;
  final GeoPoint? checkOutLocation;
  final String status; // 'checked_in' or 'checked_out'

  AttendanceModel({
    required this.userId,
    required this.checkInTime,
    this.checkOutTime,
    required this.checkInLocation,
    this.checkOutLocation,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'checkInTime': Timestamp.fromDate(checkInTime),
      'checkOutTime': checkOutTime != null ? Timestamp.fromDate(checkOutTime!) : null,
      'checkInLocation': checkInLocation,
      'checkOutLocation': checkOutLocation,
      'status': status,
    };
  }

  factory AttendanceModel.fromMap(Map<String, dynamic> map) {
    return AttendanceModel(
      userId: map['userId'] as String,
      checkInTime: (map['checkInTime'] as Timestamp).toDate(),
      checkOutTime: map['checkOutTime'] != null 
          ? (map['checkOutTime'] as Timestamp).toDate() 
          : null,
      checkInLocation: map['checkInLocation'] as GeoPoint,
      checkOutLocation: map['checkOutLocation'] as GeoPoint?,
      status: map['status'] as String,
    );
  }
} 