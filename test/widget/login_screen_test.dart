import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mento_mentee/application/auth/login_notifier.dart';
import 'package:flutter_mento_mentee/presentation/auth/login/login_screen.dart';
import 'package:go_router/go_router.dart';

class TestLoginNotifier extends LoginNotifier {
  bool wasCalled = false;
  bool shouldFail = false;
  String errorMessage = 'Invalid login';
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

    if (shouldFail) {
      state = AsyncValue.error(errorMessage, StackTrace.current);
      return;
    }

    state = const AsyncValue.data(null);
  }

  @override
  Future<void> build() async {}
}

void main() {
  testWidgets('login button invokes notifier.login on valid input', (WidgetTester tester) async {
    final testNotifier = TestLoginNotifier();

    final testRouter = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => LoginScreen(
            onNavigateToSignup: () {},
            onLoginSuccess: (_) {},
          ),
        ),
        GoRoute(path: '/mentor-home', builder: (_, __) => const Placeholder()),
        GoRoute(path: '/mentee-home', builder: (_, __) => const Placeholder()),
      ],
    );

    final container = ProviderContainer(overrides: [
      loginNotifierProvider.overrideWith(() => testNotifier),
    ]);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          routerConfig: testRouter,
        ),
      ),
    );

    const email = 'test@example.com';
    const password = 'password123';

    await tester.enterText(find.byKey(const Key('emailField')), email);
    await tester.enterText(find.byKey(const Key('passwordField')), password);
    await tester.tap(find.byKey(const Key('mentorRadio')));
    await tester.pump();

    await tester.tap(find.byKey(const Key('loginButton')));
    await tester.pumpAndSettle();

    expect(testNotifier.wasCalled, true);
    expect(testNotifier.capturedEmail, email);
    expect(testNotifier.capturedPassword, password);
    expect(testNotifier.capturedRole, 'mentor');
  });

  testWidgets('navigates to /mentee-home when mentee logs in', (WidgetTester tester) async {
    final testNotifier = TestLoginNotifier();

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => LoginScreen(
            onNavigateToSignup: () {},
            onLoginSuccess: (_) {},
          ),
        ),
        GoRoute(path: '/mentor-home', builder: (_, __) => const Placeholder()),
        GoRoute(path: '/mentee-home', builder: (_, __) => const Placeholder(key: Key('mentee-home'))),
      ],
    );

    final container = ProviderContainer(overrides: [
      loginNotifierProvider.overrideWith(() => testNotifier),
    ]);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: router),
      ),
    );

    await tester.enterText(find.byKey(const Key('emailField')), 'mentee@test.com');
    await tester.enterText(find.byKey(const Key('passwordField')), 'password123');
    await tester.tap(find.byKey(const Key('menteeRadio')));
    await tester.pump();

    await tester.tap(find.byKey(const Key('loginButton')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('mentee-home')), findsOneWidget);
  });

  testWidgets('shows validation error when email or password is empty', (WidgetTester tester) async {
    final testNotifier = TestLoginNotifier();

    final container = ProviderContainer(overrides: [
      loginNotifierProvider.overrideWith(() => testNotifier),
    ]);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: Scaffold(
            body: LoginScreen(
              onNavigateToSignup: () {},
              onLoginSuccess: (_) {},
            ),
          ),
        ),
      ),
    );

    // Select a role so form validation actually runs
    await tester.tap(find.byKey(const Key('mentorRadio')));
    await tester.pump();

    // Leave inputs empty and tap login
    await tester.tap(find.byKey(const Key('loginButton')));
    await tester.pump();

    // Check for validation errors
    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);
    expect(testNotifier.wasCalled, false);
  });

  testWidgets('shows role error when no role is selected', (WidgetTester tester) async {
    final testNotifier = TestLoginNotifier();

    final container = ProviderContainer(overrides: [
      loginNotifierProvider.overrideWith(() => testNotifier),
    ]);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: Scaffold(
            body: LoginScreen(
              onNavigateToSignup: () {},
              onLoginSuccess: (_) {},
            ),
          ),
        ),
      ),
    );

    // Fill valid inputs but skip role
    await tester.enterText(find.byKey(const Key('emailField')), 'test@example.com');
    await tester.enterText(find.byKey(const Key('passwordField')), 'password123');
    await tester.tap(find.byKey(const Key('loginButton')));
    await tester.pump();

    // Check for the snackbar message
    expect(find.text('Please select a role'), findsOneWidget);
  });

  testWidgets('shows snackbar on login failure', (WidgetTester tester) async {
    final testNotifier = TestLoginNotifier()..shouldFail = true;

    final container = ProviderContainer(overrides: [
      loginNotifierProvider.overrideWith(() => testNotifier),
    ]);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: Scaffold(
            body: LoginScreen(
              onNavigateToSignup: () {},
              onLoginSuccess: (_) {},
      ),
          ),
        ),
      ),
    );

    await tester.enterText(find.byKey(const Key('emailField')), 'wrong@test.com');
    await tester.enterText(find.byKey(const Key('passwordField')), 'wrongpass');
    await tester.tap(find.byKey(const Key('mentorRadio')));
    await tester.pump();

    await tester.tap(find.byKey(const Key('loginButton')));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Invalid login'), findsOneWidget);
  });
}
