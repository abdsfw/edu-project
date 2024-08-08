import 'exercise_answer.dart';

class ExerciseQuestion {
  int? id;
  String? url;
  int? mark;
  String? urlType;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? questionId;
  List<ExerciseAnswer>? exerciseAnswers;

  ExerciseQuestion({
    this.id,
    this.url,
    this.mark,
    this.urlType,
    this.createdAt,
    this.updatedAt,
    this.questionId,
    this.exerciseAnswers,
  });

  factory ExerciseQuestion.fromJson(Map<String, dynamic> json) {
    return ExerciseQuestion(
      id: json['id'] as int?,
      url: json['url'] as String?,
      mark: json['mark'] as int?,
      urlType: json['url_type'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      questionId: json['question_id'] as int?,
      exerciseAnswers: (json['exercise_answers'] as List<dynamic>?)
          ?.map((e) => ExerciseAnswer.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'url': url,
        'mark': mark,
        'url_type': urlType,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'question_id': questionId,
        'exercise_answers': exerciseAnswers?.map((e) => e.toJson()).toList(),
      };
}
