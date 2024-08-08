import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../collages/presentation/views/data/course_model.dart';
import '../../../data/repo/home_repo.dart';
part 'f_ile_state.dart';

class FIleCubit extends Cubit<FIleState> {
  FIleCubit(this.homeRepo) : super(FIleInitial());
  final HomeRepo homeRepo;
  static FIleCubit get(context) => BlocProvider.of(context);

  // -------------------------------------
  late Database database;
  // List<FIleModel> allFIles = [];
  List<Course> course = [];
  List<Course> currentCourse = [];
  // -------------------------------------
  // -------------------------------------

  // -------------------------------------
  void createDataBase() {
    openDatabase(
      'file.db',
      version: 1,
      onCreate: (db, version) async {
        print('Database FIle Created');
        await db
            .execute(
          'CREATE TABLE file (id INTEGER, isDownload BOOLEAN DEFAULT false , courseName TEXT, path TEXT , type TEXT)',
        )
            .then((value) {
          print('table file created');
        }).catchError((error) {
          print('error when creating table ${error.toString()}');
        });
      },
      onOpen: (db) {
        // here we should call get method from locall database
        // getDataFromDatabase(db);
        print('database opened');
        // print(CasheHelper.getData(key: Constants.ktoken));
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  Future<void> insertToDatabase(
      int id, String courseName, String path, String type) async {
    await database.transaction((txn) async {
      txn
          .rawInsert(
        'INSERT INTO file (id,  courseName, path,type) VALUES ("$id" , "$courseName" , "$path"  , "$type")',
      )
          .then((value) async {
        print('$value insert successfully');
        // emit(AppinseartDatabaseState());
        // here we should call method for get data from database
        // getDataFromDatabase();
      }).catchError((error) {
        print('error when inserting new record $error');
      });
    });
  }

  Future<void> deleteFile(int id) async {
    await database.delete(
      'file',
      where: 'id = ?',
      whereArgs: [id],
    ).then((value) {
      print('delete file successfully $value');
    });
  }

  Future<void> updateFileDetails(int id, bool isDownload) async {
    database.rawUpdate(
        'UPDATE file SET isDownload = ? WHERE id = ? ', [isDownload, id]).then(
      (value) async {
        // here we should call method get data base
        print('update student info success $value');
        // await getStudentFromDatabase(database2, id.toString());
      },
    );
  }

  Future<void> getDataFromDatabase() async {
    // here we should make our array or anouther
    // data type empty to assigned new data from database
    // activeCategory = [];
    emit(AppGetDatabaseLoadingState());
    await database.rawQuery('SELECT * FROM file').then((value) {
      // here we can fellter the result and assign to our dataType

      // print('-----------------------------------------------------------');
      // print('                                                            ');

      // print(value);

      // print('                                                            ');
      // print('-----------------------------------------------------------');

      // value.forEach(
      //   (element) {
      //     // print(element);
      //     // print(
      //     //     '---------------------------------------------------------------');
      //     activeCategory.add(CategoryModel.fromJson(element));
      //   },
      // );
      emit(AppSuccessGetDatabaseState());
    }).catchError(
      (Error) {
        print('there is an error in get method $Error');
        emit(AppFailureGetDatabaseState());
      },
    );
  }

  Future<void> fetchExternalCourse() async {
    emit(LoadingFetchExternalCoursesState());
    var result = await homeRepo.getExternalCourse();
    result.fold((failure) {
      emit(FailureFetchExternalCoursesState(
          failure.errMassage, failure.statusCode));
    }, (courses) {
      course = courses;
      currentCourse = course;
      emit(SuccessFetchExternalCoursesState());
    });
  }

  Future<void> postCode({required Map<String, dynamic> data}) async {
    emit(LoadingPostCodeState());
    var result = await homeRepo.postCode(data: data);
    result.fold((failure) {
      emit(FailurePostCodeState(failure.errMassage, failure.statusCode));
    }, (success) {
      emit(SuccessPostCodeState());
    });
  }

  void courseSearch(
    String text,
  ) {
    List<Course> result = course
        .where(
          (element) => element.name!.toLowerCase().contains(
                text.toLowerCase(),
              ),
        )
        .toList();

    currentCourse = result;
    emit(SearchFetchExternalCoursesState());
  }

  // Future<void> getStudentFromDatabase(String studentId) async {
  //   // here we should make our array or anouther
  //   // data type empty to assigned new data from database
  //   int id = int.parse(studentId);
  //   emit(LoadingSaleFetchStudentState());
  //   await database
  //       .rawQuery('SELECT * FROM students WHERE id = $id')
  //       .then((value) {
  //     // here we can fellter the result and assign to our dataType
  //     print('-----------------------------------------------------------');
  //     print('                                                            ');
  //     student = StudentModel(balance: 0.0, threshold: 0.0);
  //     studentOffline = StudentModels.fromJson(value[0]);
  //     print(studentOffline.balance);
  //     print(value[0]);
  //     print('                                                            ');
  //     print('-----------------------------------------------------------');
  //     emit(SuccessSaleFetchStudent());
  //   }).catchError(
  //     (Error) {
  //       print('there is an error in get method $Error');
  //       emit(FailureSaleFetchStudentState('error'));
  //     },
  //   );
  // }

  // Future<void> deleteDatabase() async {
  //   database.rawDelete('DELETE FROM file').then((value) {
  //     print('delete successfuly : $value');
  //     // here should call method get data base
  //   }).catchError((Error) {
  //     print('there is an error $Error');
  //   });
  // }
  // -------------------------------------
}
