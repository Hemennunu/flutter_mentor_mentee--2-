// lib/presentation/request/process_request_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_mento_mentee/application/mentorship-request/mentorship_request_notifier.dart';
// import 'package:flutter_mento_mentee/infrastructure/models/mentor/fetched_mentorship_request.dart';
import 'package:flutter_mento_mentee/infrastructure/models/mentor/create_mentorship_request.dart';
// import 'package:flutter_mento_mentee/infrastructure/models/mentor/update_mentorship_status.dart';
import 'package:flutter_mento_mentee/presentation/common_widgets/bottom_bar.dart';
import 'package:go_router/go_router.dart';

class ProcessRequestScreen extends ConsumerStatefulWidget {
  const ProcessRequestScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ProcessRequestScreen> createState() =>
      _ProcessRequestScreenState();
}

class _ProcessRequestScreenState extends ConsumerState<ProcessRequestScreen> {
  static const _currentIndex = 4;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(mentorshipRequestNotifierProvider.notifier)
          .fetchRequestsSentByMentees();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mentorshipRequestNotifierProvider);

    // Listen for errors and show SnackBar
    ref.listen<AsyncValue<List<FetchedMentorshipRequest>>>(
      mentorshipRequestNotifierProvider,
      (_, next) => next.whenOrNull(
        error: (err, _) {
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(err.toString())));
          }
        },
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Process Requests'),
        backgroundColor: const Color(0xFF3F2C2C),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => GoRouter.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => GoRouter.of(context).go('/settings'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh:
            () =>
                ref.read(mentorshipRequestNotifierProvider.notifier).refresh(),
        child: state.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error:
              (err, _) => Center(
                child: Text(
                  err.toString(),
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          data: (allRequests) {
            final pending =
                allRequests.where((r) => r.status == 'pending').toList();
            final addressed =
                allRequests.where((r) => r.status != 'pending').toList();

            return ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
                if (pending.isNotEmpty) ...[
                  const SectionHeader('Pending Requests'),
                  PendingRequestsSection(requests: pending),
                ],
                if (addressed.isNotEmpty) ...[
                  const SectionHeader('Addressed Requests'),
                  AddressedRequestsSection(requests: addressed),
                ],
                if (pending.isEmpty && addressed.isEmpty)
                  const Center(child: Text('No requests found')),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: MentorBottomBar(
        provider: mentorshipRequestNotifierProvider,
        currentIndex: _currentIndex,
        context: context,
      ),
    );
  }
}

/// A common header widget for each section
class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader(this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF3F2C2C),
      ),
    ),
  );
}

/// Renders a vertical list of pending request cards
class PendingRequestsSection extends ConsumerWidget {
  final List<FetchedMentorshipRequest> requests;
  const PendingRequestsSection({required this.requests, Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children:
          requests.map((r) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16,
              ),
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mentee ID: ${r.menteeId}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text('Topic: ${r.mentorshipTopic}'),
                      Text('Dates: ${r.startDate} → ${r.endDate}'),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed:
                                () => ref
                                    .read(
                                      mentorshipRequestNotifierProvider
                                          .notifier,
                                    )
                                    .updateStatus(
                                      r.id!,
                                      UpdateMentorshipStatus(
                                        status: 'accepted',
                                      ),
                                    ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3F2C2C),
                            ),
                            child: const Text('Accept'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed:
                                () => ref
                                    .read(
                                      mentorshipRequestNotifierProvider
                                          .notifier,
                                    )
                                    .updateStatus(
                                      r.id!,
                                      UpdateMentorshipStatus(
                                        status: 'rejected',
                                      ),
                                    ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                            ),
                            child: const Text('Reject'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }
}

/// Renders a vertical list of addressed request cards
class AddressedRequestsSection extends StatelessWidget {
  final List<FetchedMentorshipRequest> requests;
  const AddressedRequestsSection({required this.requests, Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          requests.map((r) {
            final statusText =
                r.status![0].toUpperCase() + r.status!.substring(1);
            final statusColor =
                r.status == 'accepted' ? Colors.green : Colors.red;

            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16,
              ),
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mentee ID: ${r.menteeId}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text('Topic: ${r.mentorshipTopic}'),
                      Text('Dates: ${r.startDate} → ${r.endDate}'),
                      const SizedBox(height: 8),
                      Text(
                        'Status: $statusText',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }
}
