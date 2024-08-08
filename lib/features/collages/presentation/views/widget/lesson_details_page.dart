import 'package:educational_app/core/utils/color_app.dart';
import 'package:educational_app/core/utils/styles.dart';
import 'package:educational_app/core/widgets/custom_Loading_indicator.dart';
import 'package:educational_app/core/widgets/custom_error_widget.dart';
import 'package:educational_app/core/widgets/custom_no_data_widget.dart';
import 'package:educational_app/features/collages/presentation/views/widget/pdf_and_video_library.dart';
import 'package:educational_app/features/collages/presentation/views/widget/quiz_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/widgets/custom_button.dart';
import '../../manager/college_cubit/college_cubit.dart';
import 'level_page.dart';

class LessonDetailsPage extends StatelessWidget {
  const LessonDetailsPage(
      {super.key, required this.courseID, required this.courseName});
  final int courseID;
  final String courseName;
  @override
  Widget build(BuildContext context) {
    CollegeCubit collegeCubit = CollegeCubit.get(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          courseName,
          style: Styles.textStyle20White,
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          color: Colors.white,
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
            ),
            onPressed: () {
              collegeCubit.getDataFromFileTableByCourseID(courseID);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const PdfAndVideoLibrary(),
                ),
              );
            },
            child: Icon(Icons.book),
            // const Text(
            //   'library',
            //   style: Styles.textStyle15PriCol,
            // ),
          ),
        ],
      ),
      body: BlocBuilder<CollegeCubit, CollegeState>(
        builder: (context, state) {
          if (state is LoadingFetchCourseTimeLineState) {
            return const CustomLoadingIndicator(
              color: AppColor.kPrimaryColor,
            );
          } else if (state is FailureFetchCourseTimeLineState) {
            return CustomErrorWidget(
              errMessage: state.errMessage,
              iconColor: AppColor.kPrimaryColor,
              textStyle: Styles.textStyle20PriCol,
            );
          } else if (collegeCubit.timeLine.timeline == null) {
            return const CustomErrorWidget(
              errMessage: 'there is no time line in this course',
            );
          } else if (collegeCubit.timeLine.timeline!.isEmpty) {
            return Column(
              children: [
                const CustomNoDataWidget(),
                IconButton(
                  onPressed: () {
                    collegeCubit.fetchCourseTimeLine(
                      courseID: courseID,
                    );
                  },
                  icon: const Icon(
                    Icons.replay_outlined,
                  ),
                )
              ],
            );
          } else {
            return TImeLineBody(
              courseID: courseID,
            );
          }
        },
      ),
    );
  }
}

