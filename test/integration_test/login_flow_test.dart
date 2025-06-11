import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_mento_mentee/main.dart' as app;
import 'package:flutter/material.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Login screen renders and accepts input', (
    WidgetTester tester,
  ) async {
    app.main();
    await tester.pumpAndSettle();

    // Tap on "Login" from the welcome screen
    final loginButtonOnWelcome = find.byKey(const Key('navigateToLogin'));
    expect(
      loginButtonOnWelcome,
      findsOneWidget,
      reason: 'Expected login button on welcome screen',
    );
    await tester.tap(loginButtonOnWelcome);
    await tester.pumpAndSettle();

    // Now we are on the login screen
    final emailField = find.byKey(const Key('emailField'));
    expect(
      emailField,
      findsOneWidget,
      reason: 'Login screen should show email field',
    );

    final passwordField = find.byKey(const Key('passwordField'));
    final mentorRadio = find.byKey(const Key('mentorRadio'));
    final loginBtn = find.byKey(const Key('loginButton'));

    // Fill and submit the form
    await tester.enterText(emailField, 'nuhamin4@gmail.com');
    await tester.enterText(passwordField, '123456');
    await tester.tap(mentorRadio);
    await tester.pumpAndSettle();
    await tester.tap(loginBtn);
    await tester.pumpAndSettle();

    // Expect navigation or some post-login indicator (you can add another check here)
  });
}
