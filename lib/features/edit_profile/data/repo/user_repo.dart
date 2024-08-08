import 'package:dartz/dartz.dart';
import 'package:educational_app/core/error/failures.dart';
import 'package:educational_app/features/edit_profile/data/model/user_model.dart';

abstract class UserReop {
  Future<Either<Failure, User>> getUserInfo(); 
  Future<Either<Failure, void>> editUser(Map<String, dynamic> data); 
}
