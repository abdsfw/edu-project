class Quiz {
  int? id;
  String? name;
  // int? successMark;
  // int? fullMark;
  // String? model;
  // DateTime? createdAt;
  // DateTime? updatedAt;

  Quiz({
    this.id,
    this.name,
    // this.successMark,
    // this.fullMark,
    // this.model,
    // this.createdAt,
    // this.updatedAt,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) => Quiz(
        id: json['id'] as int?,
        name: json['name'] as String?,
        // successMark: json['success_mark'] as int?,
        // fullMark: json['full_mark'] as int?,
        // model: json['model'] as String?,
        // createdAt: json['createdAt'] == null
        //     ? null
        //     : DateTime.parse(json['createdAt'] as String),
        // updatedAt: json['updatedAt'] == null
        //     ? null
        //     : DateTime.parse(json['updatedAt'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        // 'success_mark': successMark,
        // 'full_mark': fullMark,
        // 'model': model,
        // 'createdAt': createdAt?.toIso8601String(),
        // 'updatedAt': updatedAt?.toIso8601String(),
      };
}
