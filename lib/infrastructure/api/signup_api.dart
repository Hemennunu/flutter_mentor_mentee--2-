import 'dart:convert';
import 'package:dio/dio.dart';

class SignupRequest {
  final String name;
  final String email;
  final String password;
  final String role;
  final String skill;

  SignupRequest({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.skill,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'password': password,
    'role': role,
    'skill': skill,
  };
}

class SignupResponse {
  final String token;

  SignupResponse({required this.token});

  factory SignupResponse.fromJson(Map<String, dynamic> json) {
    return SignupResponse(token: json['token']);
  }
}

class SignupApi {
  static final Dio _dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:8888/'));

  static Future<Result<SignupResponse>> signup(SignupRequest request) async {
    try {
      final response = await _dio.post(
        'auth/signup',
        data: request.toJson(),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      final data = SignupResponse.fromJson(response.data);
      return Result.success(data);
    } on DioException catch (e) {
      String message = "Unexpected error occurred";

      if (e.response != null && e.response?.data != null) {
        try {
          final json = e.response?.data;
          if (json is Map<String, dynamic> && json.containsKey('message')) {
            message = json['message'];
          } else if (json is String) {
            final decoded = jsonDecode(json);
            message = decoded['message'] ?? message;
          }
        } catch (_) {}
      }
      return Result.failure(Exception(message));
    } catch (e) {
      return Result.failure(Exception("Unexpected error: ${e.toString()}"));
    }
  }
}

// Result helper class
class Result<T> {
  final T? data;
  final Exception? error;

  Result.success(this.data) : error = null;
  Result.failure(this.error) : data = null;

  bool get isSuccess => data != null;
}
