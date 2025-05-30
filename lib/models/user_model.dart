// lib/models/user_model.dart
class UserModel {
  final int userId;
  final String fullName;
  final String? phone;
  final int? verifyCode;
  final String status;
  final int approve;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.userId,
    required this.fullName,
    this.phone,
    this.verifyCode,
    required this.status,
    required this.approve,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id'],
      fullName: json['full_name'],
      phone: json['phone'],
      verifyCode: json['verfiycode'],
      status: json['status'],
      approve: json['approve'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'full_name': fullName,
      'phone': phone,
      'verfiycode': verifyCode,
      'status': status,
      'approve': approve,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

