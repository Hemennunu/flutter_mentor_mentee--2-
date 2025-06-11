import 'package:flutter/material.dart';
import 'package:flutter_mento_mentee/application/mentorship-request/mentorship_request_notifier.dart';
import 'package:flutter_mento_mentee/presentation/common_widgets/bottom_bar.dart';
import 'package:go_router/go_router.dart';

class MentorHomeScreen extends StatefulWidget {
  const MentorHomeScreen({super.key});

  @override
  State<MentorHomeScreen> createState() => _MentorHomeScreenState();
}

class _MentorHomeScreenState extends State<MentorHomeScreen> {
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
  onPressed: () => context.push('/settings'),
  tooltip: 'Settings',
),]

      ),
      bottomNavigationBar: MentorBottomBar(
        provider: mentorshipRequestNotifierProvider,
        currentIndex: _currentIndex,
        context: context, // Pass the context here
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome, Mentor!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Mentor Home',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                _buildStatusCard(),
                const SizedBox(height: 16),
                _buildCredentialsCard(),
                const SizedBox(height: 16),
                _buildAddCredentialButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
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
            const SizedBox(height: 8),
            _buildStatusRow('Pending Requests', '0'),
            _buildStatusRow('Accepted Requests', '0'),
            _buildStatusRow('Rejected Requests', '0'),
            _buildStatusRow('Completed Relations', '0'),
          ],
        ),
      ),
    );
  }

  Widget _buildCredentialsCard() {
    return Card(
      elevation: 8,
      color: const Color(0xFFF1F1F1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Credentials',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'No credentials added',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddCredentialButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3F2C2C),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: () {
          // Add credential logic here
        },
        child: const Text('Add Credential'),
      ),
    );
  }

  Widget _buildStatusRow(String label, String count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(count, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}