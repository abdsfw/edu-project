import 'answer.dart';
import 'exercise_question.dart';

class Question {
  int? id;
  String? url;
  int? mark;
  String? urlType;
  String? type;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? quizId;
  List<Answer>? answers;
  List<ExerciseQuestion>? exerciseQuestions;

  Question({
    this.id,
    this.url,
    this.mark,
    this.urlType,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.quizId,
    this.answers,
    this.exerciseQuestions,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        id: json['id'] as int?,
        url: json['url'] as String?,
        mark: json['mark'] as int?,
        urlType: json['url_type'] as String?,
        type: json['type'] as String?,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt'] as String),
        quizId: json['quiz_id'] as int?,
        answers: (json['answers'] as List<dynamic>?)
            ?.map((e) => Answer.fromJson(e as Map<String, dynamic>))
            .toList(),
        exerciseQuestions: (json['exercise_questions'] as List<dynamic>?)
            ?.map((e) => ExerciseQuestion.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'url': url,
        'mark': mark,
        'url_type': urlType,
        'type': type,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'quiz_id': quizId,
        'answers': answers?.map((e) => e.toJson()).toList(),
        'exercise_questions':
            exerciseQuestions?.map((e) => e.toJson()).toList(),
      };
}
