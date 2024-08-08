import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:educational_app/core/error/failures.dart';
import 'package:educational_app/features/collages/data/models/level_model/level_model.dart';
import 'package:educational_app/features/collages/data/models/time_line_model/level.dart';
import 'package:educational_app/features/collages/data/models/time_line_model/time_line_model.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import '../../../../../constants.dart';
import '../../../../../core/cache/cashe_helper.dart';
import '../../../../../core/utils/encrypt.dart';
import '../../../../../core/utils/service_locator.dart';
import '../../../data/models/file_model.dart';
import '../../../data/models/all_quiz_model/all_quiz_model.dart';
import '../../../data/models/all_quiz_model/answer.dart';
import '../../../data/models/all_quiz_model/question_exam.dart';
import '../../../data/models/college_model.dart';
import '../../../data/models/college_years_model.dart';
import '../../../data/models/course_model.dart';
import '../../../data/models/level_model/video.dart';
import '../../../data/models/quiz_model/quiz_model.dart';
import '../../../data/models/size_model.dart';
import '../../../data/repo/college_repo.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as encrypt;

part 'college_state.dart';

class CollegeCubit extends Cubit<CollegeState> {
  CollegeCubit(this.collegeRepo) : super(CollegeInitial());
  final CollegeRepo collegeRepo;
  static CollegeCubit get(context) => BlocProvider.of(context);

  // ---------------------- variable ---------------------------
  int currentQuestionIndex = 1;
  List<CollegeModel> colleges = [];
  List<CourseModel> courses = [];
  List<CollegeYearsModel> collegeYears = [];
  TimeLineModel timeLine = TimeLineModel();
  QuizModel quiz = QuizModel();
  AllQuizModel allExam = AllQuizModel(
    questions: [],
  );
  List<int> answerChosen = [];
  dynamic resultOfMark;
  LevelModel level = LevelModel();
  List<bool> selectedList = [];
  List<bool> selectedListToReset = [];
  bool isSelectMode = false;
  String pdfUrl = '';
  late Database database;
  List<FileModel> pdfFile = [];
  List<FileModel> videoFile = [];
  List<String> videoSize = [];
  List<SizeModel> levelSize = [];
  List<SizeModel> pdfSize = [];
  List<bool> videoIsDownloaded = [];
  List<int> videoDownloadBytes = [];
  List<int> maxVideoDownloadBytes = [];
  List<bool> pdfIsDownloaded = [];
  List<int> pdfDownloadBytes = [];
  List<int> maxPdfDownloadBytes = [];
  // -----
  List<bool> pdfIsDownloadedQuz = [];
  List<int> pdfDownloadBytesQuz = [];
  List<int> maxPdfDownloadBytesQuz = [];

  Dio dio = Dio();
  DefaultCacheManager cacheManager = DefaultCacheManager();

// -----------------------------------------------------------
  Future<void> fetchAllColleges() async {
    emit(LoadingFetchCollegesState());
    var result = await collegeRepo.getColleges();
    result.fold((failure) {
      emit(FailureFetchCollegesState(failure.errMassage, failure.statusCode));
    }, (colleges) {
      this.colleges = colleges;
      emit(SuccessFetchCollegesState());
    });
  }

  Future<void> fetchAllCourses({required int yearID}) async {
    emit(LoadingFetchCoursesState());
    var result = await collegeRepo.getCourses(yearID: yearID);
    result.fold((failure) {
      emit(FailureFetchCoursesState(failure.errMassage, failure.statusCode));
    }, (courses) {
      this.courses = courses;
      emit(SuccessFetchCoursesState());
    });
  }

  Future<void> fetchYears({required int collegeID}) async {
    emit(LoadingFetchYearsState());
    var result = await collegeRepo.getCollegeYears(collegeID: collegeID);
    result.fold((failure) {
      emit(FailureFetchYearsState(failure.errMassage, failure.statusCode));
    }, (collegeYears) {
      this.collegeYears = collegeYears;
      emit(SuccessFetchYearsState());
    });
  }

