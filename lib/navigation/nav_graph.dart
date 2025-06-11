// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:provider/provider.dart';
// import 'package:get_it/get_it.dart';

// import 'package:flutter_mento_mentee/presentation/welcome/welcome_screen.dart';
// import 'package:flutter_mento_mentee/presentation/auth/login/login_screen.dart';
// import 'package:flutter_mento_mentee/presentation/auth/signup/signup_screen.dart';
// import 'package:flutter_mento_mentee/presentation/dashboard/mentor_home_screen.dart';
// import 'package:flutter_mento_mentee/presentation/dashboard/mentee_home_screen.dart';
// import 'package:flutter_mento_mentee/presentation/request/request_screen.dart';
// import 'package:flutter_mento_mentee/presentation/request/process_request_screen.dart';
// import 'package:flutter_mento_mentee/presentation/profile/settings_screen.dart';
// import 'package:flutter_mento_mentee/presentation/profile/logout_screen.dart';
// import 'package:flutter_mento_mentee/presentation/profile/delete_account_screen.dart';
// import 'package:flutter_mento_mentee/presentation/profile/change_password_screen.dart';
// import 'package:flutter_mento_mentee/presentation/profile/edit_profile_screen.dart';
// import 'package:flutter_mento_mentee/presentation/profile/profile_screen.dart';
// import 'package:flutter_mento_mentee/presentation/profile/MentorProfile.dart';
// import 'package:flutter_mento_mentee/presentation/profile/EditMentorProfile.dart';
// import 'package:flutter_mento_mentee/presentation/member/members_screen.dart';
// import 'package:flutter_mento_mentee/presentation/member/member_profile_screen.dart';
// import 'package:flutter_mento_mentee/presentation/member/members_view_model.dart';
// import 'package:flutter_mento_mentee/presentation/request/send_request_screen.dart';
// import 'package:flutter_mento_mentee/presentation/request/edit_request_screen.dart';
// import 'package:flutter_mento_mentee/presentation/request/mentorship_request_view_model.dart';
// import 'package:flutter_mento_mentee/domain/repositories/request_repository.dart';
// import 'package:flutter_mento_mentee/infrastructure/repository/mentor_repository_impl.dart';
// import 'package:flutter_mento_mentee/infrastructure/api/mentor_api.dart';
// import 'package:flutter_mento_mentee/presentation/task/task_page_screen.dart';
// import 'package:flutter_mento_mentee/presentation/task/assign_task_screen.dart';
// import 'package:flutter_mento_mentee/presentation/task/edit_task_screen.dart';
// import 'package:flutter_mento_mentee/presentation/task/task_view_model.dart';
// import 'package:flutter_mento_mentee/infrastructure/repository/task_repository_impl.dart';
// import 'package:flutter_mento_mentee/infrastructure/api/task_api.dart';
// import 'package:flutter_mento_mentee/presentation/task/relations_screen.dart';

// Route<dynamic> generateRoute(RouteSettings settings) {
//   switch (settings.name) {
//     case '/':
//       return MaterialPageRoute(builder: (_) => const WelcomeScreen());

//     case '/login':
//       return MaterialPageRoute(
//         builder: (context) => LoginScreen(
//           onLoginSuccess: (role) {},
//           onNavigateToSignup: () {
//             Navigator.of(context).pushNamed('/signup');
//           },
//         ),
//       );

//     case '/signup':
//       return MaterialPageRoute(builder: (_) => const SignupScreen());

//     case '/mentor-home':
//       return MaterialPageRoute(builder: (_) => const MentorHomeScreen());

//     case '/mentee-home':
//       return MaterialPageRoute(builder: (_) => const MenteeHomeScreen());

//     case '/settings':
//       return MaterialPageRoute(builder: (_) => const SettingsScreen());

//     case '/logout':
//       return MaterialPageRoute(builder: (_) => const LogoutScreen());

//     case '/change-password':
//       return MaterialPageRoute(builder: (_) => const ChangePasswordScreen());

//     case '/delete-account':
//       return MaterialPageRoute(builder: (_) => const DeleteAccountScreen());

