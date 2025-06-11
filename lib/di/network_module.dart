// import 'package:dio/dio.dart';
// import 'package:get_it/get_it.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../data/api/task_api.dart';
// import '../data/api/mentor_api.dart';
// import '../data/api/request_api.dart';
// import '../data/repository/task_repository_impl.dart';
// import '../data/repository/mentor_repository_impl.dart';
// import '../data/repository/request_repository_impl.dart';
// import '../data/datastore/token_manager.dart';
//
// final sl = GetIt.instance;
//
// Future<void> initNetworkModule() async {
//   // SharedPreferences
//   final prefs = await SharedPreferences.getInstance();
//   sl.registerSingleton<SharedPreferences>(prefs);
//
//   // Token Manager
//   final tokenManager = TokenManager(prefs);
//   sl.registerSingleton<TokenManager>(tokenManager);
//
//   // Dio Client with Auth Interceptor
//   final dio = Dio(BaseOptions(
//     baseUrl: 'http://10.0.2.2:8888/',
//     headers: {'Content-Type': 'application/json'},
//   ));
//
//   dio.interceptors.add(
//     InterceptorsWrapper(
//       onRequest: (options, handler) async {
//         final token = await tokenManager.getToken();
//         if (token != null && token.isNotEmpty) {
//           options.headers['Authorization'] = 'Bearer $token';
//         }
//         handler.next(options);
//       },
//     ),
//   );
//
//   sl.registerSingleton<Dio>(dio);
//
//   // APIs
//   final taskApi = TaskApi(dio);
//   final mentorApi = MentorApi(dio);
//   final requestApi = RequestApi(dio);
//
//   sl.registerSingleton<TaskApi>(taskApi);
//   sl.registerSingleton<MentorApi>(mentorApi);
//   sl.registerSingleton<RequestApi>(requestApi);
//
//   // Repositories — fixed with named parameters
//   sl.registerSingleton<TaskRepository>(
//     TaskRepository(taskApi: taskApi),
//   );
//
//   sl.registerSingleton<MentorRepository>(
//     MentorRepository(mentorApi: mentorApi),
//   );
//
//   sl.registerSingleton<RequestRepository>(
//     RequestRepository(requestApi: requestApi),
//   );
// }
