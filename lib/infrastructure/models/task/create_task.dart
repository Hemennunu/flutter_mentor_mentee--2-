class CreateTaskRequest {
  final String taskTitle;
  final String description;
  final String dueDate;
  final String priority;
  final String menteeId;

  CreateTaskRequest({
    required this.taskTitle,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.menteeId,
  });

  Map<String, dynamic> toJson() {
    return {
      "taskTitle": taskTitle,
      "description": description,
      "dueDate": dueDate,
      "priority": priority,
      "menteeId": menteeId,
    };
  }

  factory CreateTaskRequest.fromJson(Map<String, dynamic> json) {
    return CreateTaskRequest(
      taskTitle: json['taskTitle'],
      description: json['description'],
      dueDate: json['dueDate'],
      priority: json['priority'],
      menteeId: json['menteeId'],
    );
  }
}

class AssignedTaskResponse {
  final String id;
  final String taskTitle;
  final String description;
  final String dueDate;
  final String priority;
  final String mentorId;
  final String menteeId;
  final bool isCompleted;

  AssignedTaskResponse({
    required this.id,
    required this.taskTitle,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.mentorId,
    required this.menteeId,
    required this.isCompleted,
  });

  factory AssignedTaskResponse.fromJson(Map<String, dynamic> json) {
    return AssignedTaskResponse(
      id: json['_id'],
      taskTitle: json['taskTitle'],
      description: json['description'],
      dueDate: json['dueDate'],
      priority: json['priority'],
      mentorId: json['mentorId'],
      menteeId: json['menteeId'],
      isCompleted: json['isCompleted'],
    );
  }
}

class UpdateTaskRequest {
  final String? taskTitle;
  final String? description;
  final String? dueDate;
  final String? priority;
  final bool? isCompleted;

  UpdateTaskRequest({
    this.taskTitle,
    this.description,
    this.dueDate,
    this.priority,
    this.isCompleted,
  });

  Map<String, dynamic> toJson() {
    return {
      if (taskTitle != null) "taskTitle": taskTitle,
      if (description != null) "description": description,
      if (dueDate != null) "dueDate": dueDate,
      if (priority != null) "priority": priority,
      if (isCompleted != null) "isCompleted": isCompleted,
    };
  }
}
