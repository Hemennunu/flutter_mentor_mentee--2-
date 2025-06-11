import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'dart:async';
import 'package:flutter_mento_mentee/infrastructure/models/mentor/create_mentorship_request.dart';
import 'package:flutter_mento_mentee/domain/repositories/request_repository.dart';

class MentorshipRequestProvider with ChangeNotifier {
  final RequestRepository repository;
  final Duration _requestTimeout = const Duration(seconds: 15);
  int _retryCount = 0;
  final int _maxRetries = 3;

  // State variables
  String? _response;
  List<FetchedMentorshipRequest> _requests = [];
  List<FetchedMentorshipRequest> _acceptedRequests = [];
  String? _errorMessage;
  String? _updateStatus;
  bool _isLoading = false;

  // Getters
  String? get response => _response;
  List<FetchedMentorshipRequest> get requests => _requests;
  List<FetchedMentorshipRequest> get acceptedRequests => _acceptedRequests;
  String? get errorMessage => _errorMessage;
  String? get updateStatus => _updateStatus;
  bool get isLoading => _isLoading;

  MentorshipRequestProvider({required this.repository});

  // Helper method to handle timeout and retry logic
  Future<T> _executeWithRetry<T>(Future<T> Function() action) async {
    try {
      if (_retryCount >= _maxRetries) {
        throw Exception("Maximum retries reached. Please check your connection.");
      }

      _retryCount++;
      return await action().timeout(
        _requestTimeout,
        onTimeout: () {
          throw TimeoutException('Request timed out after ${_requestTimeout.inSeconds} seconds');
        },
      );
    } catch (e) {
      if (_retryCount < _maxRetries && e is TimeoutException) {
        return _executeWithRetry(action);
      }
      rethrow;
    } finally {
      _retryCount = 0; // Reset retry count after operation completes
    }
  }

