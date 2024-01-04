// services/api_service.dart

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

String clientId = 'a3a6968e00f4732';
String clientSecret = '90e213a12e5151c243a39133bd50a6baa71824bc';

enum ApiUrls {
  topImageList,
}

extension ApiUrlsExtension on ApiUrls {
  static const baseUrl = "https://api.imgur.com/3/";

  String url({dynamic parameter}) {
    switch (this) {
      case ApiUrls.topImageList:
        print('------full url');
        print(
            '${baseUrl}gallery/search/top/${parameter}1?q_type=jpg&q_size_px=med&q=popular');
        return '${baseUrl}gallery/search/top/${parameter}1?q_type=jpg&q_size_px=med&q=popular';
      default:
        return "";
    }
  }
}

class APIService {
  final Client httpClient;

  APIService({required this.httpClient});

  Future<Map<String, dynamic>> post(
      String apiUrl, Map<String, dynamic> body) async {
    try {
      final response = await httpClient.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json', 'Authorization': ''},
        body: jsonEncode(body),
      );

      print('----------------------post api response----------------');
      print(response.body);

      final jsonData = json.decode(response.body);
      return jsonData;
    } catch (e) {
      throw Exception('Error during API request: $e');
    }
  }

  Future get(String apiUrl, Map map) async {
    try {
      final response = await httpClient.get(Uri.parse(apiUrl), headers: {
        HttpHeaders.authorizationHeader: "Client-ID a3a6968e00f4732"
      });
      // print('----------------------get api response----------------');
      // print(response.body);

      final jsonData = json.decode(response.body);
      return jsonData;
    } catch (e) {
      // Handle other types of exceptions that may occur during the process
      throw Exception('API request failed with status code $e');
    }
  }
}
