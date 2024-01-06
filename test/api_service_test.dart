import 'package:flutter_test/flutter_test.dart';
import 'package:hedgehog_test/manager/api_service.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  group('APIService Tests', () {
    test('Successful POST Request', () async {
      final mockClient = MockClient((request) async {
        return http.Response(jsonEncode({"key": "value"}), 200);
      });

      final response = await APIService(httpClient: mockClient).post(
        ApiUrls.topImageList.url(pageNumber: 1, searchQuery: 'search'),
        {'key': 'value'},
      );

      expect(response, isNotNull);
      expect(response['key'], 'value');
    });

    test('Successful GET Request', () async {
      final mockClient = MockClient((request) async {
        return http.Response(jsonEncode({"key": "value"}), 200);
      });

      final response = await APIService(httpClient: mockClient).get(
          ApiUrls.topImageList.url(pageNumber: 1, searchQuery: 'search'), {});

      expect(response, isNotNull);
      expect(response['key'], 'value');
    });

    test('Failed POST Request', () {
      expect(
        () async {
          final mockClient = MockClient((request) async {
            throw Exception('Failed to connect to the server');
          });

          await APIService(httpClient: mockClient)
              .post('https://invalid-url', {'key': 'value'});
        },
        throwsA(const TypeMatcher<Exception>()),
      );
    });

    test('Failed GET Request', () {
      expect(
        () async {
          final mockClient = MockClient((request) async {
            throw Exception('Failed to connect to the server');
          });

          await APIService(httpClient: mockClient)
              .get('https://invalid-url', {});
        },
        throwsA(const TypeMatcher<Exception>()),
      );
    });
  });
}
