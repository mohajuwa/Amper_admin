class AddressModel {
  final int addressId;

  final int userId;

  final String addressName;

  final String addressCity;

  final String addressStreet;

  final double? lat;

  final double? lng;

  final int status;

  AddressModel({
    required this.addressId,
    required this.userId,
    required this.addressName,
    required this.addressCity,
    required this.addressStreet,
    this.lat,
    this.lng,
    required this.status,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      addressId: json['address_id'],
      userId: json['user_id'],
      addressName: json['address_name'],
      addressCity: json['address_city'],
      addressStreet: json['address_street'],
      lat: json['lat']?.toDouble(),
      lng: json['lng']?.toDouble(),
      status: json['status'],
    );
  }
}
