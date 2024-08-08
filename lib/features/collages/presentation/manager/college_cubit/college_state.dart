part of 'college_cubit.dart';

@immutable
abstract class CollegeState {}

class CollegeInitial extends CollegeState {}

// ----------------- get colleges states -------------------
class LoadingFetchCollegesState extends CollegeState {}

class FailureFetchCollegesState extends CollegeState {
  final String errMessage;
  final int statusCode;

  FailureFetchCollegesState(this.errMessage, this.statusCode);
}

class SuccessFetchCollegesState extends CollegeState {}

// ---------------------------------------------------------

// ----------------- get Courses states --------------------
class LoadingFetchCoursesState extends CollegeState {}

class FailureFetchCoursesState extends CollegeState {
  final String errMessage;
  final int statusCode;

  FailureFetchCoursesState(this.errMessage, this.statusCode);
}

class SuccessFetchCoursesState extends CollegeState {}
// ---------------------------------------------------------

// ----------------- get Years states --------------------
class LoadingFetchYearsState extends CollegeState {}

class FailureFetchYearsState extends CollegeState {
  final String errMessage;
  final int statusCode;

  FailureFetchYearsState(this.errMessage, this.statusCode);
}

class SuccessFetchYearsState extends CollegeState {}

// ---------------------------------------------------------
// ----------------- get Years states --------------------
class LoadingFetchCourseTimeLineState extends CollegeState {}

class FailureFetchCourseTimeLineState extends CollegeState {
  final String errMessage;
  final int statusCode;

  FailureFetchCourseTimeLineState(this.errMessage, this.statusCode);
}

class SuccessFetchCourseTimeLineState extends CollegeState {}

// ---------------------------------------------------------

// ----------------- get Quiz states --------------------
class LoadingFetchQuizState extends CollegeState {}

class FailureFetchQuizState extends CollegeState {
  final String errMessage;
  final int statusCode;

  FailureFetchQuizState(this.errMessage, this.statusCode);
}

class SuccessFetchQuizState extends CollegeState {}

// ---------------------------------------------------------
// ----------------- add mark states --------------------
class LoadingAddMarkState extends CollegeState {}

class FailureAddMarkState extends CollegeState {
  final String errMessage;
  final int statusCode;

  FailureAddMarkState(this.errMessage, this.statusCode);
}

class SuccessAddMarkState extends CollegeState {
  final int examMark;

  SuccessAddMarkState(this.examMark);
}

// ---------------------------------------------------------
// ----------------- get level states --------------------
class LoadingGetLevelState extends CollegeState {}

class FailureGetLevelState extends CollegeState {
  final String errMessage;
  final int statusCode;

  FailureGetLevelState(this.errMessage, this.statusCode);
}

class SuccessGetLevelState extends CollegeState {}

// ---------------------------------------------------------
// ----------------- post order lecture states --------------------
class LoadingPostOrderLectureState extends CollegeState {}

class FailurePostOrderLectureState extends CollegeState {
  final String errMessage;
  final int statusCode;

  FailurePostOrderLectureState(this.errMessage, this.statusCode);
}

class SuccessPostOrderLectureState extends CollegeState {}
// ---------------------------------------------------------

// ----------------- get lecture states --------------------
class LoadingGetPdfState extends CollegeState {}

class FailureGetPdfState extends CollegeState {
  final String errMessage;
  final int statusCode;

  FailureGetPdfState(this.errMessage, this.statusCode);
}

class SuccessGetPdfState extends CollegeState {}
// ---------------------------------------------------------

// -------------------- sqflite ----------------------------

class AppCreateDatabaseState extends CollegeState {}

class LoadingDeleteRowFromDatabaseState extends CollegeState {}

class FailureDeleteRowFromDatabaseState extends CollegeState {
  final String errMessage;

  FailureDeleteRowFromDatabaseState(this.errMessage);
}

class SuccessDeleteRowFromDatabaseState extends CollegeState {}

class AppGetDatabaseLoadingState extends CollegeState {}

class AppSuccessGetDatabaseState extends CollegeState {}

class AppFailureGetDatabaseState extends CollegeState {
  final String errMessage;

  AppFailureGetDatabaseState(this.errMessage);
}

class AppSuccessInsertDatabaseState extends CollegeState {}

//----------------------------------------------------------

// --------------------- get size --------------------------
class LoadingFetchSizeFile extends CollegeState {}

class FailureFetchSizeFile extends CollegeState {
  final String errMessage;

  FailureFetchSizeFile(this.errMessage);
}

class SuccessFetchSizeFile extends CollegeState {}

// ---------------------------------------------------------

// --------------------- get size --------------------------
class LoadingDownloadFile extends CollegeState {}

class FailureDownloadFile extends CollegeState {
  final String errMessage;

  FailureDownloadFile(this.errMessage);
}

class SuccessDownloadFile extends CollegeState {}

// ---------------------------------------------------------

class FileIsExistState extends CollegeState {}

class FileIsExistStatePdf extends CollegeState {}

class LoadingDecryptFile extends CollegeState {}

class SuccessDecryptFile extends CollegeState {}

class AlertDecryptFile extends CollegeState {}

class FailureDecryptFile extends CollegeState {
  final String errMessage;

  FailureDecryptFile(this.errMessage);
}

class FailureDecryptFilePdf extends CollegeState {
  final String errMessage;

  FailureDecryptFilePdf(this.errMessage);
}