class TImeLineBody extends StatelessWidget {
  const TImeLineBody({
    super.key,
    required this.courseID,
  });
  final int courseID;
  @override
  Widget build(BuildContext context) {
    CollegeCubit collegeCubit = CollegeCubit.get(context);
    int? timeLineOrder =
        int.tryParse(collegeCubit.timeLine.studentLevel!.order.toString());

    // print('order ID $timeLineOrder');
    // int timeLineAmount = (timeLineOrder == null)
    //     ? 0
    //     : (timeLineOrder - collegeCubit.timeLine.timeline!.first.order! + 1);
    // double percentTimeLine = (timeLineOrder != null)
    //     ? double.parse(
    //         (timeLineAmount / collegeCubit.timeLine.timeline!.length)
    //             .toStringAsFixed(1),
    //       )
    //     : 0.0;

    return Column(
      children: [
        /*
        Card(
          color: Colors.grey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: LinearPercentIndicator(
              animation: true,
              animationDuration: 2000,
              lineHeight: 20,
              barRadius: const Radius.circular(10),
              progressColor: AppColor.kPrimaryColor,
              backgroundColor: Colors.white,
              percent: percentTimeLine,
              center: Text(
                '${(percentTimeLine * 100).toStringAsFixed(1)}%',
                style: Styles.textStyle14.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.red.withOpacity(0.7),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        */
        Expanded(
          /*
          child: ListView.builder(
            itemCount: collegeCubit.timeLine.timeline!.length,
            itemBuilder: (context, index) {
              
              String typeOfTimeLine = '';
              String nameOfTimeLine = '';
              if (collegeCubit.timeLine.timeline![index].level != null) {
                typeOfTimeLine = 'level';
                nameOfTimeLine = collegeCubit
                    .timeLine.timeline![index].level!.name
                    .toString();
              } else if (collegeCubit.timeLine.timeline![index].quiz != null) {
                typeOfTimeLine = 'quiz';
                nameOfTimeLine = collegeCubit
                    .timeLine.timeline![index].quiz!.name
                    .toString();
              } else {
                typeOfTimeLine = 'null';
                nameOfTimeLine = 'null';
              }
              Widget? childOfCircleAvatar;
              if (timeLineOrder != null) {
                if (collegeCubit.timeLine.timeline![index].order! <=
                    timeLineOrder) {
                  childOfCircleAvatar = Text(
                    (index + 1).toString(),
                    style: Styles.textStyle40SecCol,
                  );
                }
              } else if (collegeCubit.timeLine.timeline![index].available!) {
                childOfCircleAvatar = Text(
                  (index + 1).toString(),
                  style: Styles.textStyle40SecCol,
                );
              }
/*
(
                                  collegeCubit
                                          .timeLine.timeline![index].order! >
                                      timeLineOrder! )
*/
              bool backGroundImage = true;
              if ((timeLineOrder == null &&
                  !collegeCubit.timeLine.timeline![index].available!)) {
                backGroundImage = true;
              } else if (timeLineOrder == null &&
                  collegeCubit.timeLine.timeline![index].available!) {
                backGroundImage = false;
              } else if (timeLineOrder != null &&
                  collegeCubit.timeLine.timeline![index].order! <=
                      timeLineOrder) {
                backGroundImage = false;
              }
              return InkWell(
                splashColor: Colors.deepOrange,
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  if ((typeOfTimeLine == 'level' &&
                          timeLineOrder != null &&
                          collegeCubit.timeLine.timeline![index].order! <=
                              timeLineOrder) ||
                      (collegeCubit.timeLine.timeline![index].available! &&
                          typeOfTimeLine == 'level')) {
                    // print("this level id");

                    print(
                        'level ID : ${collegeCubit.timeLine.timeline![index].levelId}');
                    // call api for get level

                    collegeCubit.fetchLevel(
                      levelID: collegeCubit.timeLine.timeline![index].levelId!,
                    );

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => LevelPage(
                          levelID:
                              collegeCubit.timeLine.timeline![index].levelId!,
                        ),
                      ),
                    );
                  }
                  //! here Quiz
                  else if ((typeOfTimeLine == 'quiz' &&
                          timeLineOrder != null &&
                          collegeCubit.timeLine.timeline![index].order! <=
                              timeLineOrder) ||
                      (collegeCubit.timeLine.timeline![index].available! &&
                          typeOfTimeLine == 'quiz')) {
                    // call api for get quiz
                    collegeCubit.fetchQuiz(
                      quizID: collegeCubit.timeLine.timeline![index].quizId!,
                    );
                    print(
                        'quiz ID: ${collegeCubit.timeLine.timeline![index].quizId!}');
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => QuizPage(
                          quizID:
                              collegeCubit.timeLine.timeline![index].quizId!,
                          // levelID: collegeCubit
                          //     .timeLine.timeline![index].level!.id!,
                          // levelName: collegeCubit
                          //     .timeLine.timeline![index].level!.name!,
                          courseID: courseID,
                        ),
                      ),
                    );
                  } else {
                    print('something is null');
                  }
                },
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: (backGroundImage)
                          ? const AssetImage(
                              "assets/image/lock.png",
                            )
                          : null,
                      radius: 40,
                      child: childOfCircleAvatar,
                    ),
                    Expanded(
                      child: Text(
                        nameOfTimeLine,
                        textAlign: TextAlign.center,
                        style: Styles.textStyle15PriCol,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              );
            },
            // itemBuilder: (context, index) => CustomButton(
            //   data: '',
            //   urlImage: 'assets/image/lock2.png',
            //   onTap: () {},
            // ),
          ),
