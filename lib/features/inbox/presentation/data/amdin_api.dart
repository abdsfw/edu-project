import 'dart:convert';
import 'package:educational_app/constants.dart';
import 'package:educational_app/core/cache/cashe_helper.dart';
import 'package:http/http.dart' as http;

import 'amdin_model.dart';

class TeacherApi {
  static const String baseUrl = '${Constants.kDomain}users/managers';

  static Future<List<Teacher>> fetchAllTeachersHasMessage() async {
    String token = await CasheHelper.getData(key: Constants.kToken);
    final headers = <String, String>{
      'Authorization': 'Bearer $token', // Add your token here
    };

    final response =
        await http.get(Uri.parse('$baseUrl/chats/get-all'), headers: headers);
    print(Uri.parse('$baseUrl/get-all/chats'));
    print(response.statusCode);
    print(Uri.parse('$baseUrl/get-all'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];

      List<Teacher> teachers = [];
      for (final teacherData in data) {
        teachers.add(Teacher.fromJson(teacherData));
      }

      return teachers;
    } else {
      throw Exception('Failed to fetch teachers');
    }
  }

  static Future<List<Teacher>> fetchAllTeachers() async {
    String token = await CasheHelper.getData(key: Constants.kToken);
    final headers = <String, String>{
      'Authorization': 'Bearer $token', // Add your token here
    };
    final apiUrl = Uri.parse('${Constants.kDomain}users/managers/get-all');

    final response = await http.get(apiUrl, headers: headers);
    print(response.statusCode);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      List<Teacher> teachers = [];
      for (final teacherData in data) {
        teachers.add(Teacher.fromJson(teacherData));
      }

      return teachers;
    } else {
      throw Exception('Failed to fetch teachers');
    }
  }
}
