import 'package:dio/dio.dart';
import 'package:flutter_mento_mentee/infrastructure/models/task/create_task.dart';

class TaskApi {
  final Dio _dio;

  TaskApi(this._dio);

  Future<Response> createTask(CreateTaskRequest taskRequest, String token) async {
    return await _dio.post(
      '/tasks',
      data: taskRequest.toJson(),
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );
  }

  Future<Response> getAssignedTasks(String token) async {
    return await _dio.get(
      '/tasks',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );
  }

  Future<Response> fetchMenteeTasks(String token) async {
    return await _dio.get(
      '/tasks/mentee/assigned',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );
  }

  Future<Response> deleteTaskById(String taskId, String token) async {
    return await _dio.delete(
      '/tasks/$taskId',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );
  }

  Future<Response> updateTaskById(String taskId, UpdateTaskRequest updateRequest, String token) async {
    return await _dio.patch(
      '/tasks/$taskId',
      data: updateRequest.toJson(),
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );
  }

  Future<Response> toggleTaskCompletion(String taskId, String token) async {
    return await _dio.patch(
      '/tasks/$taskId/status',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );
  }
}
