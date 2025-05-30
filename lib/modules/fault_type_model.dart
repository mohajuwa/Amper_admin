class FaultTypeModel {
  final int faultTypeId;

  final Map<String, String> name;

  final Map<String, String>? description;

  final int status;

  final DateTime createdAt;

  FaultTypeModel({
    required this.faultTypeId,
    required this.name,
    this.description,
    required this.status,
    required this.createdAt,
  });

  factory FaultTypeModel.fromJson(Map<String, dynamic> json) {
    return FaultTypeModel(
      faultTypeId: json['fault_type_id'],
      name: Map<String, String>.from(json['name'] ?? {}),
      description: json['description'] != null
          ? Map<String, String>.from(json['description'])
          : null,
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  String getLocalizedName(String languageCode) {
    return name[languageCode] ?? name['en'] ?? 'Unknown';
  }
}
