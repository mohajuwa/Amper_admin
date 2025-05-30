class AdminModel {
  final int adminId;
  final String fullName;
  final String email;
  final String role;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  AdminModel({
    required this.adminId,
    required this.fullName,
    required this.email,
    required this.role,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AdminModel.fromJson(Map<String, dynamic> json) {
    return AdminModel(
      adminId: json['admin_id'],
      fullName: json['full_name'],
      email: json['email'],
      role: json['role'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
