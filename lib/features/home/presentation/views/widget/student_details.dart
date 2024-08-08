import 'package:educational_app/core/utils/color_app.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/styles.dart';

class StudentDetails extends StatelessWidget {
  const StudentDetails({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 50,
              child: Icon(
                Icons.person,
                size: 75,
                color: AppColor.kPrimaryColor,
              ),
            ),

            // const Text(
            //   'student name',
            //   style: Styles.textStyle20Black,
            // ),
          ],
        ),
      ),
    );
  }
}
