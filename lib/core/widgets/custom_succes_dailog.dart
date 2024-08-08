import 'package:educational_app/core/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import '../utils/color_app.dart';

class ErrorDialog {
  static void show(BuildContext context, String message) {
    AwesomeDialog(
            context: context,
            animType: AnimType.scale,
            dialogType: DialogType.success,
            body: Center(
              child: Text(
                message,
                style: Styles.textStyle20,
              ),
            ),
            title: 'Registration Failed',
            desc: 'An error occurred during registration.',
            btnOkOnPress: () {},
            btnOkColor: AppColor.kPrimaryColor,
            autoHide: Duration(seconds: 5))
        .show();
  }
}
