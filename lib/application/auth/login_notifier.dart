import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_mento_mentee/infrastructure/api/login_api.dart';
import 'package:flutter_mento_mentee/infrastructure/datastore/token_manager.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

part 'login_notifier.g.dart';

@riverpod
class LoginNotifier extends _$LoginNotifier {
  @override
  Future<void> build() async {
    // No initialization needed
  }

  Future<void> login({
    required String email,
    required String password,
    required String role,
  }) async {
    state = const AsyncValue.loading();

    try {
      // validation
      if (email.isEmpty || password.isEmpty || role.isEmpty) {
        throw Exception('All fields are required');
      }

      // API call
      final response = await LoginApi.login(
        email: email,
        password: password,
        role: role,
      );

      // save token
      await GetIt.I<TokenManager>().saveToken(response.token);

      state = const AsyncValue.data(null);
    } catch (e) {
      String errorMessage = 'Login failed. Please try again.';

      // If it's a DioError (assuming you're using Dio)
      if (e is DioException && e.response != null) {
        final data = e.response?.data;
        if (data is Map<String, dynamic> && data['message'] is List) {
          errorMessage = data['message'].join('\n');
        } else if (data is Map<String, dynamic> && data['message'] is String) {
          errorMessage = data['message'];
        }
      } else if (e is Exception) {
        errorMessage = e.toString().replaceFirst('Exception: ', '');
      }

      state = AsyncValue.error(errorMessage, StackTrace.current);
    }
  }
}
class TestLoginNotifier extends LoginNotifier {
  bool wasCalled = false;
  late String capturedEmail;
  late String capturedPassword;
  late String capturedRole;

  @override
  Future<void> login({
    required String email,
    required String password,
    required String role,
  }) async {
    wasCalled = true;
    capturedEmail = email;
    capturedPassword = password;
    capturedRole = role;
    // simulate success
    state = const AsyncValue.data(null);
  }

  @override
  Future<void> build() async {
    // optional setup if needed
  }
}

