import 'package:flutter_mento_mentee/infrastructure/models/mentor/create_mentorship_request.dart';

abstract class RequestRepository {
  Future<CreateMentorshipRequest> sendRequest(CreateMentorshipRequest request);
  Future<List<FetchedMentorshipRequest>> getAllRequests();
  Future<bool> deleteMentorshipRequest(String requestId);
  Future<FetchedMentorshipRequest?> updateMentorshipRequest(
      String requestId,
      UpdateMentorshipRequest updates,
      );
  Future<List<FetchedMentorshipRequest>> getAllRequestsSentByMentees();
  Future<FetchedMentorshipRequest> updateRequestStatus(
      String requestId,
      UpdateMentorshipStatus status,
      );
  Future<List<FetchedMentorshipRequest>> getAcceptedRequestsForMentees();
}