import 'dart:convert';

class SubServiceModel {
  final int subServiceId;
  final int serviceId;
  final Map<String, String> name;
  final double price;
  final int status;
  final DateTime createdAt;
  final DateTime updatedAt;

  SubServiceModel({
    required this.subServiceId,
    required this.serviceId,
    required this.name,
    required this.price,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SubServiceModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> nameJson = {};
    if (json['name'] is String) {
      nameJson = jsonDecode(json['name']);
    } else {
      nameJson = json['name'];
    }

    return SubServiceModel(
      subServiceId: json['sub_service_id'],
      serviceId: json['service_id'],
      name: Map<String, String>.from(nameJson),
      price: json['price']?.toDouble() ?? 0.0,
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  String getLocalizedName(String languageCode) {
    return name[languageCode] ?? name['en'] ?? 'Unknown';
  }
}
