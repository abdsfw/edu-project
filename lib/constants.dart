import 'package:flutter/material.dart';

abstract class Constants {
  static const String kIsFirstTime = 'first';
  static const String kCairoFont = 'Cairo';
  static const String kToken = 'token';
  static const String kBaseDownloadUrl =
      'https://quarterly-project.onrender.com/Al-amin/users/videos/video/';
  static const String kBaseDownloadUrlPdf =
      'https://quarterly-project.onrender.com/Al-amin/users/pdfs/get/';
  static const String kBaseUrlFOrSizeAPi =
      'https://quarterly-project.onrender.com/Al-amin/manager/videos/size/';
  static const String kDefaultDomain =
      'https://quarterly-project.onrender.com/Al-amin/';
  // ? here we should add `Al-amin/` to domain
  static const String kDomain =
      'https://quarterly-project.onrender.com/Al-amin/';
  static const String kBinaryCode = 'assets/image/binary-code.png';
  static const String kCollege = 'assets/image/college.png';
  static const String kEmail = 'assets/image/email.png';
  static const String kSchool = 'assets/image/school.png';
  static const String kLibrary = 'assets/image/bookshelf.png';
  static const String kExternalCourse = 'assets/image/online-course.png';
  // static const String kNumberOne = 'assets/image/number-oneBlue.png';
  // static const String kNumberTwo = 'assets/image/number-2Blue.png';
  // static const String kNumberThree = 'assets/image/number-3Blue.png';
  // static const String kNumberFour = 'assets/image/number-fourBlue.png';
  // static const String kNumberFive = 'assets/image/number-5Blue.png';
  // static const String kNumberSix = 'assets/image/number-.png';
  static const String kDynamicPhoto = 'assets/image/number-';
  static const String ktop1 = "assets/image/top1.png";
  static const String ktop2 = "assets/image/top2.png";
  static const String kbottom1 = "assets/image/bottom1.png";
  static const String kbottom2 = "assets/image/bottom2.png";

  // static const List<String> photoNumber = [
  //   kNumberOne,
  //   kNumberTwo,
  //   kNumberThree,
  //   kNumberFour,
  //   kNumberFive,
  //   kNumberSix
  // ];
  static const List<String> yearName = [
    "first",
    "second",
    "third",
    "fourth",
    "fifth",
    "sixth",
    "graduated"
  ];

  static const List<String> photoName = ['college', 'enter code', 'inbox'];
  static BorderRadius borderRadius10 = BorderRadius.circular(10);

  static const Decoration listViewDecoration = BoxDecoration(
    color: Colors.grey,
    borderRadius: BorderRadiusDirectional.only(
      topStart: Radius.circular(
        20,
      ),
      topEnd: Radius.circular(
        20,
      ),
    ),
  );
  // static String token = CasheHelper.getData(key: 'token');

  static const double defaultPadding = 20;
}

// String token = CasheHelper.getData(key: 'token');
