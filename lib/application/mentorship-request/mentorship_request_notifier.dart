// lib/application/request/mentorship_request_notifier.dart

import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_mento_mentee/api_providers.dart'
    show requestRepositoryProvider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter_mento_mentee/infrastructure/models/mentor/create_mentorship_request.dart';
import 'package:flutter_mento_mentee/domain/repositories/request_repository.dart';
// import 'package:flutter_mento_mentee/infrastructure/models/mentor/fetched_mentorship_request.dart';

part 'mentorship_request_notifier.g.dart';

@riverpod
class MentorshipRequestNotifier extends _$MentorshipRequestNotifier {
  static const _timeout = Duration(seconds: 15);
  static const _maxRetries = 3;

  RequestRepository get _repo => ref.read(requestRepositoryProvider);

  /// The initial load: fetch all requests.
  @override
  Future<List<FetchedMentorshipRequest>> build() async {
    return _withRetry(() => _repo.getAllRequests());
  }

  /// Helper: retry + timeout
  Future<T> _withRetry<T>(Future<T> Function() action) async {
    var attempts = 0;
    while (true) {
      try {
        return await action().timeout(_timeout);
      } on TimeoutException {
        if (++attempts >= _maxRetries) {
          throw Exception('Request timed out after $_timeout');
        }
      }
    }
  }

  /// Refresh the list.
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build());
  }

  /// Send a new mentorship request.
  Future<void> sendRequest(CreateMentorshipRequest r) async {
    state = const AsyncValue.loading();
    try {
      await _withRetry(() => _repo.sendRequest(r));
      // after success, re-fetch
      state = await AsyncValue.guard(() => build());
    } on DioException catch (e) {
      state = AsyncValue.error(_dioMessage(e), e.stackTrace);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> fetchRequestsSentByMentees() async {
    // show loading in UI
    state = const AsyncValue.loading();
    try {
      // call the new repo method with retry+timeout
      final List<FetchedMentorshipRequest> list = await _withRetry(
        () => _repo.getAllRequestsSentByMentees(),
      );
      // push data into state
      state = AsyncValue.data(list);
    } on DioException catch (e) {
      // map Dio errors to user-friendly messages
      state = AsyncValue.error(_dioMessage(e), e.stackTrace);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Delete by ID, then refresh.
  Future<void> deleteById(String id) async {
    state = const AsyncValue.loading();
    try {
      final ok = await _withRetry(() => _repo.deleteMentorshipRequest(id));
      if (!ok) throw Exception('Delete failed');
      state = await AsyncValue.guard(() => build());
    } on DioException catch (e) {
      state = AsyncValue.error(_dioMessage(e), e.stackTrace);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Update details, then refresh.
  Future<void> updateById(String id, UpdateMentorshipRequest updates) async {
    state = const AsyncValue.loading();
    try {
      final updated = await _withRetry(
        () => _repo.updateMentorshipRequest(id, updates),
      );
      if (updated == null) throw Exception('Update failed');
      state = await AsyncValue.guard(() => build());
    } on DioException catch (e) {
      state = AsyncValue.error(_dioMessage(e), e.stackTrace);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Change status, then refresh.
  Future<void> updateStatus(String id, UpdateMentorshipStatus status) async {
    state = const AsyncValue.loading();
    try {
      await _withRetry(() => _repo.updateRequestStatus(id, status));
      state = await AsyncValue.guard(() => build());
    } on DioException catch (e) {
      state = AsyncValue.error(_dioMessage(e), e.stackTrace);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> fetchAcceptedRequests() async {
    state = const AsyncValue.loading();
    try {
      final accepted = await _withRetry(
        () => _repo.getAcceptedRequestsForMentees(),
      );
      state = AsyncValue.data(accepted);
    } on DioException catch (e) {
      state = AsyncValue.error(_dioMessage(e), e.stackTrace);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  String _dioMessage(DioException e) {
    final code = e.response?.statusCode;
    return switch (code) {
      400 => 'Bad request, check your input.',
      401 => 'Session expired, please log in again.',
      403 => 'Forbidden.',
      404 => 'Not found.',
      500 => 'Server error, try later.',
      _ => e.message ?? 'Network error.',
    };
  }
}
