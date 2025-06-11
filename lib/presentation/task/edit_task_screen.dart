import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_mento_mentee/infrastructure/models/task/create_task.dart';
import 'package:flutter_mento_mentee/application/task/task_notifier.dart';

class EditTaskScreen extends ConsumerStatefulWidget {
  final String id;
  final String title;
  final String description;
  final String dueDate;
  final String priority;
  final String mentorId;
  final String menteeId;
  final bool isCompleted;

  const EditTaskScreen({
    Key? key,
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.mentorId,
    required this.menteeId,
    required this.isCompleted,
  }) : super(key: key);

  @override
  ConsumerState<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends ConsumerState<EditTaskScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late String _priority;
  DateTime? _dueDate;
  late bool _isCompleted;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _descriptionController = TextEditingController(text: widget.description);
    _priority = widget.priority;
    _isCompleted = widget.isCompleted;

    try {
      _dueDate = DateTime.parse(widget.dueDate);
    } catch (_) {
      _dueDate = null;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  Future<void> _updateTask() async {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _dueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    final req = UpdateTaskRequest(
      taskTitle: _titleController.text,
      description: _descriptionController.text,
      dueDate: DateFormat('yyyy-MM-dd').format(_dueDate!),
      priority: _priority,
      isCompleted: _isCompleted,
    );

    // Call the Riverpod notifier to update
    await ref.read(taskNotifierProvider.notifier).updateTask(widget.id, req);

    // On success, pop back
    if (context.mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    // Watch the async list state to get loading & errors
    final asyncState = ref.watch(taskNotifierProvider);
    final isLoading = asyncState.isLoading;

    String? errorMsg;
    asyncState.maybeWhen(
      error: (err, _) => errorMsg = err.toString(),
      orElse: () {},
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Task'),
        backgroundColor: const Color(0xFF3F2C2C),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Task Title'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 4,
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _selectDueDate,
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
                        .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                        .toList(),
                onChanged: (v) => setState(() => _priority = v!),
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text('Completed'),
                value: _isCompleted,
                onChanged: (v) => setState(() => _isCompleted = v!),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _updateTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3F2C2C),
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child:
                      isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Update Task'),
                ),
              ),

              if (errorMsg != null) ...[
                const SizedBox(height: 16),
                Text(errorMsg!, style: const TextStyle(color: Colors.red)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
