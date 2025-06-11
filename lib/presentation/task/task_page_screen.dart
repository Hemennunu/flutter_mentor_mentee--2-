import 'package:flutter/material.dart';
import 'package:flutter_mento_mentee/infrastructure/models/task/create_task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_mento_mentee/application/task/task_notifier.dart';
import 'package:go_router/go_router.dart';

class TaskScreen extends ConsumerStatefulWidget {
  const TaskScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends ConsumerState<TaskScreen> {
  @override
  void initState() {
    super.initState();
    // Trigger initial load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(taskNotifierProvider.notifier).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(taskNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Tasks'),
        backgroundColor: const Color(0xFF3F2C2C),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(taskNotifierProvider.notifier).refresh();
            },
          ),
        ],
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (err, _) => Center(
              child: Text(
                err.toString(),
                style: const TextStyle(color: Colors.red),
              ),
            ),
        data: (tasks) {
          if (tasks.isEmpty) {
            return const Center(child: Text('No tasks assigned yet'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return _buildTaskCard(context, task);
            },
          );
        },
      ),
    );
  }

  Widget _buildTaskCard(BuildContext context, AssignedTaskResponse task) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  task.taskTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) => _onMenuSelected(context, value, task),
                  itemBuilder:
                      (_) => const [
                        PopupMenuItem(value: 'edit', child: Text('Edit Task')),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete Task'),
                        ),
                      ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(task.description),
            const SizedBox(height: 8),
            Text('Assigned to: ${task.menteeId}'),
            Text('Due: ${task.dueDate}'),
            Text('Priority: ${task.priority}'),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Status:'),
                const SizedBox(width: 8),
                Chip(
                  label: Text(
                    task.isCompleted ? 'Completed' : 'Pending',
                    style: TextStyle(
                      color: task.isCompleted ? Colors.green : Colors.orange,
                    ),
                  ),
                  backgroundColor:
                      task.isCompleted
                          ? Colors.green.withOpacity(0.1)
                          : Colors.orange.withOpacity(0.1),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    task.isCompleted
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    color: task.isCompleted ? Colors.green : Colors.grey,
                  ),
                  onPressed: () {
                    ref
                        .read(taskNotifierProvider.notifier)
                        .toggleTaskCompletion(task.id)
                        .then(
                          (_) =>
                              ref.read(taskNotifierProvider.notifier).refresh(),
                        );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onMenuSelected(
    BuildContext context,
    String action,
    AssignedTaskResponse task,
  ) {
    switch (action) {
      case 'edit':
        context.push(
          '/edit-task',
          extra: {
            'id': task.id,
            'title': task.taskTitle,
            'description': task.description,
            'dueDate': task.dueDate,
            'priority': task.priority,
            'mentorId': task.mentorId,
            'menteeId': task.menteeId,
            'isCompleted': task.isCompleted,
          },
        );
        break;
      case 'delete':
        _confirmDelete(context, task.id);
        break;
    }
  }

  void _confirmDelete(BuildContext context, String taskId) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Delete Task'),
            content: const Text('Are you sure you want to delete this task?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  ref
                      .read(taskNotifierProvider.notifier)
                      .deleteTask(taskId)
                      .then((_) {
                        ref.read(taskNotifierProvider.notifier).refresh();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Task deleted successfully'),
                          ),
                        );
                      });
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }
}
