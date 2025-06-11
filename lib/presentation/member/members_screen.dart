import 'package:flutter/material.dart';
import 'package:flutter_mento_mentee/application/members/members_notifier.dart';
import 'package:flutter_mento_mentee/application/mentorship-request/mentorship_request_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_mento_mentee/infrastructure/models/mentor/mentor_dto.dart';
import 'package:flutter_mento_mentee/presentation/common_widgets/bottom_bar.dart';
import 'package:go_router/go_router.dart';

class MembersScreen extends ConsumerStatefulWidget {
  const MembersScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends ConsumerState<MembersScreen> {
  final Color brown = const Color(0xFF3F2C2C);
  final Color brownLight = const Color(0xFFFFF1F1);
  int _currentIndex = 2;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Trigger a refresh through the notifier:
      ref.read(membersNotifierProvider.notifier).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mentorsAsync = ref.watch(membersNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mentors List'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
          color: brownLight,
        ),
        backgroundColor: brown,
        foregroundColor: brownLight,
        elevation: 4,
      ),
      bottomNavigationBar: MenteeBottomBar(
        currentIndex: _currentIndex,
        context: context, provider: mentorshipRequestNotifierProvider,
      ),
      body: mentorsAsync.when(
        loading: () => Center(child: CircularProgressIndicator(color: brown)),
        error:
            (err, _) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    err.toString(),
                    style: TextStyle(color: Colors.red.shade700),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed:
                        () =>
                            ref
                                .read(membersNotifierProvider.notifier)
                                .refresh(),
                    style: ElevatedButton.styleFrom(backgroundColor: brown),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
        data: (mentors) {
          if (mentors.isEmpty) {
            return Center(
              child: Text(
                'No mentors available.',
                style: TextStyle(color: brown),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh:
                () => ref.read(membersNotifierProvider.notifier).refresh(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: mentors.length,
              itemBuilder: (context, i) {
                final mentor = mentors[i];
                return _buildMentorCard(mentor);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildMentorCard(Mentor mentor) {
    final initials =
        (mentor.name?.isNotEmpty == true)
            ? mentor.name!.trim().split(' ').map((e) => e[0]).take(2).join()
            : 'M';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: brownLight,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap:
            () => context.push(
              '/member-profile',
              extra: {
                'mentorId': mentor.id,
                'mentorName': mentor.name ?? 'Not specified',
                'mentorSkill': mentor.skill ?? 'Not specified',
                'mentorEmail': mentor.email,
                'mentorOccupation': mentor.occupation ?? 'Not specified',
                'mentorBio': mentor.bio ?? 'Not specified',
              },
            ),

        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: brown,
                child: Text(
                  initials.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Name: ${mentor.name ?? "N/A"}",
                      style: TextStyle(
                        color: brown,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Email: ${mentor.email ?? "Not specified"}",
                      style: TextStyle(
                        color: brown.withOpacity(0.85),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Skill: ${mentor.skill ?? "Not specified"}",
                      style: TextStyle(
                        color: brown.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
