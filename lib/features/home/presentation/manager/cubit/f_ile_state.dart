part of 'f_ile_cubit.dart';

@immutable
sealed class FIleState {}

final class FIleInitial extends FIleState {}

class AppCreateDatabaseState extends FIleState {}

class AppGetDatabaseLoadingState extends FIleState {}

class AppSuccessGetDatabaseState extends FIleState {}

class AppFailureGetDatabaseState extends FIleState {}

// ----------------------------------------------------
class LoadingFetchExternalCoursesState extends FIleState {}

class FailureFetchExternalCoursesState extends FIleState {
  final String errMessage;
  final int statusCode;
  FailureFetchExternalCoursesState(this.errMessage, this.statusCode);
}

class SuccessFetchExternalCoursesState extends FIleState {}

class SearchFetchExternalCoursesState extends FIleState {}

// --------------------------------------------------
class LoadingPostCodeState extends FIleState {}

class FailurePostCodeState extends FIleState {
  final String errMessage;
  final int statusCode;
  FailurePostCodeState(this.errMessage, this.statusCode);
}

class SuccessPostCodeState extends FIleState {}
// -------------------------------------------------