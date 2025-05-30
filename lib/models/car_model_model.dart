class CarModelModel {
  final int modelId;

  final int makeId;

  final Map<String, String> name;

  final int year;

  final String? image;

  final int status;

  CarModelModel({
    required this.modelId,
    required this.makeId,
    required this.name,
    required this.year,
    this.image,
    required this.status,
  });

  factory CarModelModel.fromJson(Map<String, dynamic> json) {
    return CarModelModel(
      modelId: json['model_id'],
      makeId: json['make_id'],
      name: Map<String, String>.from(json['name'] ?? {}),
      year: json['year'],
      image: json['image'],
      status: json['status'],
    );
  }

  String getLocalizedName(String languageCode) {
    return name[languageCode] ?? name['en'] ?? 'Unknown';
  }
}
