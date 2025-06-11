import 'package:flutter/material.dart';
import 'package:flutter_mento_mentee/application/task/task_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_mento_mentee/infrastructure/models/task/create_task.dart';

class AssignTaskScreen extends ConsumerStatefulWidget {
  final String menteeId;

  const AssignTaskScreen({Key? key, required this.menteeId}) : super(key: key);

  @override
  ConsumerState<AssignTaskScreen> createState() => _AssignTaskScreenState();
}

class _AssignTaskScreenState extends ConsumerState<AssignTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _dueDate;
  String _priority = 'High';

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  Future<void> _assignTask() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid || _dueDate == null) {
      if (_dueDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a due date')),
        );
      }
      return;
    }

    final request = CreateTaskRequest(
      taskTitle: _titleController.text,
      description: _descriptionController.text,
      dueDate: DateFormat('yyyy-MM-dd').format(_dueDate!),
      priority: _priority,
      menteeId: widget.menteeId,
    );

    final notifier = ref.read(taskNotifierProvider.notifier);

    await notifier.createTask(request);

    final state = ref.read(taskNotifierProvider);

    state.whenOrNull(
      data: (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task assigned successfully')),
        );
        Navigator.pop(context);
      },
      error: (e, _) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskState = ref.watch(taskNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assign New Task'),
        backgroundColor: const Color(0xFF3F2C2C),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Task Title'),
                validator:
                    (value) =>
                        (value == null || value.isEmpty)
                            ? 'Please enter a title'
                            : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 4,
                validator:
                    (value) =>
                        (value == null || value.isEmpty)
                            ? 'Please enter a description'
                            : null,
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () => _selectDueDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'Due Date'),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _dueDate != null
                            ? DateFormat('yyyy-MM-dd').format(_dueDate!)
                            : 'Select a date',
                      ),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _priority,
                decoration: const InputDecoration(labelText: 'Priority'),
                items:
                    ['High', 'Medium', 'Low']
                        .map(
                          (priority) => DropdownMenuItem(
                            value: priority,
                            child: Text(priority),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _priority = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed:
                    taskState is AsyncLoading ? null : () => _assignTask(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3F2C2C),
                  minimumSize: const Size.fromHeight(50),
                ),
                child:
                    taskState is AsyncLoading
                        ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        )
                        : const Text('Assign Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
