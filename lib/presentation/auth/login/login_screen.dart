import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_mento_mentee/application/auth/login_notifier.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  final VoidCallback onNavigateToSignup;
  final Function(String role) onLoginSuccess;

  const LoginScreen({
    required this.onNavigateToSignup,
    required this.onLoginSuccess,
    super.key,
  });

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool passwordVisible = false;
  String selectedRole = '';

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginNotifierProvider);
    final isLoading = loginState.isLoading;

    ref.listen<AsyncValue<void>>(loginNotifierProvider, (prev, next) {
      next.when(
        data: (_) {
          if (selectedRole == 'mentor') {
            context.go('/mentor-home');
          } else if (selectedRole == 'mentee') {
            context.go('/mentee-home');
          }
        },
        loading: () {},
        error: (err, _) {
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(err.toString())));
          }
        },
      );
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF1F1),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Mentor‑Mentee App',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3F2C2C),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: const [
                      Icon(Icons.login, color: Color(0xFF3F2C2C)),
                      SizedBox(width: 8),
                      Text(
                        'Login',
                        style: TextStyle(
                          color: Color(0xFF3F2C2C),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Email
                  TextFormField(
                    key: const Key('emailField'), // ✅ Added key
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v?.isEmpty ?? true) return 'Please enter your email';
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v!)) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  // Password
                  TextFormField(
                    key: const Key('passwordField'), // ✅ Added key
                    controller: passwordController,
                    obscureText: !passwordVisible,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed:
                            () => setState(
                              () => passwordVisible = !passwordVisible,
                            ),
                      ),
                    ),
                    validator:
                        (v) =>
                            (v?.isEmpty ?? true)
                                ? 'Please enter your password'
                                : null,
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    'Select Role',
                    style: TextStyle(
                      color: Color(0xFF3F2C2C),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: [
                      Radio<String>(
                        key: const Key('mentorRadio'), // ✅ Added key
                        value: 'mentor',
                        groupValue: selectedRole,
                        onChanged: (v) => setState(() => selectedRole = v!),
                      ),
                      const Text('Mentor'),
                      const SizedBox(width: 16),
                      Radio<String>(
                        key: const Key('menteeRadio'), // ✅ Added key
                        value: 'mentee',
                        groupValue: selectedRole,
                        onChanged: (v) => setState(() => selectedRole = v!),
                      ),
                      const Text('Mentee'),
                    ],
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      key: const Key('loginButton'), // ✅ Added key
                      onPressed:
                          isLoading
                              ? null
                              : () {
                                if (_formKey.currentState!.validate() &&
                                    selectedRole.isNotEmpty) {
                                  ref
                                      .read(loginNotifierProvider.notifier)
                                      .login(
                                        email: emailController.text.trim(),
                                        password: passwordController.text,
                                        role: selectedRole,
                                      );
                                } else if (selectedRole.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Please select a role'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3F2C2C),
                      ),
                      child:
                          isLoading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : const Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  GestureDetector(
                    onTap: () => context.push("/signup"),
                    child: const Text(
                      "Don't have an account? Sign Up",
                      style: TextStyle(
                        color: Color(0xFF3F2C2C),
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  // loginState.when(
                  //   data: (_) => const SizedBox.shrink(),
                  //   loading: () => const SizedBox.shrink(),
                  //   error:
                  //       (err, _) => Padding(
                  //         padding: const EdgeInsets.only(top: 16),
                  //         child: Text(
                  //           err.toString(),
                  //           style: const TextStyle(color: Colors.red),
                  //           textAlign: TextAlign.center,
                  //         ),
                  //       ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
