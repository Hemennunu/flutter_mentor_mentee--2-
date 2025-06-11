// import 'package:flutter/material.dart';
// import 'package:flutter_mento_mentee/infrastructure/api/signup_api.dart';

// class SignupViewModel extends ChangeNotifier {
//   bool _isLoading = false;
//   String? _errorMessage;
//   String? _successMessage;

//   bool get isLoading => _isLoading;
//   String? get errorMessage => _errorMessage;
//   String? get successMessage => _successMessage;

//   Future<void> signup({
//     required String name,
//     required String email,
//     required String password,
//     required String confirmPassword,
//     required String role,
//     required String skill,
//     required VoidCallback onSuccess,
//   }) async {
//     _setLoading(true);
//     _errorMessage = null;
//     _successMessage = null;

//     if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty || role.isEmpty || skill.isEmpty) {
//       _setError("All fields are required.");
//       return;
//     }

//     if (password != confirmPassword) {
//       _setError("Passwords do not match.");
//       return;
//     }

//     final result = await SignupApi.signup(
//       SignupRequest(
//         name: name,
//         email: email,
//         password: password,
//         role: role,
//         skill: skill,
//       ),
//     );

//     if (result.isSuccess) {
//       _successMessage = "Signup successful!";
//       notifyListeners();
//       onSuccess();
//     } else {
//       _setError(result.error?.toString() ?? "Signup failed.");
//     }

//     _setLoading(false);
//   }

//   void _setLoading(bool value) {
//     _isLoading = value;
//     notifyListeners();
//   }

//   void _setError(String message) {
//     _errorMessage = message;
//     _isLoading = false;
//     notifyListeners();
//   }
// }
