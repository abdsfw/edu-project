class ExerciseAnswer {
  int? id;
  String? name;
  bool? isCorrect;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? exerciseQuestionId;

  ExerciseAnswer({
    this.id,
    this.name,
    this.isCorrect,
    this.createdAt,
    this.updatedAt,
    this.exerciseQuestionId,
  });

  factory ExerciseAnswer.fromJson(Map<String, dynamic> json) {
    return ExerciseAnswer(
      id: json['id'] as int?,
      name: json['name'] as String?,
      isCorrect: json['is_correct'] as bool?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      exerciseQuestionId: json['exercise_question_id'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'is_correct': isCorrect,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'exercise_question_id': exerciseQuestionId,
      };
}
