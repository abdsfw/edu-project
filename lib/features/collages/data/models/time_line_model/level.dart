class Level {
  int? id;
  String? name;
  String? video;
  String? discription;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? courseId;

  Level({
    this.id,
    this.name,
    this.video,
    this.discription,
    this.createdAt,
    this.updatedAt,
    this.courseId,
  });

  factory Level.fromJson(Map<String, dynamic> json) => Level(
        id: json['id'] as int?,
        name: json['name'] as String?,
        video: json['video'] as String?,
        discription: json['discription'] as String?,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt'] as String),
        courseId: json['course_id'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'video': video,
        'discription': discription,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'course_id': courseId,
      };
}
