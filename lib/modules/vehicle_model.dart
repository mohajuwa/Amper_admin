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

    try {
      if (json['license_plate_number'] != null) {
        Map<String, dynamic> plateJson = {};

        if (json['license_plate_number'] is String) {
          plateJson = jsonDecode(json['license_plate_number']);
        } else if (json['license_plate_number'] is Map) {
          plateJson = Map<String, dynamic>.from(json['license_plate_number']);
        }

        plateNumber = Map<String, String>.from(plateJson);
      }
    } catch (e) {
      print('Error parsing license plate: $e');

      plateNumber = null;
    }

    return VehicleModel(
      vehicleId: _parseIntSafely(json['vehicle_id'], 'vehicleId'),
      userId: _parseIntSafely(json['user_id'], 'userId'),
      carMakeId: _parseIntSafely(json['car_make_id'], 'carMakeId'),
      carModelId: _parseIntSafely(json['car_model_id'], 'carModelId'),
      year: json['year'] != null ? _parseIntSafely(json['year'], 'year') : null,
      licensePlateNumber: plateNumber,
      status: _parseIntSafely(json['status'], 'status'),
      createdAt: _parseDateTimeSafely(json['created_at']),
      makeName: json['make_name']?.toString(),
      modelName: json['model_name']?.toString(),
      makeLogo: json['make_logo']?.toString(),
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

  // Helper method to safely parse integers

  static int _parseIntSafely(dynamic value, String fieldName) {
    if (value == null) {
      print('Warning: $fieldName is null, using 0 as default');

      return 0;
    }

    if (value is int) {
      return value;
    }

    if (value is String) {
      final parsed = int.tryParse(value);

      if (parsed != null) {
        return parsed;
      }
    }

    print(
        'Warning: Could not parse $fieldName value "$value", using 0 as default');

    return 0;
  }

// Helper method to safely parse DateTime

  static DateTime _parseDateTimeSafely(dynamic value) {
    if (value == null) {
      print('Warning: DateTime field is null, using current time');

      return DateTime.now();
    }

    try {
      if (value is String) {
        return DateTime.parse(value);
      }

      print(
          'Warning: DateTime field is not a string: $value, using current time');

      return DateTime.now();
    } catch (e) {
      print(
          'Warning: Could not parse DateTime "$value": $e, using current time');

      return DateTime.now();
    }
  }
}
