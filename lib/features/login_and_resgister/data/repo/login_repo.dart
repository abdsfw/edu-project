import 'package:dartz/dartz.dart';
import 'package:educational_app/core/error/failures.dart';

import '../model/data_model.dart';
import '../model/user_model.dart';

abstract class LoginRepo {
  Future<Either<Failure, Data>> postlogin(
      Map<String, dynamic> data);
  Future<Either<Failure, String>> postresgister(
      Map<String, dynamic> data);
}
