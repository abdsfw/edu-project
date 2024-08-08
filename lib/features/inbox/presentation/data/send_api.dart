import 'dart:convert';
import 'package:educational_app/core/cache/cashe_helper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../constants.dart';

class SendMessageApi {
  static Future<http.Response> sendMessage(
      String message, int receiverId) async {
    String token = await CasheHelper.getData(key: Constants.kToken);
    final apiUrl = Uri.parse('${Constants.kDomain}users/messages/add');
    print(Uri.parse('${Constants.kDomain}users/messages/add'));
    print(receiverId);
    try {
      final response = await http.post(
        apiUrl,
        headers: {
          'Content-Type':
              'application/json', // Specify the content type as JSON
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'message': message,
          'receiver_id': receiverId.toInt(),
        }),
      );

      return response; // Return the HTTP response object
    } catch (e) {
      print('Error sending message: $e');
      throw e; // Rethrow the exception to handle it at a higher level if needed
    }
  }
}
