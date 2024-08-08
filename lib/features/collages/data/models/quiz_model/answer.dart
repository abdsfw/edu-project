class Answer {
  int? id;
  String? name;
  bool? isCorrect;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? questionId;

  Answer({
    this.id,
    this.name,
    this.isCorrect,
    this.createdAt,
    this.updatedAt,
    this.questionId,
  });

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
        id: json['id'] as int?,
        name: json['name'] as String?,
        isCorrect: json['is_correct'] as bool?,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt'] as String),
        questionId: json['question_id'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'is_correct': isCorrect,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'question_id': questionId,
      };
}
