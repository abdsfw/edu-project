import 'dart:convert';

import 'package:educational_app/constants.dart';
import 'package:http/http.dart' as http;

import '../../../../../core/cache/cashe_helper.dart';

class AddCodeApi {
  static Future<http.Response> addCourseCode(String code) async {
    final Uri uri = Uri.parse('${Constants.kDomain}users/codes/edit');
    print(uri.toString());
    print(code);
    String token = await CasheHelper.getData(key: Constants.kToken);

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token', // Add your token here
    };

    final Map<String, String> bodyData = {
      'code': code,
    };

    try {
      final http.Response response = await http.put(
        uri,
        headers: headers,
        body: jsonEncode(bodyData), // Convert the body data to JSON
      );
      print(response.statusCode);
      return response; // Return the HTTP response
    } catch (error) {
      print('Error occurred: $error');
      throw error; // Rethrow the error for handling in the calling code
    }
  }
}
