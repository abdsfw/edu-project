import 'package:educational_app/core/utils/color_app.dart';
import 'package:educational_app/core/utils/styles.dart';
import 'package:educational_app/core/widgets/custom_button.dart';
import 'package:educational_app/core/widgets/custom_error_widget.dart';
import 'package:educational_app/core/widgets/custom_no_data_widget.dart';
import 'package:educational_app/features/edit_profile/edit_profile_body.dart';
import 'package:educational_app/features/edit_profile/presentation/manager/cubit/edit_cubit.dart';
import 'package:educational_app/features/home/presentation/views/widget/enter_code_button.dart';
import 'package:educational_app/features/home/presentation/manager/cubit/f_ile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/custom_Loading_indicator.dart';
import '../../../collages/presentation/manager/college_cubit/college_cubit.dart';
import '../../../collages/presentation/views/widget/lesson_details_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    FIleCubit fileCubit = FIleCubit.get(context);
    CollegeCubit collegeCubit = CollegeCubit.get(context);
    EditCubit edit = EditCubit.get(context);

    return Scaffold(
      drawerEnableOpenDragGesture: false,
      endDrawerEnableOpenDragGesture: false,
      extendBody: true,
      resizeToAvoidBottomInset: false,
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              color: AppColor.kPrimaryColor,
              child: Center(
                  child: InkWell(
                onTap: () {
                  edit.canselEdit();
                  edit.fetchUserInfo();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const EditProfileBody(),
                    ),
                  );
                },
                child: const CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 60,
                  ),
                ),
              )),
              // child: const StudentDetails(),
            ),
            const EnterCodeButton(
              data: 'enter code',
            ),
          ],
        ),
      ),

      // appBar: AppBar(
      //   leading: Builder(builder: (context) {
      //     return IconButton(
      //       icon: const Icon(
      //         Icons.sort,
      //         color: Colors.white,
      //       ),
      //       onPressed: () {
      //         Scaffold.of(context).openDrawer();
      //       },
      //     );
      //   }),
      //   backgroundColor: AppColor.kPrimaryColor,
      //   title: const Text("WiseKey", style: Styles.textStyle20White),
      //   centerTitle: true,
      //   // Other AppBar properties...
      // ),
      body: CustomScrollView(
        slivers: [
          // sliver app bar
          SliverAppBar(
            leading: Builder(
              builder: (context) {
                //here we wrap IconButton button with builder so
                //  we can open drawer as action of button
                return IconButton(
                  icon: const Icon(
                    Icons.sort,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              },
            ),
            backgroundColor: AppColor.kPrimaryColor,
            title: const Text("WiseKey", style: Styles.textStyle20White),
            centerTitle: true,
            // flexibleSpace: Center(child: Text('data')),

            floating: true,
            pinned: true,
            expandedHeight: 170,
            flexibleSpace: FlexibleSpaceBar(
              background: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: BlocBuilder<FIleCubit, FIleState>(
                      builder: (context, state) {
                        if (state is! LoadingFetchExternalCoursesState &&
                            state is! FailureFetchExternalCoursesState) {
                          return TextFormField(
                            style: Styles.textStyle14White,
                            onTapOutside: (event) {
                              // if (autoFocus) {
                              FocusManager.instance.primaryFocus?.unfocus();
                              // }
                            },
                            onChanged: fileCubit.courseSearch,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColor.kSeconderColor,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              hintText: 'search',
                              hintStyle: Styles.textStyle18White,
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  )
                ],
              ),
              // centerTitle: true,
              // title: Text("WiseKey", style: Styles.textStyle20White),
            ),
         
          ),
          BlocConsumer<FIleCubit, FIleState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is LoadingFetchExternalCoursesState) {
                return const SliverToBoxAdapter(
                  child: CustomLoadingIndicator(
                    color: AppColor.kPrimaryColor,
                  ),
                );
              } else if (state is FailureFetchExternalCoursesState) {
                return SliverToBoxAdapter(
                  child: Column(
                    children: [
                      CustomErrorWidget(
                        errMessage: state.errMessage,
                        iconColor: AppColor.kPrimaryColor,
                        textStyle: Styles.textStyle15PriCol,
                      ),
                      IconButton(
                        onPressed: () {
                          fileCubit.fetchExternalCourse();
                        },
                        icon: const Icon(
                          Icons.replay_outlined,
                        ),
                      )
                    ],
                  ),
                );
              } else if (state is SearchFetchExternalCoursesState &&
                  fileCubit.currentCourse.isEmpty) {
                return const SliverToBoxAdapter(
                  child: CustomNoDataWidget(),
                );
              } else if (fileCubit.currentCourse.isEmpty) {
                return SliverToBoxAdapter(
                    child: Column(
                  children: [
                    const CustomNoDataWidget(),
                    IconButton(
                      onPressed: () {
                        fileCubit.fetchExternalCourse();
                      },
                      icon: const Icon(
                        Icons.replay_outlined,
                      ),
                    ),
                  ],
                ));
              } else {
                return SliverList.builder(
                  itemCount: fileCubit.currentCourse.length,
                  itemBuilder: (context, index) => 
                  CustomButton(
                    urlImage: 'assets/image/course.png',
                    onTap: () {
                      collegeCubit.fetchCourseTimeLine(
                        courseID: fileCubit.currentCourse[index].id!,
                      );

                      print(
                          "course ID ${fileCubit.currentCourse[index].id.toString()}");
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => LessonDetailsPage(
                            courseID: fileCubit.currentCourse[index].id!,
                            courseName: fileCubit.currentCourse[index].name!,
                          ),
                        ),
                      );
                    },
                    data: fileCubit.currentCourse[index].name!,
                  ),
                );
              }
            },
          )
        ],
      ),
      //  Column(
      //   children: [
      // CustomButton(
      //   onTap: () {},
      //   data: 'enter code',
      // ),
      //     // Text('sdf'),
      //     // StudentDetails(),
      //     // HomeGridView(),
      //   ],
      // ),
    );
  }
}
