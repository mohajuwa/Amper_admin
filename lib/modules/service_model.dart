import 'dart:convert';

class ServiceModel {
  final int serviceId;
  final Map<String, String> serviceName;
  final String? serviceImg;
  final int status;
  final DateTime createdAt;
  final DateTime updatedAt;

  ServiceModel({
    required this.serviceId,
    required this.serviceName,
    this.serviceImg,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> nameJson = {};
    if (json['service_name'] is String) {
      nameJson = jsonDecode(json['service_name']);
    } else {
      nameJson = json['service_name'];
    }

    return ServiceModel(
      serviceId: json['service_id'],
      serviceName: Map<String, String>.from(nameJson),
      serviceImg: json['service_img'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  String getLocalizedName(String languageCode) {
    return serviceName[languageCode] ?? serviceName['en'] ?? 'Unknown';
  }
}
