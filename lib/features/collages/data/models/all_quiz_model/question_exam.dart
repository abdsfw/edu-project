import 'answer.dart';

class QuestionExam {
  int? id;
  String? url;
  String? name;
  int? mark;
  String? urlType;
  String? type;
  // int? quizId;
  List<Answer>? answers;
  String? typeName;

  QuestionExam({
    this.id,
    this.url,
    this.name,
    this.mark,
    this.urlType,
    this.type,
    // this.quizId,
    this.answers,
    this.typeName,
  });

  factory QuestionExam.fromJson(Map<String, dynamic> json) => QuestionExam(
        id: json['id'] as int?,
        url: json['url'] as String?,
        name: json['name'] as String?,
        mark: json['mark'] as int?,
        urlType: json['url_type'] as String?,
        type: json['type'] as String?,
        // quizId: json['quiz_id'] as int?,
        answers: (json['answers'] as List<dynamic>?)
            ?.map((e) => Answer.fromJson(e as Map<String, dynamic>))
            .toList(),
        typeName: json['type_name'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'url': url,
        'name': name,
        'mark': mark,
        'url_type': urlType,
        'type': type,
        // 'quiz_id': quizId,
        'answers': answers?.map((e) => e.toJson()).toList(),
        'type_name': typeName,
      };
}
