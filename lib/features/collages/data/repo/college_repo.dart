import 'package:educational_app/core/error/failures.dart';
import 'package:dartz/dartz.dart';

import '../models/college_model.dart';
import '../models/college_years_model.dart';
import '../models/course_model.dart';
import '../models/level_model/level_model.dart';
import '../models/quiz_model/quiz_model.dart';
import '../models/time_line_model/time_line_model.dart';

abstract class CollegeRepo {
  Future<Either<Failure, List<CollegeModel>>> getColleges();
  Future<Either<Failure, List<CourseModel>>> getCourses({required int yearID});
  Future<Either<Failure, List<CollegeYearsModel>>> getCollegeYears(
      {required int collegeID});
  Future<Either<Failure, TimeLineModel>> getCourseTimeLine(
      {required int courseID});
  Future<Either<Failure, QuizModel>> getQuiz({required int quizID});
  Future<Either<Failure, dynamic>> postMarkQuiz(
      {required Map<String, int> mark});
  Future<Either<Failure, LevelModel>> getLevel({required int levelID});
  Future<Either<Failure, dynamic>> postOrderLecture(
      {required Map<String, List<int>> data});
  Future<Either<Failure, dynamic>> getHeader({required String url});
}
