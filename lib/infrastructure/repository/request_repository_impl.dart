import 'package:flutter_mento_mentee/infrastructure/api/request_api.dart';
import 'package:flutter_mento_mentee/infrastructure/models/mentor/create_mentorship_request.dart';
import 'package:flutter_mento_mentee/domain/repositories/request_repository.dart';

class RequestRepositoryImpl implements RequestRepository {
  final RequestApi _api;

  RequestRepositoryImpl(this._api);

  @override
  Future<CreateMentorshipRequest> sendRequest(CreateMentorshipRequest request) async {
    try {
      return await _api.sendRequest(request);
    } catch (e) {
      throw Exception('Failed to send request: $e');
    }
  }

  @override
  Future<List<FetchedMentorshipRequest>> getAllRequests() async {
    try {
      return await _api.getAllRequests();
    } catch (e) {
      throw Exception('Failed to get all requests: $e');
    }
  }

  @override
  Future<bool> deleteMentorshipRequest(String requestId) async {
    try {
      return await _api.deleteRequest(requestId);
    } catch (e) {
      throw Exception('Failed to delete request: $e');
    }
  }

  @override
  Future<FetchedMentorshipRequest?> updateMentorshipRequest(
      String requestId,
      UpdateMentorshipRequest updates,
      ) async {
    try {
      return await _api.updateRequest(requestId, updates);
    } catch (e) {
      throw Exception('Failed to update request: $e');
    }
  }

  @override
  Future<List<FetchedMentorshipRequest>> getAllRequestsSentByMentees() async {
    try {
      return await _api.getAllRequestsSentByMentees();
    } catch (e) {
      throw Exception('Failed to get requests sent by mentees: $e');
    }
  }

  @override
  Future<FetchedMentorshipRequest> updateRequestStatus(
      String requestId,
      UpdateMentorshipStatus status,
      ) async {
    try {
      return await _api.updateRequestStatus(requestId, status);
    } catch (e) {
      throw Exception('Failed to update request status: $e');
    }
  }

  @override
  Future<List<FetchedMentorshipRequest>> getAcceptedRequestsForMentees() async {
    try {
      return await _api.getAcceptedRequestsForMentees();
    } catch (e) {
      throw Exception('Failed to get accepted requests for mentees: $e');
    }
  }

}