import 'question.dart';

class QuizModel {
  // int? id;
  String? name;
  int? successMark;
  int? fullMark;
  int? courseId;
  // String? model;
  // DateTime? createdAt;
  // DateTime? updatedAt;
  List<Question>? questions;

  QuizModel({
    // this.id,
    this.name,
    this.successMark,
    this.fullMark,
    this.courseId,
    // this.model,
    // this.createdAt,
    // this.updatedAt,
    this.questions,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) => QuizModel(
        // id: json['id'] as int?,
        name: json['name'] as String?,
        successMark: json['success_mark'] as int?,
        fullMark: json['full_mark'] as int?,
        courseId: json['course_id'] as int?,

        // model: json['model'] as String?,
        // createdAt: json['createdAt'] == null
        //     ? null
        //     : DateTime.parse(json['createdAt'] as String),
        // updatedAt: json['updatedAt'] == null
        //     ? null
        //     : DateTime.parse(json['updatedAt'] as String),
        questions: (json['questions'] as List<dynamic>?)
            ?.map((e) => Question.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        // 'id': id,
        'name': name,
        'success_mark': successMark,
        'full_mark': fullMark,
        'course_id': courseId,
        // 'model': model,
        // 'createdAt': createdAt?.toIso8601String(),
        // 'updatedAt': updatedAt?.toIso8601String(),
        'questions': questions?.map((e) => e.toJson()).toList(),
      };
}
