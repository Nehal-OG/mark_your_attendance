class AttendanceModel {
  final String id;
  final String userId;
  final DateTime checkIn;
  final DateTime? checkOut;
  final String status;
  final String? notes;

  AttendanceModel({
    required this.id,
    required this.userId,
    required this.checkIn,
    this.checkOut,
    required this.status,
    this.notes,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['id'],
      userId: json['user_id'],
      checkIn: DateTime.parse(json['check_in']),
      checkOut: json['check_out'] != null ? DateTime.parse(json['check_out']) : null,
      status: json['status'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'check_in': checkIn.toIso8601String(),
      'check_out': checkOut?.toIso8601String(),
      'status': status,
      'notes': notes,
    };
  }
} 