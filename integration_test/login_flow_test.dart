import 'package:flutter/material.dart'; // Needed for Key, Text, Widgets, etc.
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_mento_mentee/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Login screen renders and accepts input', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // First verify we're on the welcome screen
    expect(find.text('Welcome to Mentor Mentee'), findsOneWidget, reason: 'Should be on welcome screen');
    
    // Tap the login button to navigate to login screen
    final loginButton = find.byKey(const Key('navigateToLogin'));
    expect(loginButton, findsOneWidget, reason: 'Login button should be visible on welcome screen');
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    // Now verify we're on the login screen
    expect(find.text('Login'), findsWidgets, reason: 'Should be on login screen');
    
    // Then verify the form fields exist
    final emailField = find.byKey(const Key('emailField'));
    expect(emailField, findsOneWidget, reason: 'Email field should be visible');
    
    final passwordField = find.byKey(const Key('passwordField'));
    expect(passwordField, findsOneWidget, reason: 'Password field should be visible');
    
    final mentorRadio = find.byKey(const Key('mentorRadio'));
    expect(mentorRadio, findsOneWidget, reason: 'Mentor radio button should be visible');

    // Fill in the form
    await tester.enterText(emailField, 'mentor@example.com');
    await tester.enterText(passwordField, 'password123');
    await tester.tap(mentorRadio);
    await tester.pump();

    // Submit the form
    final loginSubmitButton = find.byKey(const Key('loginButton'));
    expect(loginSubmitButton, findsOneWidget, reason: 'Login button should be visible');
    await tester.tap(loginSubmitButton);
    
    // Wait for navigation
    await tester.pump();
    await tester.pump(const Duration(seconds: 2)); // Allow time for navigation

    // Verify navigation to mentor home
    expect(find.text('Home'), findsOneWidget, reason: 'Should be on mentor home screen');
  });
} 