
import 'package:educational_app/features/collages/presentation/manager/college_cubit/college_cubit.dart';
import 'package:educational_app/features/collages/presentation/views/widget/lessons_home_page.dart';
import 'package:educational_app/features/collages/presentation/views/widget/pdf_and_video_library.dart';
import 'package:educational_app/features/enterCodePage/presentation/views/enter_code_dailog.dart';
import 'package:flutter/material.dart';

import '../../../../../constants.dart';
import '../../../../../core/utils/styles.dart';
import '../../../../collages/presentation/views/college_home_page.dart';
import '../../../../inbox/presentation/views/chat_screen.dart';

class HomeGridView extends StatelessWidget {
  const HomeGridView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    CollegeCubit collegeCubit = CollegeCubit.get(context);

    return Expanded(
      flex: 2,
      child: GridView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        children: [
          // ------------- college ----------------
          Card(
            color: Colors.white70,
            child: ListTile(
              // splashColor: Colors.amber,
              title: const Image(
                image: AssetImage(
                  Constants.kCollege,
                ),
                fit: BoxFit.cover,
              ),
              subtitle: const Text(
                'college',
                textAlign: TextAlign.center,
                style: Styles.textStyle20Black,
              ),
              onTap: () {
                collegeCubit.fetchAllColleges();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CollegeHomePage(),
                  ),
                );
              },
            ),
          ),
          // --------------------------------------
          // ------------- enter code -------------
          Card(
            color: Colors.white70,
            child: ListTile(
              // splashColor: Colors.amber,
              // hoverColor: Colors.black,
              title: const Image(
                image: AssetImage(
                  Constants.kBinaryCode,
                ),
                fit: BoxFit.cover,
              ),
              subtitle: const Text(
                'enter code',
                textAlign: TextAlign.center,
                style: Styles.textStyle20Black,
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return CustomDialogBox(
                      key: UniqueKey(), // Provide a unique key here
                      title: "asa",
                      descriptions: "asas",
                      text: "nnnnn",
                    );
                  },
                );
              },
            ),
          ),
          // --------------------------------------
          // -------------- inbox -----------------
          Card(
            color: Colors.white70,
            child: ListTile(
              // splashColor: Colors.amber,
              // hoverColor: Colors.black,
              title: const Image(
                image: AssetImage(
                  Constants.kEmail,
                ),
                fit: BoxFit.cover,
              ),
              subtitle: const Text(
                'inbox',
                textAlign: TextAlign.center,
                style: Styles.textStyle20Black,
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ChatScreens(),
                  ),
                );
              },
            ),
          ),
          // --------------------------------------
          // ------------- Library ----------------
          Card(
            color: Colors.white70,
            child: ListTile(
              // splashColor: Colors.amber,
              // hoverColor: Colors.black,
              title: const Image(
                image: AssetImage(
                  Constants.kLibrary,
                ),
                fit: BoxFit.cover,
              ),
              subtitle: const Text(
                'Library',
                textAlign: TextAlign.center,
                style: Styles.textStyle20Black,
              ),
              onTap: () async {
                collegeCubit.getDataFromFileTable();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const PdfAndVideoLibrary(),
                  ),
                );
              },
            ),
          ),
          // --------------------------------------
          // ------------ External Course ---------
          Card(
            color: Colors.white70,
            child: ListTile(
              // splashColor: Colors.amber,
              // hoverColor: Colors.black,
              title: const Image(
                image: AssetImage(
                  Constants.kExternalCourse,
                ),
                fit: BoxFit.cover,
              ),
              subtitle: const Text(
                'Courses',
                textAlign: TextAlign.center,
                style: Styles.textStyle20Black,
              ),
              onTap: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LessonsHomePage(
                      yearIndex: null,
                      yearID: null,
                      isExternalCourse: true,
                    ),
                  ),
                );
              },
            ),
          ),
          // ----------------------------------------
        ],
      ),
    );
  }
}
