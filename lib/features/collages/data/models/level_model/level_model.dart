import 'package:educational_app/features/collages/data/models/level_model/course.dart';

import 'pdf.dart';
import 'video.dart';

class LevelModel {
  int? id;
  String? name;
  Course? course;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? courseId;
  List<Pdf>? pdfs;
  List<Video>? videos;

  LevelModel({
    this.id,
    this.name,
    this.course,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.courseId,
    this.pdfs,
    this.videos,
  });

  factory LevelModel.fromJson(Map<String, dynamic> json) => LevelModel(
        id: json['id'] as int?,
        name: json['name'] as String?,
        course: json['course'] == null
            ? null
            : Course.fromJson(json['course'] as Map<String, dynamic>),
        description: json['description'] as String?,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt'] as String),
        courseId: json['course_id'] as int?,
        pdfs: (json['pdfs'] as List<dynamic>?)
            ?.map((e) => Pdf.fromJson(e as Map<String, dynamic>))
            .toList(),
        videos: (json['videos'] as List<dynamic>?)
            ?.map((e) => Video.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'course_id': courseId,
        'pdfs': pdfs?.map((e) => e.toJson()).toList(),
        'videos': videos?.map((e) => e.toJson()).toList(),
      };
}
