import 'package:flutter/material.dart';
import 'package:flutter_mento_mentee/application/mentorship-request/mentorship_request_notifier.dart';
import 'package:flutter_mento_mentee/presentation/common_widgets/bottom_bar.dart';

class MentorProfileScreen extends StatefulWidget {
  final void Function()? onEditProfile;
  final void Function()? onSettings;

  const MentorProfileScreen({
    super.key,
    this.onEditProfile,
    this.onSettings,
  });

  @override
  State<MentorProfileScreen> createState() => _MentorProfileScreenState();
}

class _MentorProfileScreenState extends State<MentorProfileScreen> {
  int _currentIndex = 1; // Profile tab index

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF3F2C2C),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: widget.onEditProfile ??
                    () {
                  Navigator.pushNamed(context, '/mentor-editProfile');
                },
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: widget.onSettings ??
                    () {
                  Navigator.pushNamed(context, '/settings');
                },
          ),
        ],
      ),
      bottomNavigationBar: MentorBottomBar(
         provider: mentorshipRequestNotifierProvider,
        currentIndex: _currentIndex,
        context: context,
      ),
      body: Container(
        color: const Color(0xFFF1F1F1),
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text(
              "Welcome to your Profile, Mentor!",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            const ProfileSection(title: "Name", content: "Blen Berhanu"),
            const ProfileSection(title: "Email", content: "blen@gmail.com"),
            const ProfileSection(title: "Skills", content: "design"),
            const ProfileSection(title: "Available to", content: "Mentor"),
            const ProfileSection(title: "Bio", content: "I love coding"),
            const ProfileSection(title: "Location", content: "Addis Ababa,Ethiopia"),
            const ProfileSection(title: "Occupation", content: "Software Engineer"),
            const ProfileSection(title: "Organization", content: "Mento Mentee Organization"),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3F2C2C),
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/mentor-editProfile');
              },
              child: const Text("Edit Profile"),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileSection extends StatelessWidget {
  final String title;
  final String content;

  const ProfileSection({
    super.key,
    required this.title,
    required this.content,
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
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3F2C2C),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              content,
              style: const TextStyle(fontSize: 16, color: Color(0xFF757575)),
            ),
          ],
        ),
      ),
    );
  }
}
