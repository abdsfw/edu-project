import 'question_exam.dart';

class AllQuizModel {
  String? name;
  int? successMark;
  int? fullMark;
  int? courseId;
  List<QuestionExam>? questions;

  AllQuizModel({
    this.name,
    this.successMark,
    this.fullMark,
    this.courseId,
    this.questions,
  });

  factory AllQuizModel.fromJson(Map<String, dynamic> json) => AllQuizModel(
        name: json['name'] as String?,
        successMark: json['success_mark'] as int?,
        fullMark: json['full_mark'] as int?,
        courseId: json['course_id'] as int?,
        questions: (json['questions'] as List<dynamic>?)
            ?.map((e) => QuestionExam.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'success_mark': successMark,
        'full_mark': fullMark,
        'course_id': courseId,
        'questions': questions?.map((e) => e.toJson()).toList(),
      };
}
