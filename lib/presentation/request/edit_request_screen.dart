// lib/presentation/request/edit_request_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_mento_mentee/application/mentorship-request/mentorship_request_notifier.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_mento_mentee/infrastructure/models/mentor/create_mentorship_request.dart';

class EditRequestScreen extends ConsumerStatefulWidget {
  final String id;
  final String mentorId; // new
  final String menteeId; // if needed elsewhere
  final String topic;
  final DateTime startDate;
  final DateTime endDate;
  final String notes;

  const EditRequestScreen({
    Key? key,
    required this.id,
    required this.mentorId, // new
    required this.menteeId, // if you're using menteeId too
    required this.topic,
    required this.startDate,
    required this.endDate,
    required this.notes,
  }) : super(key: key);
  // …

  @override
  ConsumerState<EditRequestScreen> createState() => _EditRequestScreenState();
}

class _EditRequestScreenState extends ConsumerState<EditRequestScreen> {
  late TextEditingController _topicController;
  late TextEditingController _notesController;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _topicController = TextEditingController(text: widget.topic);
    _notesController = TextEditingController(text: widget.notes);
    _startDate = widget.startDate;
    _endDate = widget.endDate;
  }

  @override
  void dispose() {
    _topicController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isStart}) async {
    final initial = isStart ? _startDate! : _endDate!;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isStart)
          _startDate = picked;
        else
          _endDate = picked;
      });
    }
  }

  Future<void> _saveChanges() async {
    if (_topicController.text.isEmpty ||
        _startDate == null ||
        _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in topic and both dates')),
      );
      return;
    }

    final update = UpdateMentorshipRequest(
      startDate: DateFormat('yyyy-MM-dd').format(_startDate!),
      endDate: DateFormat('yyyy-MM-dd').format(_endDate!),
      mentorshipTopic: _topicController.text.trim(),
      additionalNotes: _notesController.text.trim(),
      mentorId: widget.mentorId,
    );

    await ref
        .read(mentorshipRequestNotifierProvider.notifier)
        .updateById(widget.id, update);

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    // Watch the AsyncValue state for loading/errors
    final asyncReq = ref.watch(mentorshipRequestNotifierProvider);
    final isLoading = asyncReq.isLoading;
    String? errorMsg;
    asyncReq.maybeWhen(
      error: (err, _) => errorMsg = err.toString(),
      orElse: () {},
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Request')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _topicController,
                decoration: const InputDecoration(labelText: 'Topic'),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Start Date',
                      ),
                      child: InkWell(
                        onTap: () => _pickDate(isStart: true),
                        child: Text(
                          DateFormat('yyyy-MM-dd').format(_startDate!),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InputDecorator(
                      decoration: const InputDecoration(labelText: 'End Date'),
                      child: InkWell(
                        onTap: () => _pickDate(isStart: false),
                        child: Text(DateFormat('yyyy-MM-dd').format(_endDate!)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: 'Notes'),
                maxLines: 4,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3F2C2C),
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child:
                      isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Save Changes'),
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
