import 'package:flutter/material.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onSettingsPressed;
  final VoidCallback onProfilePressed;

  const TopBar({
    Key? key,
    required this.title,
    required this.onSettingsPressed,
    required this.onProfilePressed,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF3F2C2C),
      title: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: onSettingsPressed,
            tooltip: 'Settings',
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: onProfilePressed,
            tooltip: 'Profile',
          ),
        ],
      ),
    );
  }
}
