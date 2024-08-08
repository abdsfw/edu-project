import 'dart:convert';
import 'package:educational_app/constants.dart';
import 'package:educational_app/core/cache/cashe_helper.dart';
import 'package:http/http.dart' as http;

import 'message_model.dart';

class MessageApi {
  static Future<List<Message>> fetchMessages(int managerId) async {
    String token = await CasheHelper.getData(key: Constants.kToken);
    final headers = <String, String>{
      'Authorization': 'Bearer $token', // Add your token here
    };
    final apiUrl = Uri.parse(
        '${Constants.kDomain}users/messages/get-all/?manager_id=$managerId');

    final response = await http.get(apiUrl, headers: headers);
    print(Uri.parse(
        '${Constants.kDomain}messages/get-all/?magner_id=$managerId'));
    print(response.statusCode);
    print(response.reasonPhrase);
    print(managerId);
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final data = jsonResponse['data'] as List;
      final messages =
          data.map((message) => Message.fromJson(message)).toList();
      return messages;
    } else {
      throw Exception('Failed to fetch messages: ${response.reasonPhrase}');
    }
  }
}
