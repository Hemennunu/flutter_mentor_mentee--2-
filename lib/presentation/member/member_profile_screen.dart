import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MemberProfileScreen extends StatelessWidget {
  final String mentorId;
  final String mentorName;
  final String mentorSkill;
  final String mentorEmail;
  final String mentorOccupation;
  final String mentorBio;

  const MemberProfileScreen({
    Key? key,
    required this.mentorId,
    required this.mentorName,
    required this.mentorSkill,
    required this.mentorEmail,
    required this.mentorOccupation,
    required this.mentorBio,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color brown = const Color(0xFF3F2C2C);
    final Color brownLight = const Color(0xFFFFF1F1);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mentor Profile'),
        backgroundColor: brown,
        foregroundColor: brownLight,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: brown,
                child: Text(
                  mentorName.isNotEmpty
                      ? mentorName.trim().split(' ').map((e) => e[0]).take(2).join().toUpperCase()
                      : 'M',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildProfileSection(
              'Name',
              mentorName,
              Icons.person,
              brown,
            ),
            _buildProfileSection(
              'Email',
              mentorEmail,
              Icons.email,
              brown,
            ),
            _buildProfileSection(
              'Skill',
              mentorSkill,
              Icons.work,
              brown,
            ),
            _buildProfileSection(
              'Occupation',
              mentorOccupation,
              Icons.business,
              brown,
            ),
            _buildProfileSection(
              'Bio',
              mentorBio,
              Icons.description,
              brown,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.push(

                    '/sendRequestScreen',
                    extra: {
                      'mentorId': mentorId,
                      'name': mentorName,
                      'specialization': mentorSkill,
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: brown,
                  foregroundColor: Colors.white, // text/icon
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Send Mentorship Request'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(String title, String content, IconData icon, Color brown) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: brown),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: brown,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          Divider(color: brown.withOpacity(0.2)),
        ],
      ),
    );
  }
}