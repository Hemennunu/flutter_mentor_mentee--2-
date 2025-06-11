import 'package:flutter_mento_mentee/presentation/welcome/welcome_screen.dart';
import 'package:flutter_mento_mentee/presentation/auth/login/login_screen.dart';
import 'package:flutter_mento_mentee/presentation/auth/signup/signup_screen.dart';
import 'package:flutter_mento_mentee/presentation/dashboard/mentor_home_screen.dart';
import 'package:flutter_mento_mentee/presentation/dashboard/mentee_home_screen.dart';
import 'package:flutter_mento_mentee/presentation/request/request_screen.dart';
import 'package:flutter_mento_mentee/presentation/request/process_request_screen.dart';
import 'package:flutter_mento_mentee/presentation/profile/settings_screen.dart';
import 'package:flutter_mento_mentee/presentation/profile/logout_screen.dart';
import 'package:flutter_mento_mentee/presentation/profile/delete_account_screen.dart';
import 'package:flutter_mento_mentee/presentation/profile/change_password_screen.dart';
import 'package:flutter_mento_mentee/presentation/profile/edit_profile_screen.dart';
import 'package:flutter_mento_mentee/presentation/profile/profile_screen.dart';
import 'package:flutter_mento_mentee/presentation/profile/EditMentorProfile.dart';
import 'package:flutter_mento_mentee/presentation/member/members_screen.dart';
import 'package:flutter_mento_mentee/presentation/member/member_profile_screen.dart';
import 'package:flutter_mento_mentee/presentation/request/send_request_screen.dart';
import 'package:flutter_mento_mentee/presentation/task/task_page_screen.dart';
import 'package:flutter_mento_mentee/presentation/task/assign_task_screen.dart';
import 'package:flutter_mento_mentee/presentation/task/relations_screen.dart';
import 'package:go_router/go_router.dart';

// Alias the two screens to avoid ambiguity
import 'package:flutter_mento_mentee/presentation/request/edit_request_screen.dart'
    as request;
import 'package:flutter_mento_mentee/presentation/task/edit_task_screen.dart'
    as task;

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (_, __) => const WelcomeScreen()),

    GoRoute(
      path: '/login',
      builder:
          (context, _) => LoginScreen(
            onNavigateToSignup: () => context.push('/signup'),
            onLoginSuccess: (_) {},
          ),
    ),

    GoRoute(path: '/signup', builder: (_, __) => const SignupScreen()),
    GoRoute(path: '/mentor-home', builder: (_, __) => const MentorHomeScreen()),
    GoRoute(path: '/mentee-home', builder: (_, __) => const MenteeHomeScreen()),
    GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
    GoRoute(path: '/logout', builder: (_, __) => const LogoutScreen()),
    GoRoute(
      path: '/change-password',
      builder: (_, __) => const ChangePasswordScreen(),
    ),
    GoRoute(
      path: '/delete-account',
      builder: (_, __) => const DeleteAccountScreen(),
    ),
    GoRoute(
      path: '/editProfile',
      builder: (_, __) => const EditProfileScreen(),
    ),
    GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
    GoRoute(
      path: '/mentor-editProfile',
      builder: (_, __) => const EditMentorScreen(),
    ),

    GoRoute(path: '/members', builder: (_, __) => const MembersScreen()),

    GoRoute(
      path: '/member-profile',
      builder: (_, state) {
        final args = state.extra as Map<String, dynamic>;
        return MemberProfileScreen(
          mentorId: args['mentorId'],
          mentorName: args['mentorName'],
          mentorSkill: args['mentorSkill'],
          mentorEmail: args['mentorEmail'],
          mentorOccupation: args['mentorOccupation'],
          mentorBio: args['mentorBio'],
        );
      },
    ),

    GoRoute(
      path: '/sendRequestScreen',
      builder: (_, state) {
        final args = state.extra as Map<String, dynamic>;
        return SendRequestScreen(
          mentorId: args['mentorId']?.toString() ?? '',
          name:
              args['name']?.toString() ?? args['mentorName']?.toString() ?? '',
          specialization:
              args['specialization']?.toString() ??
              args['mentorSkill']?.toString() ??
              '',
        );
      },
    ),

    GoRoute(path: '/requests', builder: (_, __) => const RequestScreen()),
    GoRoute(
      path: '/process-request',
      builder: (_, __) => const ProcessRequestScreen(),
    ),

   GoRoute(
      path: '/edit-request',
      builder: (_, state) {
        final args = state.extra as Map<String, dynamic>;
        return request.EditRequestScreen(
          id: args['id'],
          mentorId: args['mentorId'],
          menteeId: args['menteeId'],
          topic: args['mentorshipTopic'],
          startDate: DateTime.parse(args['startDate']),
          endDate: DateTime.parse(args['endDate']),
          notes: args['additionalNotes'],
        );
      },
    ),


    GoRoute(path: '/tasks', builder: (_, __) => const TaskScreen()),
    GoRoute(
      path: '/assign-task',
      builder: (_, state) {
        final menteeId = state.extra as String;
        return AssignTaskScreen(menteeId: menteeId);
      },
    ),

    GoRoute(
      path: '/edit-task',
      builder: (_, state) {
        final args = state.extra as Map<String, dynamic>;
        return task.EditTaskScreen(
          id: args['id'],
          title: args['title'],
          description: args['description'],
          dueDate: args['dueDate'],
          priority: args['priority'],
          mentorId: args['mentorId'],
          menteeId: args['menteeId'],
          isCompleted: args['isCompleted'],
        );
      },
    ),

    GoRoute(path: '/relations', builder: (_, __) => const RelationsScreen()),
  ],
);