  Future<void> fetchCourseTimeLine({required int courseID}) async {
    emit(LoadingFetchCourseTimeLineState());
    var result = await collegeRepo.getCourseTimeLine(courseID: courseID);
    result.fold((failure) {
      emit(FailureFetchCourseTimeLineState(
          failure.errMassage, failure.statusCode));
    }, (timeLine) {
      this.timeLine = timeLine;
      emit(SuccessFetchCourseTimeLineState());
    });
  }

  Future<void> fetchQuiz({required int quizID}) async {
    emit(LoadingFetchQuizState());
    var result = await collegeRepo.getQuiz(quizID: quizID);
    result.fold((failure) {
      emit(FailureFetchQuizState(failure.errMassage, failure.statusCode));
    }, (quizData) {
      quiz = quizData;
      allExam.name = quizData.name;
      allExam.courseId = quizData.courseId;
      allExam.fullMark = quizData.fullMark;
      allExam.successMark = quizData.successMark;
      for (var que in quizData.questions!) {
        if (que.type == 'question') {
          List<Answer> answers = [];
          for (var answer in que.answers!) {
            answers.add(Answer(
                id: answer.id, isCorrect: answer.isCorrect, name: answer.name));
          }
          allExam.questions!.add(
            QuestionExam(
              id: que.id,
              url: que.url,
              answers: answers,
              mark: que.mark,
              name: null,
              type: que.type,
              urlType: que.urlType,
              typeName: null,
            ),
          );
        } else if (que.type == 'exercise') {
          for (var exe in que.exerciseQuestions!) {
            List<Answer> answers = [];

            for (var answer2 in exe.exerciseAnswers!) {
              answers.add(
                Answer(
                  id: answer2.id,
                  isCorrect: answer2.isCorrect,
                  name: answer2.name,
                ),
              );
            }
            allExam.questions!.add(
              QuestionExam(
                id: que.id,
                url: que.url,
                answers: answers,
                mark: exe.mark,
                name: exe.url,
                type: que.type,
                urlType: que.urlType,
                typeName: exe.urlType,
              ),
            );
          }
        }
      }
      pdfIsDownloadedQuz = [];
      pdfDownloadBytesQuz = [];
      maxPdfDownloadBytesQuz = [];
      for (int i = 0; i < allExam.questions!.length; i++) {
        pdfIsDownloadedQuz.add(false);
        pdfDownloadBytesQuz.add(0);
        maxPdfDownloadBytesQuz.add(0);
        print(maxPdfDownloadBytesQuz.length);
        answerChosen.add(-1);
      }
      print('all Exam length :${allExam.questions!.length}');
      print('answerChosen length :${answerChosen.length}');
      emit(SuccessFetchQuizState());
    });
  }

  Future<void> postMarkQuiz({required Map<String, int> mark}) async {
    emit(LoadingAddMarkState());
    var result = await collegeRepo.postMarkQuiz(mark: mark);
    result.fold((failure) {
      emit(FailureAddMarkState(failure.errMassage, failure.statusCode));
    }, (resultOfMark) {
      print('status code 200');
      this.resultOfMark = resultOfMark;
      print(resultOfMark);
      emit(SuccessAddMarkState(mark['mark']!));
    });
  }

  Future<void> fetchLevel({required int levelID}) async {
    emit(LoadingGetLevelState());
    var result = await collegeRepo.getLevel(levelID: levelID);
    result.fold((failure) {
      emit(FailureGetLevelState(failure.errMassage, failure.statusCode));
    }, (level) {
      this.level = level;
      // for (var pdf in level.pdfs!) {
      //   selectedList.add(false);
      //   selectedListToReset.add(false);
      // }
      if (level.pdfs!.length != pdfIsDownloaded.length) {
        print('y');
        pdfIsDownloaded = [];
        pdfDownloadBytes = [];
        maxPdfDownloadBytes = [];
        for (var pdf in level.pdfs!) {
          pdfIsDownloaded.add(false);
          pdfDownloadBytes.add(0);
          maxPdfDownloadBytes.add(0);
        }
      } else {
        print(44);
      }

      emit(SuccessGetLevelState());
    });
  }

