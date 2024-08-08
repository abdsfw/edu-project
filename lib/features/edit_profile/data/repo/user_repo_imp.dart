import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:educational_app/core/error/failures.dart';
import 'package:educational_app/core/utils/api_service.dart';
import 'package:educational_app/features/edit_profile/data/model/user_model.dart';
import 'package:educational_app/features/edit_profile/data/repo/user_repo.dart';

class UserRepoImp extends UserReop {
  final ApiService apiService;

  UserRepoImp(this.apiService);

  @override
  Future<Either<Failure, User>> getUserInfo() async {
    try {
      var response = await apiService.get(endPoint: "users/get");
      var data = response['data'];
      User user = User.fromJson(data);
      return right(user);
    } catch (e) {
      if (e is DioException) {
        print(' ########### Dio Exception #################');
        return left(ServerFailure.fromDioError(e));
      }

      print('un expected error');
      return left(ServerFailure(e.toString(), 500));
      print(e);
    }
  }

  @override
  Future<Either<Failure, String>> editUser(Map<String, dynamic> data) async {
    try {
      var response = await apiService.put(endPoint: "users/edit", data: data);
      
      return right("Ok");
    } catch (e) {
      if (e is DioException) {
        print(' ########### Dio Exception #################');
        return left(ServerFailure.fromDioError(e));
      }

      print('un expected error');
      return left(ServerFailure(e.toString(), 500));
      print(e);
    }
  }
}
