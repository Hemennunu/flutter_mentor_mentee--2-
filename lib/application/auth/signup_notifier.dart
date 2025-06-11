// lib/application/auth/signup_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_mento_mentee/infrastructure/api/signup_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'signup_notifier.g.dart';

@riverpod
class SignupNotifier extends _$SignupNotifier {
  @override
  Future<void> build() async {
    // no initialization required
  }

  Future<void> signup({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required String role,
    required String skill,
  }) async {
    state = const AsyncValue.loading();

    try {
      // validation
      if (name.isEmpty ||
          email.isEmpty ||
          password.isEmpty ||
          confirmPassword.isEmpty ||
          role.isEmpty ||
          skill.isEmpty) {
        throw Exception('All fields are required');
      }
      if (password != confirmPassword) {
        throw Exception('Passwords do not match');
      }

      // API call
      final result = await SignupApi.signup(
        SignupRequest(
          name: name,
          email: email,
          password: password,
          role: role,
          skill: skill,
        ),
      );

      if (result.isSuccess) {
        state = const AsyncValue.data(null);
      } else {
        state = AsyncValue.error(
          result.error ?? 'Signup failed',
          StackTrace.current,
        );
      }
    } catch (e) {
      state = AsyncValue.error(
        e.toString().replaceFirst('Exception: ', ''),
        StackTrace.current,
      );
    }
  }
}
