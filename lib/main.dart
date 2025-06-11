// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_mento_mentee/domain/repositories/request_repository.dart';
import 'package:flutter_mento_mentee/infrastructure/api/mentor_api.dart';
import 'package:flutter_mento_mentee/infrastructure/api/request_api.dart';
import 'package:flutter_mento_mentee/infrastructure/datastore/token_manager.dart';
import 'package:flutter_mento_mentee/infrastructure/repository/mentor_repository_impl.dart';
import 'package:flutter_mento_mentee/infrastructure/repository/request_repository_impl.dart';
import 'package:flutter_mento_mentee/provides/shared_preferences_provider.dart';
import 'package:flutter_mento_mentee/routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/foundation.dart';


// Dependency registration (unchanged)
final sl = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();

  // Initialize SharedPreferences for Riverpod to access later
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        // Override our dummy sharedPreferencesProvider with a real value
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const MyApp(),
    ),
  );
}

Future<void> initDependencies() async {
  final tokenManager = TokenManager(await SharedPreferences.getInstance());
  sl.registerSingleton<TokenManager>(tokenManager);

  final dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.0.2.2:8888',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  dio.interceptors.add(
    LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = sl<TokenManager>().token;
        if (token != null) options.headers['Authorization'] = 'Bearer $token';
        debugPrint('➡️ Request to: ${options.uri}');
        handler.next(options);
      },
      onError: (e, handler) {
        debugPrint('❌ Dio Error: ${e.message}');
        handler.next(e);
      },
    ),
  );

  sl.registerSingleton<Dio>(dio);
  sl.registerLazySingleton<MentorApi>(() => MentorApi(sl<Dio>()));
  sl.registerLazySingleton<RequestApi>(() => RequestApi(sl<Dio>()));
  sl.registerLazySingleton<MentorRepository>(
    () => MentorRepository(sl<MentorApi>()),
  );
  sl.registerLazySingleton<RequestRepository>(
    () => RequestRepositoryImpl(sl<RequestApi>()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Mento Mentee App',
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.brown,
          selectedItemColor: Colors.white,
          unselectedItemColor: const Color.fromARGB(179, 231, 231, 231),
          selectedLabelStyle: const TextStyle(color: Colors.white),
          unselectedLabelStyle: const TextStyle(color: Colors.white70),
        ),
      ),
    );
  }
}
