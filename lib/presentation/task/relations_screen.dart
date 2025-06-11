import 'package:flutter/material.dart';
import 'package:flutter_mento_mentee/application/mentorship-request/mentorship_request_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_mento_mentee/application/request/mentorship_request_notifier.dart';
// import 'package:flutter_mento_mentee/infrastructure/models/mentor/fetched_mentorship_request.dart';
import 'package:flutter_mento_mentee/presentation/common_widgets/bottom_bar.dart';
import 'package:go_router/go_router.dart';

class RelationsScreen extends ConsumerStatefulWidget {
  const RelationsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RelationsScreen> createState() => _RelationsScreenState();
}

class _RelationsScreenState extends ConsumerState<RelationsScreen> {
  @override
  void initState() {
    super.initState();
    // Trigger initial fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mentorshipRequestNotifierProvider.notifier).fetchAcceptedRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mentorshipRequestNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Relations', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF3F2C2C),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      bottomNavigationBar: MentorBottomBar(
        provider: mentorshipRequestNotifierProvider,
        currentIndex: 3, context: context),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (err, _) => Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  err.toString(),
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
        data: (allRequests) {
          // Filter out pending & rejected
          final filtered =
              allRequests
                  .where((r) => r.status != 'pending' && r.status != 'rejected')
                  .toList();

          if (filtered.isEmpty) {
            return const Center(child: Text('No relations found'));
          }

          return RefreshIndicator(
            onRefresh:
                () =>
                    ref
                        .read(mentorshipRequestNotifierProvider.notifier)
                        .refresh(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filtered.length,
              itemBuilder: (context, i) {
                final req = filtered[i];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      // Assign Task Button on the left
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: TextButton.icon(
                          onPressed: () {
                            // navigate via GoRouter (optionally pass extra)
                            context.push('/assign-task', extra: req.menteeId);
                          },
                          icon: const Icon(
                            Icons.assignment,
                            color: Colors.blue,
                          ),
                          label: const Text(
                            'Assign Task',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ),
                      // Details column
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 8,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Mentee: ${req.menteeName}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text('Topic: ${req.mentorshipTopic}'),
                              const SizedBox(height: 4),
                              Text('Status: ${req.status}'),
                            ],
                          ),
                        ),
                      ),
                      // Optional “Process” button
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: () {
                          context.push('/process-request', extra: req);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
