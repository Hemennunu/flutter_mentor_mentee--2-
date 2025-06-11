import 'package:flutter/foundation.dart';
import 'package:flutter_mento_mentee/infrastructure/api/mentor_api.dart';
import 'package:flutter_mento_mentee/infrastructure/models/mentor/mentor_dto.dart';

class MentorRepository {
  final MentorApi _mentorApi;

  MentorRepository(this._mentorApi);

  Future<List<Mentor>> fetchMentors() async {
    try {
      return await _mentorApi.getMentors();
    } catch (e) {
      debugPrint('MentorRepository Error: ${e.toString()}');
      rethrow;
    }
  }
}