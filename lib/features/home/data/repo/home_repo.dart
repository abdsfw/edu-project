import 'package:dartz/dartz.dart';
import 'package:educational_app/core/error/failures.dart';

import '../../../collages/presentation/views/data/course_model.dart';

abstract class HomeRepo {
  Future<Either<Failure, List<Course>>> getExternalCourse();
  Future<Either<Failure, String>> postCode({
    required Map<String, dynamic> data,
  });
}