*/
// ListView.builder
          child: ListView.builder(
            itemBuilder: (context, index) {
              String typeOfTimeLine = '';
              String nameOfTimeLine = '';
              if (collegeCubit.timeLine.timeline![index].level != null) {
                typeOfTimeLine = 'level';
                nameOfTimeLine = collegeCubit
                    .timeLine.timeline![index].level!.name
                    .toString();
              } else if (collegeCubit.timeLine.timeline![index].quiz != null) {
                typeOfTimeLine = 'quiz';
                nameOfTimeLine = collegeCubit
                    .timeLine.timeline![index].quiz!.name
                    .toString();
              } else {
                typeOfTimeLine = 'null';
                nameOfTimeLine = 'null';
              }
              Widget? childOfCircleAvatar;
              if (timeLineOrder != null) {
                if (collegeCubit.timeLine.timeline![index].order! <=
                    timeLineOrder) {
                  childOfCircleAvatar = Text(
                    (index + 1).toString(),
                    style: Styles.textStyle40SecCol,
                  );
                }
              } else if (collegeCubit.timeLine.timeline![index].available!) {
                childOfCircleAvatar = Text(
                  (index + 1).toString(),
                  style: Styles.textStyle40SecCol,
                );
              }
/*
(
                                  collegeCubit
                                          .timeLine.timeline![index].order! >
                                      timeLineOrder! )
*/
              bool backGroundImage = true;
              if ((timeLineOrder == null &&
                  !collegeCubit.timeLine.timeline![index].available!)) {
                backGroundImage = true;
              } else if (timeLineOrder == null &&
                  collegeCubit.timeLine.timeline![index].available!) {
                backGroundImage = false;
              } else if (timeLineOrder != null &&
                  collegeCubit.timeLine.timeline![index].order! <=
                      timeLineOrder) {
                backGroundImage = false;
              }
              return CustomButton(
                data: nameOfTimeLine,
                urlImage: backGroundImage ? 'assets/image/lock2.png' : null,
                onTap: () {
                  if ((typeOfTimeLine == 'level' &&
                          timeLineOrder != null &&
                          collegeCubit.timeLine.timeline![index].order! <=
                              timeLineOrder) ||
                      (collegeCubit.timeLine.timeline![index].available! &&
                          typeOfTimeLine == 'level')) {
                    // print("this level id");

                    print(
                        'level ID : ${collegeCubit.timeLine.timeline![index].levelId}');
                    // call api for get level

                    collegeCubit.fetchLevel(
                      levelID: collegeCubit.timeLine.timeline![index].levelId!,
                    );

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => LevelPage(
                          levelID:
                              collegeCubit.timeLine.timeline![index].levelId!,
                        ),
                      ),
                    );
                  }
                  //! here Quiz
                  else if ((typeOfTimeLine == 'quiz' &&
                          timeLineOrder != null &&
                          collegeCubit.timeLine.timeline![index].order! <=
                              timeLineOrder) ||
                      (collegeCubit.timeLine.timeline![index].available! &&
                          typeOfTimeLine == 'quiz')) {
                    // call api for get quiz
                    collegeCubit.fetchQuiz(
                      quizID: collegeCubit.timeLine.timeline![index].quizId!,
                    );
                    print(
                        'quiz ID: ${collegeCubit.timeLine.timeline![index].quizId!}');
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => QuizPage(
                          quizID:
                              collegeCubit.timeLine.timeline![index].quizId!,
                          // levelID: collegeCubit
                          //     .timeLine.timeline![index].level!.id!,
                          // levelName: collegeCubit
                          //     .timeLine.timeline![index].level!.name!,
                          courseID: courseID,
                        ),
                      ),
                    );
                  } else {
                    print('something is null');
                    print(backGroundImage);
                  }
                },
              );
            },
            itemCount: collegeCubit.timeLine.timeline!.length,
          ),

          // ),
          // ),
        ),
      ],
    );
  }
}
