import 'package:educational_app/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../../core/cache/cashe_helper.dart';
import 'course_model.dart';

class CourseApi {
  static Future<CourseList> fetchCourses({required int yearID}) async {
    try {
      String token = await CasheHelper.getData(key: Constants.kToken);
      final headers = <String, String>{
        'Authorization': 'Bearer $token', // Add your token here
      };

      print(token);
      final response = await http.get(
        Uri.parse('${Constants.kDomain}users/courses/get-all/$yearID'),
        headers: headers,
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return CourseList.fromJson(jsonResponse['data']);
      } else {
        throw Exception('Failed to load courses');
      }
    } catch (e) {
      // Handle exceptions here, such as network errors.
      print('Error fetching courses: $e');
      throw Exception('Failed to fetch courses: $e');
    }
  }

  static Future<CourseList> fetchExternalCourses() async {
    try {
      String token = await CasheHelper.getData(key: Constants.kToken);
      final headers = <String, String>{
        'Authorization': 'Bearer $token', // Add your token here
      };

      print(token);
      final response = await http.get(
        Uri.parse('${Constants.kDomain}users/courses/get-all'),
        headers: headers,
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return CourseList.fromJson(jsonResponse['data']);
      } else {
        throw Exception('Failed to load courses');
      }
    } catch (e) {
      // Handle exceptions here, such as network errors.
      print('Error fetching courses: $e');
      throw Exception('Failed to fetch courses: $e');
    }
  }
}
