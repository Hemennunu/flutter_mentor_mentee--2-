import 'package:flutter/material.dart';
import 'package:flutter_mento_mentee/application/mentorship-request/mentorship_request_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:flutter_mento_mentee/infrastructure/models/mentor/create_mentorship_request.dart';
// import 'package:flutter_mento_mentee/application/mentorship-request/mentorship_request_notifier.dart';

class SendRequestScreen extends ConsumerStatefulWidget {
  final String mentorId;
  final String name;
  final String specialization;

  const SendRequestScreen({
    super.key,
    required this.mentorId,
    required this.name,
    required this.specialization,
  });

  @override
  ConsumerState<SendRequestScreen> createState() => _SendRequestScreenState();
}

class _SendRequestScreenState extends ConsumerState<SendRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? startDate, endDate;
  String mentorshipTopic = '';
  String additionalNotes = '';
  String? responseMessage;

  final dateFormatter = DateFormat('yyyy-MM-dd');

  Future<void> _pickDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate:
          isStart ? (startDate ?? DateTime.now()) : (endDate ?? DateTime.now()),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart)
          startDate = picked;
        else
          endDate = picked;
      });
    }
  }

  Future<void> _sendRequest() async {
    if (!_formKey.currentState!.validate()) return;

    final errors = <String>[];
    if (startDate == null) errors.add('Start date is required');
    if (endDate == null) errors.add('End date is required');
    if (mentorshipTopic.trim().isEmpty) {
      errors.add('Mentorship topic is required');
    }
    if (widget.mentorId.isEmpty) errors.add('Invalid mentor ID');

    if (errors.isNotEmpty) {
      setState(() => responseMessage = errors.join('\n'));
      return;
    }

    // Build the payload
    final request = CreateMentorshipRequest(
      startDate: '${dateFormatter.format(startDate!)}T00:00:00.000Z',
      endDate: '${dateFormatter.format(endDate!)}T00:00:00.000Z',
      mentorshipTopic: mentorshipTopic.trim(),
      additionalNotes: additionalNotes.trim(),
      mentorId: widget.mentorId,
    );

    // Invoke the notifier
    try {
      await ref
          .read(mentorshipRequestNotifierProvider.notifier)
          .sendRequest(request);

      if (!mounted) return;
      // On success, navigate to requests list
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request sent successfully!')),
      );
      context.push('/requests');
    } catch (e) {
      // Error already stored in AsyncNotifier state; display it:
      setState(() => responseMessage = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch loading/error state
    final state = ref.watch(mentorshipRequestNotifierProvider);
    final isLoading = state.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Send Request"),
        backgroundColor: const Color(0xFF3F2C2C),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.go('/settings'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                "Mentor ID: ${widget.mentorId}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "Mentor: ${widget.name}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("Occupation: ${widget.specialization}"),
              const SizedBox(height: 16),

              // Start Date
              TextFormField(
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Start Date",
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                controller: TextEditingController(
                  text:
                      startDate != null ? dateFormatter.format(startDate!) : '',
                ),
                onTap: () => _pickDate(true),
                validator:
                    (_) =>
                        startDate == null ? 'Please select a start date' : null,
              ),
              const SizedBox(height: 12),

              // End Date
              TextFormField(
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "End Date",
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                controller: TextEditingController(
                  text: endDate != null ? dateFormatter.format(endDate!) : '',
                ),
                onTap: () => _pickDate(false),
                validator: (_) {
                  if (endDate == null) return 'Please select an end date';
                  if (startDate != null && endDate!.isBefore(startDate!)) {
                    return 'End date must be after start date';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Mentorship Topic
              TextFormField(
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "What do you need mentorship in?",
                  alignLabelWithHint: true,
                ),
                onChanged: (v) => mentorshipTopic = v.trim(),
                validator:
                    (v) =>
                        (v == null || v.trim().isEmpty)
                            ? 'Please enter a mentorship topic'
                            : null,
              ),
              const SizedBox(height: 12),

              // Additional Notes
              TextFormField(
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Additional Notes",
                  alignLabelWithHint: true,
                ),
                onChanged: (v) => additionalNotes = v.trim(),
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFEDED),
                  foregroundColor: Colors.black,
                ),
                onPressed: isLoading ? null : _sendRequest,
                child:
                    isLoading
                        ? const CircularProgressIndicator()
                        : const Text("Send Request"),
              ),

              if (state.hasError || responseMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  responseMessage ?? state.error!.toString(),
                  style: TextStyle(
                    color:
                        (responseMessage ?? '').toLowerCase().contains(
                              'success',
                            )
                            ? Colors.green
                            : Colors.red,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
