import 'package:dio/dio.dart';
import 'package:flutter_mento_mentee/infrastructure/api/task_api.dart';
import 'package:flutter_mento_mentee/infrastructure/models/task/create_task.dart';

class TaskRepository {
  final TaskApi _api;

  TaskRepository(this._api);

  Future<CreateTaskRequest> createTask(CreateTaskRequest request, String token) async {
    final response = await _api.createTask(request, token);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return CreateTaskRequest.fromJson(response.data);
    } else {
      throw Exception('Failed to create task: ${response.statusCode}');
    }
  }

  Future<List<AssignedTaskResponse>> getAssignedTasks(String token) async {
    final response = await _api.getAssignedTasks(token);
    if (response.statusCode == 200) {
      return (response.data as List)
          .map((json) => AssignedTaskResponse.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to fetch assigned tasks: ${response.statusCode}');
    }
  }

  Future<List<AssignedTaskResponse>> fetchMenteeTasks(String token) async {
    final response = await _api.fetchMenteeTasks(token);
    if (response.statusCode == 200) {
      return (response.data as List)
          .map((json) => AssignedTaskResponse.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to fetch mentee tasks: ${response.statusCode}');
    }
  }

  Future<bool> deleteTaskById(String taskId, String token) async {
    try {
      final response = await _api.deleteTaskById(taskId, token);
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('Delete task error: $e');
      return false;
    }
  }

  Future<AssignedTaskResponse?> updateTaskById(String taskId, UpdateTaskRequest request, String token) async {
    try {
      final response = await _api.updateTaskById(taskId, request, token);
      if (response.statusCode == 200) {
        return AssignedTaskResponse.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      print('Update task error: $e');
      return null;
    }
  }

  Future<AssignedTaskResponse?> toggleTaskCompletion(String taskId, String token) async {
    try {
      final response = await _api.toggleTaskCompletion(taskId, token);
      if (response.statusCode == 200) {
        return AssignedTaskResponse.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      print('Toggle task completion error: $e');
      return null;
    }
  }
}
