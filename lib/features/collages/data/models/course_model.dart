class CourseModel {
  int? id;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? collegeYearId;
  int? managerId;
  CourseModel({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.collegeYearId,
    this.managerId,
  });
  factory CourseModel.fromJson(Map<String, dynamic> json) => CourseModel(
        id: json['id'] as int?,
        name: json['name'] as String?,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt'] as String),
        collegeYearId: json['collage_year_id'] as int?,
        managerId: json['manager_id'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'collage_year_id': collegeYearId,
        'manager_id': managerId,
      };
}
