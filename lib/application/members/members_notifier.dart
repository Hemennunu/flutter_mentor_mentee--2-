// members_notifier.dart
import 'package:flutter_mento_mentee/api_providers.dart' show mentorRepositoryProvider;
import 'package:flutter_mento_mentee/infrastructure/repository/mentor_repository_impl.dart';
import 'package:flutter_mento_mentee/infrastructure/models/mentor/mentor_dto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'members_notifier.g.dart';



/// This becomes an AsyncNotifier<List<Mentor>> under the hood.
@riverpod
class MembersNotifier extends _$MembersNotifier {
  @override
  Future<List<Mentor>> build() async {
    final repo = ref.read(mentorRepositoryProvider);
    return repo.fetchMentors();
  }

  /// Refreshes the mentors
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    final repo = ref.read(mentorRepositoryProvider);
    state = await AsyncValue.guard(() => repo.fetchMentors());
  }
}