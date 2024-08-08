class CollegeModel {
  int? id;
  String? name;
  String? region;
  DateTime? createdAt;
  DateTime? updatedAt;

  CollegeModel({
    this.id,
    this.name,
    this.region,
    this.createdAt,
    this.updatedAt,
  });

  factory CollegeModel.fromJson(Map<String, dynamic> json) => CollegeModel(
        id: json['id'] as int?,
        name: json['name'] as String?,
        region: json['region'] as String?,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'region': region,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };
}
