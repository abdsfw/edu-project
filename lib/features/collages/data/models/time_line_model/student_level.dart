class StudentLevel {
  dynamic order;

  StudentLevel({this.order});

  factory StudentLevel.fromJson(Map<String, dynamic> json) => StudentLevel(
        order: json['order'],
      );

  Map<String, dynamic> toJson() => {
        'order': order,
      };
}