  Future<void> postOrderLecture({required Map<String, List<int>> data}) async {
    emit(LoadingPostOrderLectureState());
    var result = await collegeRepo.postOrderLecture(data: data);
    result.fold((failure) {
      emit(
          FailurePostOrderLectureState(failure.errMassage, failure.statusCode));
    }, (resultOfMark) {
      isSelectMode = false;
      selectedList = selectedListToReset;
      emit(SuccessPostOrderLectureState());
    });
  }

  Future<void> createFileOfPdfUrl(String pdfUrl) async {
    // Completer<File> completer = Completer();
    // print("Start download file from internet!");
    try {
      emit(LoadingGetPdfState());
      // "https://berlin2017.droidcon.cod.newthinking.net/sites/global.droidcon.cod.newthinking.net/files/media/documents/Flutter%20-%2060FPS%20UI%20of%20the%20future%20%20-%20DroidconDE%2017.pdf";
      // final url = "https://pdfkit.org/docs/guide.pdf";
      // final url = "http://www.pdf995.com/samples/pdf.pdf";
      // final filename = url.substring(url.lastIndexOf("/") + 1);
      // var request = await HttpClient().getUrl(Uri.parse(url));
      // var response = await request.close();
      // var bytes = await consolidateHttpClientResponseBytes(response);
      var response = await http.get(Uri.parse(pdfUrl));
      // var dir = await getApplicationDocumentsDirectory();
      var dir = await getTemporaryDirectory();
      print("Download files");
      // print("${dir.path}/$filename");

      File file = File("${dir.path}/data.pdf");
      await file.writeAsBytes(response.bodyBytes, flush: true);
      pdfUrl = file.path;
      emit(SuccessGetPdfState());
    } catch (e) {
      emit(FailureGetPdfState(e.toString(), 500));
      throw Exception('Error parsing asset file!');
    }
  }

  Future<void> fetchSizeOfFIle(int courseID, List<Video>? video) async {
    List<Video> videoList = video ?? [];
    print('length :${videoList.length}');
    emit(LoadingFetchSizeFile());
    bool isError = false;
    videoSize = [];
    videoIsDownloaded = [];

    for (int i = 0; i < videoList.length; i++) {
      String shareUrl = Encryption.decrypt(videoList[i].url!);
      String url = convertDriveLink(shareUrl);
      var result = await collegeRepo.getHeader(url: url);
      result.fold(
        (failure) {
          emit(FailureFetchSizeFile(failure.errMassage));
          isError = true;
          return;
        },
        (head) async {
          // insertToDatabase(vd.id!, vd., path, type, size, courseID, levelID)

          double? size = double.tryParse(head['content-length']?.first);
          double realSize = 0;
          if (size != null) {
            realSize = size / 1048576;
          }
          videoSize.add(realSize.toStringAsFixed(1));
          videoIsDownloaded.add(false);
          print('length:  $realSize');

          // await insertToSizeTable(
          //   fileID: videoList[i].id!,
          //   size: realSize.toStringAsFixed(1),
          //   type: 'video',
          //   courseID: courseID,
          //   levelID: videoList[i].levelId!,
          // ).then((value) {
          //   if (i == (videoList.length - 1)) {
          //     emit(SuccessFetchSizeFile());
          //   }
          // });

          print('inseeeeeeeeeeeeeeeeeeeeeeeert ${videoList[i].id}');
          // emit(SuccessFetchSizeFile());
        },
      );
    }
    if (videoList.length == 0) {
      emit(SuccessFetchSizeFile());
    }
    print('hasErrorrrr $isError');
  }

// ! ---------------------------------------------------

