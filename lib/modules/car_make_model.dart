import 'dart:convert';

class CarMakeModel {
  final int makeId;
  final Map<String, String> name;
  final String? logo;
  final int popularity;
  final int status;

  CarMakeModel({
    required this.makeId,
    required this.name,
    this.logo,
    required this.popularity,
    required this.status,
  });

  factory CarMakeModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> nameJson = {};
    if (json['name'] is String) {
      nameJson = jsonDecode(json['name']);
    } else {
      nameJson = json['name'];
    }

    return CarMakeModel(
      makeId: json['make_id'],
      name: Map<String, String>.from(nameJson),
      logo: json['logo'],
      popularity: json['popularity'],
      status: json['status'],
    );
  }

  String getLocalizedName(String languageCode) {
    return name[languageCode] ?? name['en'] ?? 'Unknown';
  }
}
