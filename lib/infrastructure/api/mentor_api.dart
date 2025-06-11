import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_mento_mentee/infrastructure/models/mentor/mentor_dto.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_mento_mentee/infrastructure/datastore/token_manager.dart';

class MentorApi {
  final Dio _dio;
  static const String _baseUrl = 'http://10.0.2.2:8888';

  MentorApi(this._dio) {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
  }

  Future<List<Mentor>> getMentors() async {
    try {
      debugPrint('Fetching mentors from $_baseUrl/mentors');

      final tokenManager = GetIt.instance<TokenManager>();
      final token = tokenManager.token;

      if (token == null) {
        throw Exception('Authentication token not found. Please login again.');
      }

      final response = await _dio.get(
        '/mentors',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          validateStatus: (status) => status! < 500,
        ),
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response data: ${response.data}');
      debugPrint('Response headers: ${response.headers}');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        debugPrint('Parsed mentors count: ${data.length}');

        if (data is List) {
          return data.map((json) => Mentor.fromJson(json)).toList();
        }
        throw Exception('Invalid response format: Expected List but got ${data.runtimeType}');
      } else if (response.statusCode == 401) {
        throw Exception('Authentication failed. Please login again.');
      } else {
        throw Exception(
          'Failed to load mentors. Status: ${response.statusCode}\n'
              'Message: ${response.statusMessage}\n'
              'Data: ${response.data}',
        );
      }
    } on DioException catch (e) {
      debugPrint('Dio Error: ${e.type} - ${e.message}');
      debugPrint('Error response: ${e.response?.data}');
      debugPrint('Stack trace: ${e.stackTrace}');

      if (e.response?.statusCode == 401) {
        throw Exception('Authentication failed. Please login again.');
      }

      throw Exception(
        'Failed to fetch mentors: ${e.message}\n'
            'URL: ${e.requestOptions.uri}\n'
            'Response: ${e.response?.data}',
      );
    } catch (e, stack) {
      debugPrint('Unexpected error: $e');
      debugPrint('Stack trace: $stack');
      throw Exception('Failed to fetch mentors: $e');
    }
  }
}