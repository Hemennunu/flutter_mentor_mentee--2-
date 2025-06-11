import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_mento_mentee/application/mentorship-request/mentorship_request_notifier.dart';
import 'package:flutter_mento_mentee/infrastructure/models/mentor/create_mentorship_request.dart';
import 'package:flutter_mento_mentee/presentation/common_widgets/bottom_bar.dart';
import 'package:go_router/go_router.dart';

class RequestScreen extends ConsumerWidget {
  const RequestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestState = ref.watch(mentorshipRequestNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mentorship Requests',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF3F2C2C),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () => context.go('/settings'),
          ),
        ],
      ),
      body: requestState.when(
        data: (requests) => _RequestList(requests: requests),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      bottomNavigationBar: MenteeBottomBar(
        currentIndex: 4,
        context: context,
        provider: mentorshipRequestNotifierProvider,
      ),
    );
  }
}
class _RequestList extends ConsumerWidget {
  final List<FetchedMentorshipRequest> requests;

  const _RequestList({Key? key, required this.requests}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(mentorshipRequestNotifierProvider.notifier);

    return RefreshIndicator(
      onRefresh: () => notifier.refresh(),
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const Text(
                  'Pending Requests',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3F2C2C),
                  ),
                ),
                const SizedBox(height: 8),
                ...requests
                    .where((r) => r.status == 'pending')
                    .map(
                      (request) => RequestCard(
                        request: request,
                        isAddressed: false,
                        onDelete:
                            () => _deleteRequest(context, ref, request.id),
                        onEdit: () => _navigateToEdit(context, request),
                      ),
                    ),
                const SizedBox(height: 24),
                const Text(
                  'Addressed Requests',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3F2C2C),
                  ),
                ),
                const SizedBox(height: 8),
                ...requests
                    .where((r) => r.status != 'pending')
                    .map(
                      (request) => RequestCard(
                        request: request,
                        isAddressed: true,
                        onDelete:
                            () => _deleteRequest(context, ref, request.id),
                        onEdit: () => _navigateToEdit(context, request),
                      ),
                    ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteRequest(
    BuildContext context,
    WidgetRef ref,
    String id,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Delete Request'),
            content: const Text(
              'Are you sure you want to delete this request?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Delete'),
              ),
            ],
          ),
    );

    if (confirm == true) {
      await ref.read(mentorshipRequestNotifierProvider.notifier).deleteById(id);
    }
  }

 void _navigateToEdit(BuildContext context, FetchedMentorshipRequest request) {
  context.push(
      '/edit-request',
      extra: {
        'id': request.id!,
        'mentorId': request.mentorId,
        'menteeId': request.menteeId,
        'mentorshipTopic': request.mentorshipTopic,
        'startDate': request.startDate,
        'endDate': request.endDate,
        'additionalNotes': request.additionalNotes,
      },
    );

}
}
class RequestCard extends StatelessWidget {
  final FetchedMentorshipRequest request;
  final bool isAddressed;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const RequestCard({
    super.key,
    required this.request,
    required this.isAddressed,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRow('Start Date:', request.startDate),
            _buildRow('End Date:', request.endDate),
            _buildRow('Field:', request.mentorshipTopic),
            _buildRow('Notes:', request.additionalNotes),
            if (isAddressed)
              _buildRow('Status:', '${request.status[0].toUpperCase()}${request.status.substring(1)}'),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton(
                  onPressed: onEdit,
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3F2C2C), foregroundColor: Colors.white),
                  child: const Text('Edit'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: onDelete,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                  child: const Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF3F2C2C))),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: const TextStyle(color: Color(0xFF757575)))),
        ],
      ),
    );
  }
}

