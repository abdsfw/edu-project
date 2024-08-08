import 'student_level.dart';
import 'timeline.dart';

class TimeLineModel {
  List<Timeline>? timeline;
  StudentLevel? studentLevel;

  TimeLineModel({this.timeline, this.studentLevel});

  factory TimeLineModel.fromJson(Map<String, dynamic> json) => TimeLineModel(
        timeline: (json['timeline'] as List<dynamic>?)
            ?.map((e) => Timeline.fromJson(e as Map<String, dynamic>))
            .toList(),
        studentLevel: json['student_level'] == null
            ? null
            : StudentLevel.fromJson(
                json['student_level'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'timeline': timeline?.map((e) => e.toJson()).toList(),
        'student_level': studentLevel?.toJson(),
      };
}
