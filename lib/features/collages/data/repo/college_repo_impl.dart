import 'package:educational_app/core/error/failures.dart';
import 'package:educational_app/features/collages/data/models/college_model.dart';
import 'package:educational_app/features/collages/data/models/college_years_model.dart';
import 'package:educational_app/features/collages/data/models/level_model/level_model.dart';
import 'package:educational_app/features/collages/data/models/quiz_model/quiz_model.dart';
import 'package:educational_app/features/collages/data/repo/college_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/utils/api_service.dart';
import '../models/course_model.dart';
import '../models/time_line_model/time_line_model.dart';

class CollegeRepoImpl extends CollegeRepo {
  final ApiService apiService;

  CollegeRepoImpl(this.apiService);

  @override
  Future<Either<Failure, List<CollegeModel>>> getColleges() async {
    try {
      var response = await apiService.get(endPoint: 'users/collages/get-all');
      List<CollegeModel> colleges = [];
      for (var college in response['data']) {
        colleges.add(CollegeModel.fromJson(college));
      }
      print('fetch college successfully');
      return right(colleges);
    } catch (e) {
      if (e is DioException) {
        print(' ########### Dio Exception #################');
        return left(ServerFailure.fromDioError(e));
      }

      print('un expected error');
      return left(ServerFailure(e.toString(), 500));
    }
  }

  @override
  Future<Either<Failure, List<CourseModel>>> getCourses(
      {required int yearID}) async {
    try {
      var response =
          await apiService.get(endPoint: 'users/courses/get-all/$yearID');
      List<CourseModel> courses = [];
      for (var course in response['data']) {
        courses.add(CourseModel.fromJson(course));
      }
      print('fetch courses successfully');
      return right(courses);
    } catch (e) {
      if (e is DioException) {
        print(' ########### Dio Exception #################');
        return left(ServerFailure.fromDioError(e));
      }
      print('un expected error');
      return left(ServerFailure(e.toString(), 500));
    }
  }

  @override
  Future<Either<Failure, List<CollegeYearsModel>>> getCollegeYears(
      {required int collegeID}) async {
    try {
      var response = await apiService.get(
          endPoint: 'users/collages/year/get-all/$collegeID');
      List<CollegeYearsModel> years = [];
      for (var course in response['data']) {
        years.add(CollegeYearsModel.fromJson(course));
      }
      print('fetch years successfully');
      return right(years);
    } catch (e) {
      if (e is DioException) {
        print(' ########### Dio Exception #################');
        return left(ServerFailure.fromDioError(e));
      }
      print('un expected error');
      return left(ServerFailure(e.toString(), 500));
    }
  }

  @override
  Future<Either<Failure, TimeLineModel>> getCourseTimeLine(
      {required int courseID}) async {
    try {
      var response =
          await apiService.get(endPoint: 'users/timelines/get/$courseID');
      TimeLineModel timeLine = TimeLineModel();
      // print('adad');
      // for (var course in response['data']) {
      //   years.add(CollegeYearsModel.fromJson(course));
      // }
      // print(response['data']);
      timeLine = TimeLineModel.fromJson(response['data']);
      print('adad');

      print('fetch years successfully');
      return right(timeLine);
    } catch (e) {
      if (e is DioException) {
        print(' ########### Dio Exception #################');
        return left(ServerFailure.fromDioError(e));
      }
      print(e.toString());

      print('un expected error');
      return left(ServerFailure(e.toString(), 500));
    }
  }

  @override
  Future<Either<Failure, QuizModel>> getQuiz({required int quizID}) async {
    try {
      var response = await apiService.get(endPoint: 'users/quiz/get/$quizID');
      QuizModel quiz = QuizModel();
      // print('adad');
      // for (var course in response['data']) {
      //   years.add(CollegeYearsModel.fromJson(course));
      // }
      // print(response['data']);
      quiz = QuizModel.fromJson(response['data']);
      print('adad');

      print('fetch quiz successfully');
      return right(quiz);
    } catch (e) {
      if (e is DioException) {
        print(' ########### Dio Exception #################');
        return left(ServerFailure.fromDioError(e));
      }
      print(e.toString());

      print('un expected error');
      return left(ServerFailure(e.toString(), 500));
    }
  }

  @override
  Future<Either<Failure, dynamic>> postMarkQuiz(
      {required Map<String, int> mark}) async {
    try {
      var response = await apiService.post(
        endPoint: 'users/quiz-students/add',
        data: mark,
      );
      // var quiz;
      // if (response['data'] is String) {
      //   quiz = response['data'];
      // } else {
      //   quiz = response['data'];
      // }

      print('fetch quiz successfully');
      print(response['data']);
      return right(response['data']);
    } catch (e) {
      if (e is DioException) {
        print(' ########### Dio Exception #################');
        return left(ServerFailure.fromDioError(e));
      }
      print(e.toString());

      print('un expected error');
      return left(ServerFailure(e.toString(), 500));
    }
  }

  @override
  Future<Either<Failure, LevelModel>> getLevel({required int levelID}) async {
    try {
      var response =
          await apiService.get(endPoint: 'users/levels/get/$levelID');
      LevelModel level = LevelModel();

      level = LevelModel.fromJson(response['data']);
      print('adad');

      print('fetch level successfully');
      return right(level);
    } catch (e) {
      if (e is DioException) {
        print(' ########### Dio Exception #################');
        return left(ServerFailure.fromDioError(e));
      }
      print(e.toString());

      print('un expected error');
      return left(ServerFailure(e.toString(), 500));
    }
  }

  @override
  Future<Either<Failure, dynamic>> postOrderLecture(
      {required Map<String, List<int>> data}) async {
    try {
      var response = await apiService.post(
        endPoint: 'users/ordered-lectures/add-many',
        data: data,
      );

      print('post order successfully');
      print(response['data']);
      return right('success');
    } catch (e) {
      if (e is DioException) {
        print(' ########### Dio Exception #################');
        return left(ServerFailure.fromDioError(e));
      }
      print(e.toString());

      print('un expected error');
      return left(ServerFailure(e.toString(), 500));
    }
  }

  @override
  Future<Either<Failure, dynamic>> getHeader({required String url}) async {
    try {
      var response = await apiService.getHeader(url: url);

      print('head fetched successfully');
      print(response);
      return right(response);
    } catch (e) {
      if (e is DioException) {
        print(' ########### Dio Exception #################');
        return left(ServerFailure.fromDioError(e));
      }
      print(e.toString());

      print('un expected error');
      return left(ServerFailure(e.toString(), 500));
    }
  }
}
