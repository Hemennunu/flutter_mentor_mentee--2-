import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_mento_mentee/infrastructure/datastore/token_manager.dart';
import 'package:flutter_mento_mentee/infrastructure/repository/task_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter_mento_mentee/api_providers.dart';
import 'package:flutter_mento_mentee/infrastructure/models/task/create_task.dart';

part 'task_notifier.g.dart';

@riverpod
class TaskNotifier extends _$TaskNotifier {
  static const _timeout = Duration(seconds: 15);
  static const _maxRetries = 3;

  TaskRepository get _repo => ref.read(taskRepositoryProvider);
  TokenManager get _tokenMgr => ref.read(tokenManagerProvider);

  /// On first watch, load the assigned tasks.
  @override
  Future<List<AssignedTaskResponse>> build() async {
    return _withRetry(() => _repo.getAssignedTasks(_token()));
  }

  /// Retry + timeout helper
  Future<T> _withRetry<T>(Future<T> Function() action) async {
    var attempts = 0;
    while (true) {
      try {
        return await action().timeout(_timeout);
      } on TimeoutException {
        if (++attempts >= _maxRetries) {
          throw Exception('Timed out after $_timeout');
        }
      }
    }
  }

  /// Gets the current JWT token
  String _token() {
    final t = _tokenMgr.token;
    if (t == null || t.isEmpty) {
      throw Exception('No auth token available');
    }
    return t;
  }

  /// Refresh the assigned‐tasks list
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build());
  }

  /// Create a new task then reload
  Future<void> createTask(CreateTaskRequest req) async {
    state = const AsyncValue.loading();
    try {
      await _withRetry(() => _repo.createTask(req, _token()));
      state = await AsyncValue.guard(() => build());
    } on DioException catch (e) {
      state = AsyncValue.error(_mapDioError(e), e.stackTrace);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Update an existing task then reload
  Future<void> updateTask(String id, UpdateTaskRequest req) async {
    state = const AsyncValue.loading();
    try {
      final updated = await _withRetry(
        () => _repo.updateTaskById(id, req, _token()),
      );
      if (updated == null) throw Exception('Update failed');
      state = await AsyncValue.guard(() => build());
    } on DioException catch (e) {
      state = AsyncValue.error(_mapDioError(e), e.stackTrace);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Delete a task then reload
  Future<void> deleteTask(String id) async {
    state = const AsyncValue.loading();
    try {
      final ok = await _withRetry(() => _repo.deleteTaskById(id, _token()));
      if (!ok) throw Exception('Delete failed');
      state = await AsyncValue.guard(() => build());
    } on DioException catch (e) {
      state = AsyncValue.error(_mapDioError(e), e.stackTrace);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Toggle completion then reload
  Future<void> toggleTaskCompletion(String id) async {
    state = const AsyncValue.loading();
    try {
      final toggled = await _withRetry(
        () => _repo.toggleTaskCompletion(id, _token()),
      );
      if (toggled == null) throw Exception('Toggle failed');
      state = await AsyncValue.guard(() => build());
    } on DioException catch (e) {
      state = AsyncValue.error(_mapDioError(e), e.stackTrace);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Fetch only mentee‐assigned tasks without replacing the notifier’s type
  Future<List<AssignedTaskResponse>> fetchMenteeTasks() =>
      _withRetry(() => _repo.fetchMenteeTasks(_token()));

  String _mapDioError(DioException e) {
    return switch (e.response?.statusCode) {
      400 => 'Bad request.',
      401 => 'Unauthorized – please log in again.',
      403 => 'Forbidden.',
      404 => 'Not found.',
      500 => 'Server error – try later.',
      _ => e.message ?? 'Network error.',
    };
  }
}