  void createDataBase() {
    openDatabase(
      'file.db',
      version: 1,
      onCreate: (db, version) async {
        print('Database FIle Created');

        await db
            .execute(
          'CREATE TABLE file (id INTEGER , fileName Text, storageName TEXT ,path TEXT , type TEXT , size TEXT , courseID INTEGER , levelID INTEGER )',
        )
            .then((value) {
          print('table file created');
        }).catchError((error) {
          print('error when creating table ${error.toString()}');
        });

        // await db
        //     .execute(
        //   'CREATE TABLE size (fileID INTEGER, size TEXT ,  type TEXT ,  courseID INTEGER , levelID INTEGER , isDownload BOOLEAN DEFAULT false )',
        // )
        //     .then((value) {
        //   print('table size created');
        // }).catchError((error) {
        //   print('error when creating table ${error.toString()}');
        // });
      },
      onOpen: (db) async {
        // here we should call get method from locall database
        // getDataFromDatabase(db);
        print('database opened');

        // print(CasheHelper.getData(key: Constants.ktoken));
      },
    ).then((value) async {
      database = value;

      emit(AppCreateDatabaseState());
    });
  }

/*
  Future<void> deleteDatabase(String tableNAme) async {
    database.rawDelete('DELETE FROM $tableNAme').then((value) {
      print('delete successfuly : $value');
      // here should call method get data base
    }).catchError((Error) {
      print('there is an error $Error');
    });
  }
*/
  Future<void> insertToFIleTable({
    required int id,
    // String pdfName = '',
    // required String courseName,
    required String fileName,
    required String storageName,
    required String path,
    required String type,
    required String size,
    required int courseID,
    required int levelID,
  }) async {
    await database.transaction((txn) async {
      txn
          .rawInsert(
        'INSERT INTO file (id, fileName, storageName ,path , type , size , courseID , levelID ) VALUES ("$id" , "$fileName" ,"$storageName"  , "$path"  , "$type" , "$size" , "$courseID" , "$levelID")',
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

  Future<void> deleteFileFromFileTable({
    required int id,
    required String type,
    required String storageName,
  }) async {
    emit(LoadingDeleteRowFromDatabaseState());
    database.rawDelete(
        'DELETE FROM file WHERE id = ? AND type = ? AND storageName = ?',
        [id, type, storageName]).then((value) {
      print('Delete successful. Rows affected: $value');
      // Here you can call methods to get data or perform other actions
      getDataFromFileTable();
      emit(SuccessDeleteRowFromDatabaseState());
    }).catchError((error) {
      emit(FailureDeleteRowFromDatabaseState(error));
      print('Error during deletion: $error');
    });
  }

  // Future<void> updateFileDetails(int id, bool isDownload) async {
  //   database.rawUpdate(
  //       'UPDATE file SET isDownload = ? WHERE id = ? ', [isDownload, id]).then(
  //     (value) async {
  //       // here we should call method get data base
  //       print('update student info success $value');
  //       // await getStudentFromDatabase(database2, id.toString());
  //     },
  //   );
  // }

  Future<void> getDataFromFileTable() async {
    // here we should make our array or anouther
    // data type empty to assigned new data from database
    // activeCategory = [];
    emit(AppGetDatabaseLoadingState());
    await database.rawQuery('SELECT * FROM file').then((value) {
      // here we can fellter the result and assign to our dataType

      print('-----------------------------------------------------------');
      // print('                                                            ');

      print(value);

      // print('                                                            ');
      print('-----------------------------------------------------------');
      pdfFile = [];
      videoFile = [];
      for (var element in value) {
        File file = File(element["path"].toString());
        if (file.existsSync()) {
          if (element["type"] == "pdf") {
            pdfFile.add(FileModel.fromJson(element));
          } else {
            videoFile.add(FileModel.fromJson(element));
          }
        }
      }
// ! ----------------------------- here we should edit
      // value.forEach((element) {
      //   allFIles.add(FIleModel.fromJson(element));
      // });
      emit(AppSuccessGetDatabaseState());
    }).catchError(
      (error) {
        print('there is an error in get method $error');
        emit(AppFailureGetDatabaseState(error));
      },
    );
  }

  Future<void> getDataFromFileTableByCourseID(int courseID) async {
    // here we should make our array or anouther
    // data type empty to assigned new data from database
    // activeCategory = [];
    emit(AppGetDatabaseLoadingState());
    await database.rawQuery(
        'SELECT * FROM file WHERE courseID = ?', [courseID]).then((value) {
      // here we can fellter the result and assign to our dataType

      print('-----------------------------------------------------------');
      // print('                                                            ');

      print(value);

      // print('                                                            ');
      print('-----------------------------------------------------------');
      pdfFile = [];
      videoFile = [];
      for (var element in value) {
        File file = File(element["path"].toString());
        if (file.existsSync()) {
          if (element["type"] == "pdf") {
            pdfFile.add(FileModel.fromJson(element));
          } else {
            videoFile.add(FileModel.fromJson(element));
          }
        }
      }
// ! ----------------------------- here we should edit
      // value.forEach((element) {
      //   allFIles.add(FIleModel.fromJson(element));
      // });
      emit(AppSuccessGetDatabaseState());
    }).catchError(
      (error) {
        print('there is an error in get method $error');
        emit(AppFailureGetDatabaseState(error));
      },
    );
  }

/*
  Future<void> insertToSizeTable({
    required int fileID,
    required String size,
    required String type,
    required int courseID,
    required int levelID,
  }) async {
    await database.transaction((txn) async {
      txn
          .rawInsert(
        'INSERT INTO size (fileID,  size, type,courseID , levelID) VALUES ("$fileID" , "$size" , "$type"  , "$courseID" , "$levelID")',
      )
          .then((value) async {
        print('$value insert size successfully');
        // emit(AppinseartDatabaseState());

        // here we should call method for get data from database
        await getDataFromSizeTable(levelID: levelID);
        // emit(AppSuccessInsertDatabaseState());
      }).catchError((error) {
        print('error when inserting new record $error');
      });
    });
  }

  Future<void> getDataFromSizeTable({required int levelID}) async {
    // here we should make our array or anouther
    // data type empty to assigned new data from database
    // activeCategory = [];
    levelSize = [];

    // emit(AppGetDatabaseLoadingState());
    await database
        .rawQuery('SELECT * FROM size WHERE levelID == $levelID')
        .then((value) {
      // here we can fellter the result and assign to our dataType

      print('-----------------------------------------------------------');
      print('                                                            ');

      print(value);

      print('                                                            ');
      print('-----------------------------------------------------------');

// ! ----------------------------- here we should edit
      if (videoDownloadBytes.isEmpty) {
        for (var element in value) {
          // if (element['type'] == 'video') {
          levelSize.add(SizeModel.fromJson(element));
          videoIsDownloaded.add(element['isDownload'] == true);
          videoDownloadBytes.add(0);
          maxVideoDownloadBytes.add(0);
          // }
        }
      } else {
        for (var element in value) {
          // if (element['type'] == 'video') {
          levelSize.add(SizeModel.fromJson(element));
          // }
        }
      }
      print('videoIsDownloaded length: ${videoIsDownloaded.length}');
      // emit(AppSuccessGetDatabaseState());
      // print(levelSize[0].isDownloaded);
    }).catchError(
      (Error) {
        print('there is an error in get method $Error');
        emit(AppFailureGetDatabaseState());
      },
    );
  }

  Future<void> getDataFromSizeTablePdf({required int levelID}) async {
    // here we should make our array or anouther
    // data type empty to assigned new data from database
    // activeCategory = [];
    pdfSize = [];

    if (videoDownloadBytes.isNotEmpty) {}
    // emit(AppGetDatabaseLoadingState());
    await database
        .rawQuery('SELECT * FROM size WHERE levelID == $levelID')
        .then((value) {
      // here we can fellter the result and assign to our dataType

      print('-----------------------------------------------------------');
      print('                                                            ');

      print(value);

      print('                                                            ');
      print('-----------------------------------------------------------');

// ! ----------------------------- here we should edit
      if (videoDownloadBytes.isEmpty) {
        for (var element in value) {
          levelSize.add(SizeModel.fromJson(element));
          videoIsDownloaded.add(element['isDownload'] == true);
          videoDownloadBytes.add(0);
          maxVideoDownloadBytes.add(0);
        }
      } else {
        for (var element in value) {
          levelSize.add(SizeModel.fromJson(element));
        }
      }
      print('videoIsDownloaded length: ${videoIsDownloaded.length}');
      // emit(AppSuccessGetDatabaseState());
      // print(levelSize[0].isDownloaded);
    }).catchError(
      (Error) {
        print('there is an error in get method $Error');
        emit(AppFailureGetDatabaseState());
      },
    );
  }

  Future<void> updateSizeDetails(
      {required int fileID,
      required String isDownload,
      required String type}) async {
    database.rawUpdate(
        'UPDATE size SET isDownload = ? WHERE fileID = ? AND type = ?',
        [isDownload, fileID, type]).then(
      (value) async {
        // here we should call method get data base
        print('update student info success $value');
        // await getStudentFromDatabase(database2, id.toString());
      },
    );
  }
*/
  Future<void> requestPermissionsStorage() async {
    final storageStatus = await Permission.storage.request();
    final storageStatus2 = await Permission.manageExternalStorage.request();

    if (storageStatus.isDenied && storageStatus2.isDenied) {
      // You have the necessary permissions.
      await requestPermissionsStorage();
    }
  }

  Future<String> encryptedFile({required fileBytes, required File file}) async {
    try {
      print('start encryptedFile -------------------------------- ');
      final key = encrypt.Key.fromUtf8('my 32 length key................');
      final iv = encrypt.IV.fromBase64("AAAAAAAAAAAAAAAAAAAAAA==");
      // file.writeAsBytes(fileBytes);
      // final fileContent = file.readAsStringSync();
      final fileContent = String.fromCharCodes(fileBytes);
      final encrypter = Encrypter(AES(key, padding: null));
      final encrypted = encrypter.encrypt(fileContent, iv: iv);

      await file.writeAsBytes(encrypted.bytes);
      print('finish encrypted file ***********************************');
      return 'success';
    } catch (e) {
      emit(
        FailureDownloadFile(
          e.toString(),
        ),
      );
      print(e.toString());
      return e.toString();
    }
  }

  Future<void> downloadEncryptedFile({
    required String fileUrl,
    required String fileName,
    required String storageName,
    required bool isVideo,
    required String type,
    required int fileID,
    int levelID = -1,
    required int courseID,
    bool isQes = false,
    int index = 0,
  }) async {
    await requestPermissionsStorage();

    // String shareUrl = Encryption.decrypt(fileUrl);
    // String url = convertDriveLink(shareUrl);
    // print(url);
    //! change bool attribures
    // fileUrl = convertDriveLink(
    //   'https://drive.google.com/file/d/1PG3YfYua-bVztZUeANrymEkBly5W0k8w/view?usp=sharing',
    // );
    // fileUrl =
    // 'https://drive.google.com/uc?export=download&id=1Csq6Svk20fNrDgINNXie2IDYJYDOkhjp';
    final appDocDir = Directory('storage/emulated/0/video');
    if (await appDocDir.exists()) {
      print('exist');
    } else {
      appDocDir.create();
    }
    // Change to your desired file name

    final File file = File('${appDocDir.path}/$storageName');
    // final File file = File('storage/emulated/0/video/$fileName');

    print(file.path);
    bool isExist = await file.exists();
    print('isExist $isExist');
    if (!isExist) {
      try {
        // final encryptedVideo = File('${appDocDir.path}/$fileName');
        // final response = await http.get(Uri.parse(fileUrl));

        if (isVideo) {
          print('is video');
          videoIsDownloaded[index] = true;
        } else {
          if (isQes) {
            print('is qes Pdf');
            pdfIsDownloadedQuz[index] = true;
          } else {
            print('is normal Pdf');
            pdfIsDownloaded[index] = true;
          }
        }

        emit(LoadingDownloadFile());
        String size = '0';
        // await updateSizeDetails(fileID: fileID, isDownload: 'true', type: type);
        // int? maxSize;
        // final fileSizeResponse;
        // int? fileSize;
        String? mainUrl;

        // fileSizeResponse = await dio.head(
        //   // '${Constants.kBaseUrlFOrSizeAPi}$fileUrl',
        //   '${Constants.kDefaultDomain}$fileUrl',
        //   // "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4",

        // );

        // print('111111111');

        // fileSize = int.tryParse(
        //     fileSizeResponse.headers["content-length"]![0].toString());
        mainUrl = '${Constants.kDefaultDomain}$fileUrl';
        // if (!isVideo) {
        //   print('type is pdf');
        //   fileSizeResponse = await dio.get(
        //     '${Constants.kBaseUrlFOrSizeAPi}$fileUrl',
        //     // "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4",
        //   );
        //   fileSize = int.tryParse(fileSizeResponse.data['size']);
        //   print('file size :$fileSize');
        //   mainUrl = '${Constants.kBaseDownloadUrlPdf}$fileUrl';
        //   String token = await CasheHelper.getData(key: Constants.kToken);
        //   dio.options.headers["Authorization"] = "Bearer $token";
        // } else {
        //   print('asdasd');
        //   fileSizeResponse = await dio.head(
        //     // '${Constants.kBaseUrlFOrSizeAPi}$fileUrl',
        //     '${Constants.kDefaultDomain}$fileUrl',
        //     // "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4",
        //   );
        //   print('111111111');
        //   fileSize = int.tryParse(
        //       fileSizeResponse.headers["content-length"]![0].toString());
        //   mainUrl = '${Constants.kDefaultDomain}$fileUrl';
        // }
        // int? fileSize = 2;
        // if (fileSize != null) {
        String token = await CasheHelper.getData(
          key: Constants.kToken,
        );
        final response = await dio.get(
          // '${Constants.kBaseDownloadUrl}$fileUrl',
          // fileUrl,
          mainUrl,

          // "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4",
          options: Options(
            responseType: ResponseType.bytes,
            // headers: {"Authorization": "Bearer $token"},
          ),
          // file.path,
          onReceiveProgress: (count, total) async {
            // print('-----------------  $fileSize');
            // maxSize ??= await dio.options.headers["content-length"];
            // print(maxSize);
            // print('total :$maxSize');
            if (total > 210000000) {
              emit(
                FailureDownloadFile(
                  'the file size is larger than the allowed limit!',
                ),
              );
              // dio.
              dio.close(force: true);
              dio = Dio();
              // return ;
            }
            print('$count / $total');
            if (size == '0') {
              size = (total / 1048576).toStringAsFixed(0);
            }
            if (isVideo) {
              maxVideoDownloadBytes[index] = total;
              videoDownloadBytes[index] = count;
              emit(LoadingDownloadFile());
            } else {
              if (isQes) {
                maxPdfDownloadBytesQuz[index] = total;
                pdfDownloadBytesQuz[index] = count;
              } else {
                maxPdfDownloadBytes[index] = total;
                pdfDownloadBytes[index] = count;
              }
              emit(LoadingDownloadFile());
            }
            print('$count / $total');
          },
        ).then((value) async {
          // await updateSizeDetails(
          // fileID: fileID, isDownload: 'true', type: type);
          if (isVideo) {
            videoIsDownloaded[index] = false;
          } else {
            if (isQes) {
              pdfIsDownloadedQuz[index] = false;
            } else {
              pdfIsDownloaded[index] = false;
            }
            // await file.writeAsBytes(value.data);
            print('storage file done');
          }
          emit(AlertDecryptFile());
          Timer(const Duration(seconds: 1), () async {
            String statusOfEncrypted =
                await encryptedFile(file: file, fileBytes: value.data);
            print('11111111 $statusOfEncrypted');
            if (statusOfEncrypted == 'success') {
              //! important edit
              await insertToFIleTable(
                courseID: courseID,
                fileName: fileName,
                storageName: storageName,
                id: fileID,
                levelID: levelID,
                path: '${appDocDir.path}/$storageName',
                size: size,
                type: type,
              );
              print('downlaod is done');
            } else {
              if (type == 'video') {
                emit(FailureDecryptFile(statusOfEncrypted));
              } else {
                emit(FailureDecryptFilePdf(statusOfEncrypted));
              }
            }
          });
        });
        // } else {
        //   if (type == 'video') {
        //     emit(FailureDownloadFile('check your internet'));
        //   } else {
        //     emit(FailureDecryptFilePdf('check your internet'));
        //   }
        // }
        // await encryptedVideo.writeAsBytes(response.bodyBytes);
      } catch (e) {
        // await updateSizeDetails(
        //     fileID: fileID, isDownload: 'false', type: type);
        print('error : $e');
        if (isVideo) {
          videoIsDownloaded[index] = false;
        } else {
          if (isQes) {
            pdfIsDownloadedQuz[index] = false;
          } else {
            pdfIsDownloaded[index] = false;
          }
        }

        // if (type == 'video') {
        //   emit(FailureDownloadFile(e.toString()));
        // } else {
        //   emit(FailureDecryptFilePdf(e.toString()));
        // }

        print('error in download file :$e');
      }
    } else {
      if (type == 'video') {
        emit(FileIsExistState());
      } else {
        emit(FileIsExistStatePdf());
      }
      print('file is exist');
    }
  }

  String convertDriveLink(String sharedLink) {
    // ! here we should decrypted *sharedLink* from hyder
    //! class
    if (sharedLink.contains('drivesdk')) {
      sharedLink = sharedLink.replaceAll('drivesdk', 'sharing');
    }
    if (sharedLink.contains('/file/d/') &&
        sharedLink.contains('/view?usp=sharing')) {
      final startIdx = sharedLink.indexOf('/file/d/') + 8;
      final endIdx = sharedLink.indexOf('/view?usp=sharing');
      if (startIdx < endIdx) {
        final fileId = sharedLink.substring(startIdx, endIdx);
        return 'https://drive.google.com/uc?export=download&id=$fileId';
      }
    }
    return sharedLink;
  }

  Future<void> decryptFile({
    required File file,
    required String fileName,
    required String type,
  }) async {
    try {
      emit(LoadingDecryptFile());

      final videoFileContents = file.readAsBytesSync();
      final key = encrypt.Key.fromUtf8('my 32 length key................');
      final iv = encrypt.IV.fromBase64("AAAAAAAAAAAAAAAAAAAAAA==");
      final encrypter = encrypt.Encrypter(encrypt.AES(key, padding: null));

      final encryptedFile = encrypt.Encrypted(videoFileContents);
      final decrypted = encrypter.decrypt(encryptedFile, iv: iv);

      final decryptedBytes = latin1.encode(decrypted);
      print('decryptDone');
      await cacheManager.putFile(
        fileName, // You can use the URL as the key
        decryptedBytes,
        fileExtension: type,
      );
      print('put in cache done');
      emit(SuccessDecryptFile());
    } catch (e) {
      emit(FailureDecryptFile(e.toString()));
    }
  }
}
