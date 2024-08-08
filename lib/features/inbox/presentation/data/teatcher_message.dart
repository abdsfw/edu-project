import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../constants.dart';

class GetTeatcherMessage {
  static Future<List<Map<String, dynamic>>> fetchTeacherMessages() async {
    final apiUrl =
        Uri.parse('${Constants.kDomain}users/managers/chats/get-all');

    final response = await http.get(apiUrl);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final data = jsonResponse['data'] as List;
      final messages =
          data.map((message) => message as Map<String, dynamic>).toList();
      return messages;
    } else {
      throw Exception('Failed to fetch messages: ${response.reasonPhrase}');
    }
  }
}
