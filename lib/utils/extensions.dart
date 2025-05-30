import 'package:ecom_modwir/models/vehicle_model.dart';

extension VehicleModelExtension on VehicleModel {
  Map<String, dynamic> toJson() {
    return {
      'vehicle_id': vehicleId,
      'user_id': userId,
      'car_make_id': carMakeId,
      'car_model_id': carModelId,
      'year': year,
      'license_plate_number': licensePlateNumber,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'make_name': makeName,
      'model_name': modelName,
      'make_logo': makeLogo,
    };
  }
}
