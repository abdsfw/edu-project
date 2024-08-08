import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:educational_app/core/error/failures.dart';
import 'package:educational_app/core/utils/api_service.dart';

import '../model/data_model.dart';
import 'login_repo.dart';

class LoginRepoimpl extends LoginRepo {
  final ApiService apiService;

  LoginRepoimpl(this.apiService);
  @override
  Future<Either<Failure, Data>> postlogin(Map<String, dynamic> data) async {
    try {
      print(data);
      var respone = await apiService.post(
        endPoint: 'users/login',
        data: data,
        isLogin: true,
      );
      Data loginData = Data.fromJson(respone['data']);
      print('login repo impl success');
      return right(loginData);
    } catch (e) {
      if (e is DioException) {
        print('Dio Exception');
        return left(ServerFailure.fromDioError(e));
      }
      print('un expected error');
      // print(e.toString());
      return left(ServerFailure(e.toString(), 700));
    }
  }

  @override
  Future<Either<Failure, String>> postresgister(
      Map<String, dynamic> data) async {
    try {
      Map<String, dynamic> realData = {"gender": "male"};
      realData.addAll(data);
      var respone = await apiService.post(
        endPoint: 'users/register',
        data: realData, //data,
        isLogin: true,
      );
      return right("Ok");
    } catch (e) {
      print(e);

      if (e is DioException) {
        print('Dio Exception');
        return left(ServerFailure.fromDioError(e));
      }
      print('un expected error');
      // print(e.toString());
      return left(ServerFailure(e.toString(), 700));
    }
  }
}
