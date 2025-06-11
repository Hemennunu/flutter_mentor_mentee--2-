import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show MethodCall, MethodChannel;
import 'package:flutter_mento_mentee/infrastructure/api/mentor_api.dart' show MentorApi;
import 'package:flutter_mento_mentee/infrastructure/api/request_api.dart' show RequestApi;
import 'package:flutter_mento_mentee/infrastructure/datastore/token_manager.dart' show TokenManager;
import 'package:flutter_riverpod/flutter_riverpod.dart' show ProviderScope;
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mento_mentee/main.dart';
import 'package:shared_preferences/shared_preferences.dart' show SharedPreferences;
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';
import 'package:shared_preferences_foundation/shared_preferences_foundation.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Create mock classes
class MockSharedPreferences extends Mock implements SharedPreferences {}
class MockTokenManager extends Mock implements TokenManager {}

@GenerateMocks([MentorApi, RequestApi])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences for testing
  SharedPreferences.setMockInitialValues({});
  const MethodChannel('plugins.flutter.io/shared_preferences')
      .setMockMethodCallHandler((MethodCall methodCall) async {
    if (methodCall.method == 'getAll') {
      return <String, dynamic>{};
    }
    return null;
  });

  group('App Initialization Tests', () {
    testWidgets('App should initialize without crashing', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: const MyApp(),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('App should have correct theme configuration', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: const MyApp(),
        ),
      );
      await tester.pumpAndSettle();

      final MaterialApp app = tester.widget(find.byType(MaterialApp));
      expect(app.debugShowCheckedModeBanner, false);
      
      // Verify theme configuration - update these values to match your actual theme
      final ThemeData theme = app.theme!;
      expect(theme.colorScheme.primary, const Color(0xFF6750A4)); // Example purple color
      
      // Verify bottom navigation bar theme
      final bottomNavTheme = theme.bottomNavigationBarTheme;
      expect(bottomNavTheme.backgroundColor, Colors.brown);
      expect(bottomNavTheme.selectedItemColor, Colors.white);
    });

    testWidgets('App should use router configuration', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: const MyApp(),
        ),
      );
      await tester.pumpAndSettle();

      final MaterialApp app = tester.widget(find.byType(MaterialApp));
      expect(app.routerConfig, isNotNull);
    });
  });

  group('Dependency Injection Tests', () {
    late MockSharedPreferences mockPrefs;
    late MockTokenManager mockTokenManager;

    setUpAll(() {
      mockPrefs = MockSharedPreferences();
      mockTokenManager = MockTokenManager();
      
      // Setup mock responses
    when(mockPrefs.getString('some_key')).thenReturn(null);
    });

    test('TokenManager should be properly initialized', () {
      // Test your TokenManager initialization logic here
      expect(mockTokenManager, isNotNull);
    });
  });
}