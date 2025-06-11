import 'package:flutter/material.dart';
import 'package:flutter_mento_mentee/application/mentorship-request/mentorship_request_notifier.dart';
import 'package:flutter_mento_mentee/presentation/common_widgets/bottom_bar.dart';
import 'package:go_router/go_router.dart';

class MenteeHomeScreen extends StatefulWidget {
  const MenteeHomeScreen({super.key});

  @override
  State<MenteeHomeScreen> createState() => _MenteeHomeScreenState();
}

class _MenteeHomeScreenState extends State<MenteeHomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F1F1),
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF3F2C2C),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              context.push('/settings');
            },
            tooltip: 'Settings',
          ),
        ],
      ),
      bottomNavigationBar: MenteeBottomBar(
        currentIndex: _currentIndex,
        context: context, provider: mentorshipRequestNotifierProvider, // Pass the context here
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Welcome, User!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Mentee Home',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                RequestStatusCard(),
                SizedBox(height: 16),
                AchievementsCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RequestStatusCard extends StatelessWidget {
  const RequestStatusCard({super.key});

  static Widget _buildStatusRow(String label, String count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(count, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      color: const Color(0xFFF1F1F1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Request Status',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            _buildStatusRow('Pending Requests', '0'),
            _buildStatusRow('Accepted Requests', '0'),
            _buildStatusRow('Rejected Requests', '0'),
            _buildStatusRow('Completed Relations', '0'),
          ],
        ),
      ),
    );
  }
}

class AchievementsCard extends StatelessWidget {
  const AchievementsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      color: const Color(0xFFF1F1F1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Achievements',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'No achievements',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}