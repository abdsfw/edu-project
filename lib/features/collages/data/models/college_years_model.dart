class CollegeYearsModel {
  int? id;
  String? year;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? collageId;

  CollegeYearsModel({
    this.id,
    this.year,
    this.createdAt,
    this.updatedAt,
    this.collageId,
  });

  factory CollegeYearsModel.fromJson(Map<String, dynamic> json) {
    return CollegeYearsModel(
      id: json['id'] as int?,
      year: json['year'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      collageId: json['collage_id'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'year': year,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'collage_id': collageId,
      };
}
