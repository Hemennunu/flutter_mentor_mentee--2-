import 'package:flutter/material.dart';
import 'package:flutter_mento_mentee/application/mentorship-request/mentorship_request_notifier.dart';
import 'package:flutter_mento_mentee/infrastructure/models/mentor/create_mentorship_request.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod/src/async_notifier.dart';

class MentorBottomBar extends StatefulWidget {
  final int currentIndex;
  final BuildContext context;
  final void Function(int)? onTap;// Add context parameter

  const MentorBottomBar({
    Key? key,
    required this.currentIndex,
    required this.context,
    this.onTap, required AutoDisposeAsyncNotifierProviderImpl<MentorshipRequestNotifier, List<FetchedMentorshipRequest>> provider,  // Add this parameter// Require context
  }) : super(key: key);

  @override
  State<MentorBottomBar> createState() => _MentorBottomBarState();
}

class _MentorBottomBarState extends State<MentorBottomBar> {
  void _handleTabSelected(int index) {
    switch (index) {
      case 0:
        context.push('/mentor-home');
        break;
      // case 1:
      //   context.push('/mentor-profile');
      //   break;
      case 1:
        context.push('/tasks');
        break;
      case 2:
        context.push('/relations');
        break;
      case 3:
        context.push('/process-request');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      backgroundColor: const Color(0xFF3F2C2C),
      selectedIndex: widget.currentIndex,
      onDestinationSelected: _handleTabSelected,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home, color: Colors.white),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.groups, color: Colors.white),
          label: 'Tasks',
        ),
        NavigationDestination(
          icon: Icon(Icons.list, color: Colors.white),
          label: 'Relations',
        ),
        NavigationDestination(
          icon: Icon(Icons.notifications, color: Colors.white),
          label: 'Requests',
        ),
      ],
    );
  }
}

class MenteeBottomBar extends StatefulWidget {
  final int currentIndex;
  final BuildContext context;
  final void Function(int)? onTap;
  // Add context parameter

  const MenteeBottomBar({
    Key? key,
    required this.currentIndex,
    required this.context,
    this.onTap, required AutoDisposeAsyncNotifierProviderImpl<MentorshipRequestNotifier, List<FetchedMentorshipRequest>> provider,  // Add this parameter// Require context
  }) : super(key: key);

  @override
  State<MenteeBottomBar> createState() => _MenteeBottomBarState();
}

class _MenteeBottomBarState extends State<MenteeBottomBar> {
  void _handleTabSelected(int index) {
    switch (index) {
      case 0:
        context.push('/mentee-home');
        break;
      case 1:
        context.push('/profile');
        break;
      case 2:
        context.push('/members');
        break;
      case 3:
        context.push('/requests');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      backgroundColor: const Color(0xFF3F2C2C),
      selectedIndex: widget.currentIndex,
      onDestinationSelected: _handleTabSelected,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home, color: Colors.white),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.person, color: Colors.white),
          label: 'Profile',
        ),
        NavigationDestination(
          icon: Icon(Icons.groups, color: Colors.white),
          label: 'Members',
        ),
        NavigationDestination(
          icon: Icon(Icons.notifications, color: Colors.white),
          label: 'Requests',
        ),
      ],
    );
  }
}