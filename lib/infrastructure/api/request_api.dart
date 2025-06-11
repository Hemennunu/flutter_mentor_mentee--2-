import 'package:dio/dio.dart';
import 'package:flutter_mento_mentee/infrastructure/models/mentor/create_mentorship_request.dart';

class RequestApi {
  final Dio _dio;

  RequestApi(this._dio);

  Future<CreateMentorshipRequest> sendRequest(CreateMentorshipRequest request) async {
    try {
      final response = await _dio.post(
        '/mentorship-requests',
        data: request.toJson(),
      );
      return CreateMentorshipRequest.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to send request: ${e.response?.data ?? e.message}');
    }
  }

  Future<List<FetchedMentorshipRequest>> getAllRequests() async {
    try {
      final response = await _dio.get('/mentorship-requests');
      return (response.data as List)
          .map((json) => FetchedMentorshipRequest.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw Exception('Failed to get all requests: ${e.response?.data ?? e.message}');
    }
  }

  Future<bool> deleteRequest(String requestId) async {
    try {
      await _dio.delete('/mentorship-requests/$requestId');
      return true;
    } on DioException catch (e) {
      throw Exception('Failed to delete request: ${e.response?.data ?? e.message}');
    }
  }

  Future<FetchedMentorshipRequest> updateRequest(
      String requestId,
      UpdateMentorshipRequest request,
      ) async {
    try {
      final response = await _dio.patch(
        '/mentorship-requests/$requestId',
        data: request.toJson(),
      );
      return FetchedMentorshipRequest.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to update request: ${e.response?.data ?? e.message}');
    }
  }

  Future<List<FetchedMentorshipRequest>> getAllRequestsSentByMentees() async {
    try {
      final response = await _dio.get('/mentorship-requests/mentors/sent');
      return (response.data as List)
          .map((json) => FetchedMentorshipRequest.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw Exception('Failed to get requests sent by mentees: ${e.response?.data ?? e.message}');
    }
  }

  Future<FetchedMentorshipRequest> updateRequestStatus(
      String requestId,
      UpdateMentorshipStatus statusUpdate,
      ) async {
    try {
      final response = await _dio.patch(
        '/mentorship-requests/status/change/$requestId',
        data: statusUpdate.toJson(),
      );
      return FetchedMentorshipRequest.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to update request status: ${e.response?.data ?? e.message}');
    }
  }

  Future<List<FetchedMentorshipRequest>> getAcceptedRequestsForMentees() async {
    try {
      final response = await _dio.get('/mentorship-requests/mentees/accepted');
      return (response.data as List)
          .map((json) => FetchedMentorshipRequest.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw Exception('Failed to get accepted requests for mentees: ${e.response?.data ?? e.message}');
    }
  }
}