class Answer {
  int? id;
  String? name;
  bool? isCorrect;

  Answer({this.id, this.name, this.isCorrect});

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
        id: json['id'] as int?,
        name: json['name'] as String?,
        isCorrect: json['is_correct'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'is_correct': isCorrect,
      };
}
