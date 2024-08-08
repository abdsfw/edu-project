class Course {
  int? id;
  String? name;

  int? collageYearId;
  int? managerId;

  Course({
    this.id,
    this.name,
    this.collageYearId,
    this.managerId,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as int?,
      name: json['name'] as String?,
      collageYearId: json['collage_year_id'] as int?,
      managerId: json['manager_id'] as int?,
    );
  }
}

class CourseList {
  final List<Course> data;

  CourseList({required this.data});

  factory CourseList.fromJson(List<dynamic> json) {
    List<Course> courses = [];
    courses = json.map((course) => Course.fromJson(course)).toList();

    return CourseList(data: courses);
  }
}
