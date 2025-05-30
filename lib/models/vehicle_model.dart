import 'dart:convert';

class VehicleModel {
  final int vehicleId;
  final int userId;
  final int carMakeId;
  final int carModelId;
  final int? year;
  final Map<String, String>? licensePlateNumber;
  final int status;
  final DateTime createdAt;
  final String? makeName;
  final String? modelName;
  final String? makeLogo;

  VehicleModel({
    required this.vehicleId,
    required this.userId,
    required this.carMakeId,
    required this.carModelId,
    this.year,
    this.licensePlateNumber,
    required this.status,
    required this.createdAt,
    this.makeName,
    this.modelName,
    this.makeLogo,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    Map<String, String>? plateNumber;
    if (json['license_plate_number'] != null) {
      Map<String, dynamic> plateJson = {};
      if (json['license_plate_number'] is String) {
        plateJson = jsonDecode(json['license_plate_number']);
      } else {
        plateJson = json['license_plate_number'];
      }
      plateNumber = Map<String, String>.from(plateJson);
    }

    return VehicleModel(
      vehicleId: json['vehicle_id'],
      userId: json['user_id'],
      carMakeId: json['car_make_id'],
      carModelId: json['car_model_id'],
      year: json['year'],
      licensePlateNumber: plateNumber,
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      makeName: json['make_name'],
      modelName: json['model_name'],
      makeLogo: json['make_logo'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'vehicle_id': vehicleId,
      'user_id': userId,
      'car_make_id': carMakeId,
      'car_model_id': carModelId,
      'year': year,
      'license_plate_number':
          licensePlateNumber != null ? jsonEncode(licensePlateNumber) : null,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'make_name': makeName,
      'model_name': modelName,
      'make_logo': makeLogo,
    };
  }

  String getLocalizedPlateNumber(String languageCode) {
    return licensePlateNumber?[languageCode] ??
        licensePlateNumber?['en'] ??
        'N/A';
  }
}
