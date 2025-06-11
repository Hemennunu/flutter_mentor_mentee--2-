class CreateMentorshipRequest {
  final String startDate;
  final String endDate;
  final String mentorshipTopic;
  final String additionalNotes;
  final String mentorId;
  final String status;

  CreateMentorshipRequest({
    required this.startDate,
    required this.endDate,
    required this.mentorshipTopic,
    required this.additionalNotes,
    required this.mentorId,
    this.status = "pending",
  }) {
    // Validate constructor arguments
    if (startDate.isEmpty) throw ArgumentError('startDate cannot be empty');
    if (endDate.isEmpty) throw ArgumentError('endDate cannot be empty');
    if (mentorshipTopic.isEmpty) {
      throw ArgumentError('mentorshipTopic cannot be empty');
    }
    if (mentorId.isEmpty) throw ArgumentError('mentorId cannot be empty');
  }

  factory CreateMentorshipRequest.fromJson(Map<String, dynamic> json) {
    return CreateMentorshipRequest(
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      mentorshipTopic: json['mentorshipTopic'] as String,
      additionalNotes: json['additionalNotes'] as String,
      mentorId: json['mentorId'] as String,
      status: json['status'] as String? ?? "pending",
    );
  }

  Map<String, dynamic> toJson() => {
    'startDate': startDate,
    'endDate': endDate,
    'mentorshipTopic': mentorshipTopic,
    'additionalNotes': additionalNotes,
    'mentorId': mentorId,
    'status': status,
  };

  @override
  String toString() {
    return 'CreateMentorshipRequest(startDate: $startDate, endDate: $endDate, '
        'mentorshipTopic: $mentorshipTopic, additionalNotes: $additionalNotes, '
        'mentorId: $mentorId, status: $status)';
  }
}

class FetchedMentorshipRequest {
  final String id;
  final String startDate;
  final String endDate;
  final String mentorshipTopic;
  final String additionalNotes;
  final String mentorId;
  final String status;
  final String menteeId;
  final String menteeName;

  FetchedMentorshipRequest({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.mentorshipTopic,
    required this.additionalNotes,
    required this.mentorId,
    required this.status,
    required this.menteeId,
    required this.menteeName,
  }) {
    // Only validate if not created from JSON
    if (!_isFromJson) {
      if (id.isEmpty) throw ArgumentError('id cannot be empty');
      if (startDate.isEmpty) throw ArgumentError('startDate cannot be empty');
      if (endDate.isEmpty) throw ArgumentError('endDate cannot be empty');
      if (mentorshipTopic.isEmpty) {
        throw ArgumentError('mentorshipTopic cannot be empty');
      }
      if (mentorId.isEmpty) throw ArgumentError('mentorId cannot be empty');
      if (menteeId.isEmpty) throw ArgumentError('menteeId cannot be empty');
      if (status.isEmpty) throw ArgumentError('status cannot be empty');
      if (menteeName.isEmpty) throw ArgumentError('menteeName cannot be empty');
    }
  }

  // Flag to track if object is created from JSON
  static bool _isFromJson = false;

  factory FetchedMentorshipRequest.fromJson(Map<String, dynamic> json) {
    _isFromJson = true;
    final request = FetchedMentorshipRequest(
      id: json['_id']?.toString() ?? '',
      startDate: json['startDate']?.toString() ?? '',
      endDate: json['endDate']?.toString() ?? '',
      mentorshipTopic: json['mentorshipTopic']?.toString() ?? '',
      additionalNotes: json['additionalNotes']?.toString() ?? '',
      mentorId: json['mentorId']?.toString() ?? '',
      status: json['status']?.toString() ?? 'pending',
      menteeId: json['menteeId']?.toString() ?? '',
      menteeName: json['menteeName']?.toString() ?? '',
    );
    _isFromJson = false;
    return request;
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'startDate': startDate,
    'endDate': endDate,
    'mentorshipTopic': mentorshipTopic,
    'additionalNotes': additionalNotes,
    'mentorId': mentorId,
    'status': status,
    'menteeId': menteeId,
    'menteeName': menteeName,
  };


  @override
  String toString() {
    return 'FetchedMentorshipRequest(id: $id, startDate: $startDate, endDate: $endDate, '
        'mentorshipTopic: $mentorshipTopic, additionalNotes: $additionalNotes, '
        'mentorId: $mentorId, status: $status, menteeId: $menteeId, '
        'menteeName: $menteeName)';
  }
}

class UpdateMentorshipRequest {
  final String startDate;
  final String endDate;
  final String mentorshipTopic;
  final String additionalNotes;
  final String mentorId;

  UpdateMentorshipRequest({
    required this.startDate,
    required this.endDate,
    required this.mentorshipTopic,
    required this.additionalNotes,
    required this.mentorId,
  }) {
    // Validate constructor arguments
    if (startDate.isEmpty) throw ArgumentError('startDate cannot be empty');
    if (endDate.isEmpty) throw ArgumentError('endDate cannot be empty');
    if (mentorshipTopic.isEmpty) {
      throw ArgumentError('mentorshipTopic cannot be empty');
    }
    if (mentorId.isEmpty) throw ArgumentError('mentorId cannot be empty');
  }

  factory UpdateMentorshipRequest.fromJson(Map<String, dynamic> json) {
    return UpdateMentorshipRequest(
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      mentorshipTopic: json['mentorshipTopic'] as String,
      additionalNotes: json['additionalNotes'] as String,
      mentorId: json['mentorId'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'startDate': startDate,
    'endDate': endDate,
    'mentorshipTopic': mentorshipTopic,
    'additionalNotes': additionalNotes,
    'mentorId': mentorId,
  };

  @override
  String toString() {
    return 'UpdateMentorshipRequest(startDate: $startDate, endDate: $endDate, '
        'mentorshipTopic: $mentorshipTopic, additionalNotes: $additionalNotes, '
        'mentorId: $mentorId)';
  }
}

class UpdateMentorshipStatus {
  final String status;

  UpdateMentorshipStatus({required this.status}) {
    // Validate constructor arguments
    if (status.isEmpty) throw ArgumentError('status cannot be empty');
  }

  factory UpdateMentorshipStatus.fromJson(Map<String, dynamic> json) {
    return UpdateMentorshipStatus(
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
  };

  @override
  String toString() {
    return 'UpdateMentorshipStatus(status: $status)';
  }
}