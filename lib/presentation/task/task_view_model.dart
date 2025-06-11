import 'package:flutter/material.dart';
import 'package:flutter_mento_mentee/infrastructure/models/task/create_task.dart';
import 'package:flutter_mento_mentee/infrastructure/repository/task_repository_impl.dart';

class TaskViewModel extends ChangeNotifier {
  final TaskRepository repository;

  TaskViewModel({required this.repository});

  CreateTaskRequest? _createTaskResponse;
  CreateTaskRequest? get createTaskResponse => _createTaskResponse;

  AssignedTaskResponse? _updatedTaskResponse;
  AssignedTaskResponse? get updatedTaskResponse => _updatedTaskResponse;

  List<AssignedTaskResponse> _assignedTasks = [];
  List<AssignedTaskResponse> get assignedTasks => _assignedTasks;

  List<AssignedTaskResponse> _menteeTasks = [];
  List<AssignedTaskResponse> get menteeTasks => _menteeTasks;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> createTask(CreateTaskRequest task, String token) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final response = await repository.createTask(task, token);
      _createTaskResponse = response;
      await getAssignedTasks(token); // Refresh after create
    } catch (e) {
      _errorMessage = 'Failed to create task: ${e.toString()}';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> getAssignedTasks(String token) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final response = await repository.getAssignedTasks(token);
      _assignedTasks = response;
    } catch (e) {
      _errorMessage = 'Failed to fetch assigned tasks: ${e.toString()}';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchMenteeTasks(String token) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final response = await repository.fetchMenteeTasks(token);
      _menteeTasks = response;
    } catch (e) {
      _errorMessage = 'Failed to fetch mentee tasks: ${e.toString()}';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateTask(String taskId, UpdateTaskRequest request, String token) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final response = await repository.updateTaskById(taskId, request, token);
      if (response != null) {
        _updatedTaskResponse = response;
        await getAssignedTasks(token);
      } else {
        _errorMessage = 'Failed to update task';
      }
    } catch (e) {
      _errorMessage = 'Update error: ${e.toString()}';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteRequestById(String taskId, String token) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final success = await repository.deleteTaskById(taskId, token);
      if (success) {
        await getAssignedTasks(token);
      } else {
        _errorMessage = 'Failed to delete task';
      }
    } catch (e) {
      _errorMessage = 'Delete error: ${e.toString()}';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> toggleTaskCompletion(String taskId, String token) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final response = await repository.toggleTaskCompletion(taskId, token);
      if (response != null) {
        await getAssignedTasks(token);
      } else {
        _errorMessage = 'Failed to toggle task status';
      }
    } catch (e) {
      _errorMessage = 'Toggle error: ${e.toString()}';
    } finally {
      _setLoading(false);
    }
  }

  void clearState() {
    _errorMessage = null;
    _updatedTaskResponse = null;
    notifyListeners();
  }
}