//     case '/editProfile':
//       return MaterialPageRoute(builder: (_) => const EditProfileScreen());

//     case '/profile':
//       return MaterialPageRoute(builder: (_) => const ProfileScreen());

//     case '/mentor-editProfile':
//       return MaterialPageRoute(builder: (_) => const EditMentorScreen());

//     case '/mentor-profile':
//       return MaterialPageRoute(builder: (_) => const MentorProfileScreen());

//     case '/members':
//       return MaterialPageRoute(
//         builder: (_) => ChangeNotifierProvider(
//           create: (_) => MembersViewModel(
//             repository: MentorRepository(MentorApi(Dio())),
//           ),
//           child: const MembersScreen(),
//         ),
//       );

//     case '/member-profile':
//       final args = settings.arguments as Map<String, dynamic>;
//       return MaterialPageRoute(
//         builder: (_) => MemberProfileScreen(
//           mentorId: args['mentorId'],
//           mentorName: args['mentorName'],
//           mentorSkill: args['mentorSkill'],
//           mentorEmail: args['mentorEmail'],
//           mentorOccupation: args['mentorOccupation'],
//           mentorBio: args['mentorBio'],
//         ),
//       );

//     case '/sendRequestScreen':
//       final args = settings.arguments as Map<String, dynamic>;
//       return MaterialPageRoute(
//         builder: (_) => SendRequestScreen(
//           mentorId: args['mentorId']?.toString() ?? '',
//           name: args['name']?.toString() ?? args['mentorName']?.toString() ?? '',
//           specialization: args['specialization']?.toString() ??
//               args['mentorSkill']?.toString() ??
//               '',
//         ),
//       );

//     case '/assign-task':
//       final menteeId = settings.arguments as String;
//       return MaterialPageRoute(
//         builder: (_) => AssignTaskScreen(menteeId: menteeId),
//       );

//     case '/edit-task':
//       final args = settings.arguments as Map<String, dynamic>;
//       return MaterialPageRoute(
//         builder: (_) => EditTaskScreen(
//           id: args['id'],
//           title: args['title'],
//           description: args['description'],
//           dueDate: args['dueDate'],
//           priority: args['priority'],
//           mentorId: args['mentorId'],
//           menteeId: args['menteeId'],
//           isCompleted: args['isCompleted'],
//         ),
//       );

//     case '/tasks':
//       return MaterialPageRoute(
//         builder: (_) => ChangeNotifierProvider(
//           create: (context) => TaskViewModel(
//             repository: TaskRepository(TaskApi(GetIt.I<Dio>())),
//           ),
//           child: const TaskScreen(),
//         ),
//       );

//     case '/requests':
//       return MaterialPageRoute(
//         builder: (_) => ChangeNotifierProvider(
//           create: (_) => MentorshipRequestProvider(
//             repository: GetIt.I<RequestRepository>(),
//           ),
//           child: const RequestScreen(),
//         ),
//       );

//     case '/process-request':
//       final repository = GetIt.I<RequestRepository>();
//       return MaterialPageRoute(
//         builder: (_) => ChangeNotifierProvider(
//           create: (_) => MentorshipRequestProvider(repository: repository),
//           child: const ProcessRequestScreen(),
//         ),
//       );

//     case '/edit_request':
//       final args = settings.arguments as Map<String, dynamic>;
//       return MaterialPageRoute(
//         builder: (_) => EditTaskScreen(
//           id: args['id'],
//           startDate: args['startDate'],
//           endDate: args['endDate'],
//           mentorshipTopic: args['mentorshipTopic'],
//           additionalNotes: args['additionalNotes'],
//           mentorId: args['mentorId'],
//         ),
//       );

//     case '/relations':
//       return MaterialPageRoute(
//         builder: (_) => ChangeNotifierProvider(
//           create: (_) => TaskViewModel(
//             repository: TaskRepository(TaskApi(GetIt.I<Dio>())),
//           ),
//           child: const RelationsScreen(),
//         ),
//       );

//     default:
//       return MaterialPageRoute(
//         builder: (_) => const Scaffold(
//           body: Center(child: Text('Page Not Found')),
//         ),
//       );
//   }
// }
