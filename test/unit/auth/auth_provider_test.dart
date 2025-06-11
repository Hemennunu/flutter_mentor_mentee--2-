import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mento_mentee/provides/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late ProviderContainer container;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockAuthRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('AuthProvider Tests', () {
    test('initial state should be unauthenticated', () {
      final authState = container.read(authProvider);
      expect(authState, equals(AuthState.unauthenticated));
    });

    test('login success should update state to authenticated', () async {
      when(() => mockAuthRepository.login(any(), any()))
          .thenAnswer((_) async => User(id: '1', email: 'test@test.com'));

      await container.read(authProvider.notifier).login('test@test.com', 'password');

      expect(container.read(authProvider), equals(AuthState.authenticated));
    });

    test('login failure should update state to error', () async {
      when(() => mockAuthRepository.login(any(), any()))
          .thenThrow(Exception('Invalid credentials'));

      try {
        await container.read(authProvider.notifier).login('test@test.com', 'wrong_password');
      } catch (e) {
        // Expected exception
      }

      expect(container.read(authProvider), equals(AuthState.error));
    });
  });
} 