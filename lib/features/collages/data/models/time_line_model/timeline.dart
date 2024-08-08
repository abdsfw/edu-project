import 'level.dart';
import 'quiz.dart';

class Timeline {
  int? id;
  int? order;
  bool? available;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? courseId;
  int? levelId;
  int? quizId;
  Level? level;
  Quiz? quiz;

  Timeline({
    this.id,
    this.order,
    this.available,
    this.createdAt,
    this.updatedAt,
    this.courseId,
    this.levelId,
    this.quizId,
    this.level,
    this.quiz,
  });

  factory Timeline.fromJson(Map<String, dynamic> json) => Timeline(
        id: json['id'] as int?,
        order: json['order'] as int?,
        available: json['available'] as bool?,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt'] as String),
        courseId: json['course_id'] as int?,
        levelId: json['level_id'] as int?,
        quizId: json['quiz_id'] as int?,
        level: json['level'] == null
            ? null
            : Level.fromJson(json['level'] as Map<String, dynamic>),
        quiz: json['quiz'] == null
            ? null
            : Quiz.fromJson(json['quiz'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'order': order,
        'available': available,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'course_id': courseId,
        'level_id': levelId,
        'quiz_id': quizId,
        'level': level?.toJson(),
        'quiz': quiz?.toJson(),
      };
}
