import 'package:dio/dio.dart';
import 'package:educational_app/features/edit_profile/data/repo/user_repo.dart';
import 'package:educational_app/features/edit_profile/data/repo/user_repo_imp.dart';
import 'package:educational_app/features/login_and_resgister/data/repo/login_repo_impl.dart';
import 'package:get_it/get_it.dart';
import '../../features/collages/data/repo/college_repo_impl.dart';
import '../../features/home/data/repo/home_repo_impl.dart';
import 'api_service.dart';

final getIt = GetIt.instance;
void setupServiceLocator() {
  getIt.registerSingleton<ApiService>(
    ApiService(
      Dio(),
    ),
  );

  getIt.registerSingleton<CollegeRepoImpl>(
    CollegeRepoImpl(getIt.get<ApiService>()),
  );
  getIt.registerSingleton<HomeRepoImpl>(
    HomeRepoImpl(getIt.get<ApiService>()),
  );
  getIt.registerSingleton<LoginRepoimpl>(
    LoginRepoimpl(getIt.get<ApiService>()),
  );
  getIt.registerSingleton<UserRepoImp>(
    UserRepoImp(getIt.get<ApiService>()),
  );
}
