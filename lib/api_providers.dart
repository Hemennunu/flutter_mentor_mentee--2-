// api_providers.dart

import 'package:flutter_mento_mentee/domain/repositories/request_repository.dart';
import 'package:flutter_mento_mentee/infrastructure/api/task_api.dart';
import 'package:flutter_mento_mentee/infrastructure/datastore/token_manager.dart';
import 'package:flutter_mento_mentee/infrastructure/repository/task_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'infrastructure/api/mentor_api.dart';
import 'infrastructure/api/request_api.dart';
import 'infrastructure/repository/mentor_repository_impl.dart';
import 'infrastructure/repository/request_repository_impl.dart';

final dioProvider = Provider<Dio>((ref) {
  // Assuming you've registered Dio via GetIt
  return GetIt.instance<Dio>();
});

final mentorApiProvider = Provider<MentorApi>((ref) {
  return MentorApi(ref.watch(dioProvider));
});

final mentorRepositoryProvider = Provider<MentorRepository>((ref) {
  return MentorRepository(ref.watch(mentorApiProvider));
});

// Similarly for request
final requestApiProvider = Provider<RequestApi>((ref) {
  return RequestApi(ref.watch(dioProvider));
});

final requestRepositoryProvider = Provider<RequestRepository>((ref) {
  return RequestRepositoryImpl(ref.watch(requestApiProvider));
});


final tokenManagerProvider = Provider<TokenManager>(
  (ref) => GetIt.I<TokenManager>(),
);

final taskApiProvider = Provider<TaskApi>(
  (ref) => TaskApi(ref.watch(dioProvider)),
);

final taskRepositoryProvider = Provider<TaskRepository>(
  (ref) => TaskRepository(ref.watch(taskApiProvider)),
);
