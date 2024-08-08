import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:educational_app/core/error/failures.dart';
import 'package:educational_app/core/utils/api_service.dart';
import 'package:educational_app/features/collages/presentation/views/data/course_model.dart';
import 'package:educational_app/features/home/data/repo/home_repo.dart';

class HomeRepoImpl extends HomeRepo {
  final ApiService apiService;

  HomeRepoImpl(this.apiService);

  @override
  Future<Either<Failure, List<Course>>> getExternalCourse() async {
    try {
      var response = await apiService.get(endPoint: 'users/courses/get-all');
      List<Course> course = [];
      for (var college in response['data']) {
        course.add(Course.fromJson(college));
      }
      print('fetch college successfully');
      return right(course);
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
  Future<Either<Failure, String>> postCode(
      {required Map<String, dynamic> data}) async {
    try {
      var response = await apiService.put(
        endPoint: 'users/codes/edit',
        data: data,
      );

      print('post code successfully');
      return right('success');
    } catch (e) {
      if (e is DioException) {
        print(' ########### Dio Exception #################');
        return left(ServerFailure.fromDioError(e));
      }

      print('un expected error');
      return left(ServerFailure(e.toString(), 500));
    }
  }
}