  // Send mentorship request
  Future<bool> sendMentorshipRequest(CreateMentorshipRequest request) async {
    try {
      _resetState();
      _isLoading = true;
      notifyListeners();

      await _executeWithRetry(() => repository.sendRequest(request));
      _response = "Request sent successfully";
      return true;
    } on TimeoutException catch (e) {
      _errorMessage = "Request timed out. Please try again.";
      debugPrint('Timeout in sendMentorshipRequest: $e');
    } on DioException catch (e) {
      _errorMessage = _handleDioError(e);
      debugPrint('DioError in sendMentorshipRequest: $e');
    } catch (e) {
      _errorMessage = "Failed to send request: ${e.toString().replaceAll('Exception: ', '')}";
      debugPrint('Error in sendMentorshipRequest: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return false;
  }

  // Fetch all requests
  Future<void> fetchAllRequests() async {
    try {
      _resetState();
      _isLoading = true;
      notifyListeners();

      _requests = await _executeWithRetry(() => repository.getAllRequests());
    } on TimeoutException catch (e) {
      _errorMessage = "Request timed out. Please try again.";
      debugPrint('Timeout in fetchAllRequests: $e');
    } on DioException catch (e) {
      _errorMessage = _handleDioError(e);
      debugPrint('DioError in fetchAllRequests: $e');
    } catch (e) {
      _errorMessage = "Failed to load requests: ${e.toString().replaceAll('Exception: ', '')}";
      debugPrint('Error in fetchAllRequests: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch all requests sent by mentees
  Future<void> fetchAllRequestsSentByMentees() async {
    try {
      _resetState();
      _isLoading = true;
      notifyListeners();

      _requests = await _executeWithRetry(() => repository.getAllRequestsSentByMentees());
    } on TimeoutException catch (e) {
      _errorMessage = "Request timed out. Please try again.";
      debugPrint('Timeout in fetchAllRequestsSentByMentees: $e');
    } on DioException catch (e) {
      _errorMessage = _handleDioError(e);
      debugPrint('DioError in fetchAllRequestsSentByMentees: $e');
    } catch (e) {
      _errorMessage = "Failed to load requests: ${e.toString().replaceAll('Exception: ', '')}";
      debugPrint('Error in fetchAllRequestsSentByMentees: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch accepted requests for mentees
  Future<void> fetchAcceptedRequestsForMentees() async {
    try {
      _resetState();
      _isLoading = true;
      notifyListeners();

      _acceptedRequests = await _executeWithRetry(() => repository.getAcceptedRequestsForMentees());
    } on TimeoutException catch (e) {
      _errorMessage = "Request timed out. Please try again.";
      debugPrint('Timeout in fetchAcceptedRequestsForMentees: $e');
    } on DioException catch (e) {
      _errorMessage = _handleDioError(e);
      debugPrint('DioError in fetchAcceptedRequestsForMentees: $e');
    } catch (e) {
      _errorMessage = "Failed to load accepted requests: ${e.toString().replaceAll('Exception: ', '')}";
      debugPrint('Error in fetchAcceptedRequestsForMentees: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Delete request by ID
  Future<void> deleteRequestById(String requestId) async {
    try {
      _resetState();
      _isLoading = true;
      notifyListeners();

      final success = await _executeWithRetry(() => repository.deleteMentorshipRequest(requestId));
      if (success) {
        _response = "Request deleted successfully";
        await fetchAllRequests(); // Refresh the list
      } else {
        _errorMessage = "Failed to delete request";
      }
    } on TimeoutException catch (e) {
      _errorMessage = "Request timed out. Please try again.";
      debugPrint('Timeout in deleteRequestById: $e');
    } on DioException catch (e) {
      _errorMessage = _handleDioError(e);
      debugPrint('DioError in deleteRequestById: $e');
    } catch (e) {
      _errorMessage = "Failed to delete request: ${e.toString().replaceAll('Exception: ', '')}";
      debugPrint('Error in deleteRequestById: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update mentorship request
  Future<void> updateMentorshipRequestById(
      String requestId,
      UpdateMentorshipRequest updates,
      ) async {
    try {
      _resetState();
      _isLoading = true;
      notifyListeners();

      final result = await _executeWithRetry(() => repository.updateMentorshipRequest(requestId, updates));
      if (result != null) {
        _updateStatus = "Request updated successfully";
        await fetchAllRequests(); // Refresh the list
      } else {
        _updateStatus = "Failed to update request";
      }
    } on TimeoutException catch (e) {
      _updateStatus = "Request timed out. Please try again.";
      debugPrint('Timeout in updateMentorshipRequestById: $e');
    } on DioException catch (e) {
      _updateStatus = _handleDioError(e);
      debugPrint('DioError in updateMentorshipRequestById: $e');
    } catch (e) {
      _updateStatus = "Failed to update request: ${e.toString().replaceAll('Exception: ', '')}";
      debugPrint('Error in updateMentorshipRequestById: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update request status
  Future<void> updateRequestStatus(
      String requestId,
      UpdateMentorshipStatus status,
      ) async {
    try {
      _resetState();
      _isLoading = true;
      notifyListeners();

      await _executeWithRetry(() => repository.updateRequestStatus(requestId, status));
      _updateStatus = "Status updated successfully";
      await fetchAllRequestsSentByMentees(); // Refresh the list
    } on TimeoutException catch (e) {
      _updateStatus = "Request timed out. Please try again.";
      debugPrint('Timeout in updateRequestStatus: $e');
    } on DioException catch (e) {
      _updateStatus = _handleDioError(e);
      debugPrint('DioError in updateRequestStatus: $e');
    } catch (e) {
      _updateStatus = "Failed to update status: ${e.toString().replaceAll('Exception: ', '')}";
      debugPrint('Error in updateRequestStatus: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Handle Dio errors
  String _handleDioError(DioException e) {
    if (e.response != null) {
      switch (e.response?.statusCode) {
        case 400:
          return "Bad request. Please check your input.";
        case 401:
          return "Session expired. Please log in again.";
        case 403:
          return "You don't have permission for this action.";
        case 404:
          return "Resource not found.";
        case 500:
          return "Server error. Please try again later.";
        default:
          return "Network error occurred (${e.response?.statusCode}).";
      }
    }
    return "Network error: ${e.message ?? 'No internet connection'}";
  }

  // Reset state before new operations
  void _resetState() {
    _response = null;
    _errorMessage = null;
    _updateStatus = null;
  }
}