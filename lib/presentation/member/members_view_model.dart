// members_view_model.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_mento_mentee/infrastructure/repository/mentor_repository_impl.dart';
import 'package:flutter_mento_mentee/infrastructure/models/mentor/mentor_dto.dart';

class MembersViewModel with ChangeNotifier {
  final MentorRepository _repository;

  MembersViewModel({required MentorRepository repository}) : _repository = repository;

  List<Mentor> _mentors = [];
  List<Mentor> get mentors => _mentors;

  String? _error;
  String? get error => _error;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchMentors() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final mentors = await _repository.fetchMentors();
      _mentors = mentors;
      debugPrint('Successfully fetched ${mentors.length} mentors');
    } catch (e) {
      _error = e.toString();
      debugPrint('Error fetching mentors: $_error');
      _mentors = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}