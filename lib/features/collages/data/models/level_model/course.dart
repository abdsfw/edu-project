class Course {
  int? id;
  String? name;
  String? center;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? collegeYearId;
  int? managerId;
  Course({
    this.id,
    this.name,
    this.center,
    this.createdAt,
    this.updatedAt,
    this.collegeYearId,
    this.managerId,
  });
  factory Course.fromJson(Map<String, dynamic> json) => Course(
        id: json['id'] as int?,
        name: json['name'] as String?,
        center: json['center'] as String?,
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
        'center': center,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'collage_year_id': collegeYearId,
        'manager_id': managerId,
      };
}
