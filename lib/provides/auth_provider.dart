import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_mento_mentee/infrastructure/api/login_api.dart';
import 'package:flutter_mento_mentee/infrastructure/datastore/token_manager.dart';
import 'package:get_it/get_it.dart';

// Auth State
enum AuthState {
  unauthenticated,
  authenticated,
  error,
}

// User Model
class User {
  final String id;
  final String email;

  User({required this.id, required this.email});
}

// Auth Repository Interface
abstract class AuthRepository {
  Future<User> login(String email, String password);
}

// Auth Repository Implementation
class AuthRepositoryImpl implements AuthRepository {
  final TokenManager _tokenManager;

  AuthRepositoryImpl(this._tokenManager);

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await LoginApi.login(
        email: email,
        password: password,
        role: 'user', // Default role, can be changed based on your needs
      );
      await _tokenManager.saveToken(response.token);
      return User(id: '1', email: email); // You might want to get the actual user ID from the response
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }
}

// Providers
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final tokenManager = GetIt.I<TokenManager>();
  return AuthRepositoryImpl(tokenManager);
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});

// Auth Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(AuthState.unauthenticated);

  Future<void> login(String email, String password) async {
    try {
      await _repository.login(email, password);
      state = AuthState.authenticated;
    } catch (e) {
      state = AuthState.error;
      rethrow;
    }
  }
} 