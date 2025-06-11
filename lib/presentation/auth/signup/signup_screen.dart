import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_mento_mentee/application/auth/signup_notifier.dart';
import 'package:go_router/go_router.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String role = '';
  String skill = '';
  bool passwordVisible = false;
  bool confirmPasswordVisible = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1️⃣ Watch your AsyncNotifier<void>
    final signupState = ref.watch(signupNotifierProvider);
    final isLoading = signupState.isLoading;

    // 2️⃣ Listen for side‑effects (success → navigate, error → snackbar)
    ref.listen<AsyncValue<void>>(signupNotifierProvider, (prev, next) {
      next.when(
        data: (_) {
          // On successful signup, route by role:
          if (role == 'mentor') {
            context.go('/mentor-home');
          } else if (role == 'mentee') {
            context.go('/mentee-home');
          }
        },
        loading: () => null,
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
      backgroundColor: const Color(0xFFFFF1F1),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Mentor‑Mentee App',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3F2C2C),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
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
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.person, color: Color(0xFF3F2C2C)),
                        SizedBox(width: 8),
                        Text(
                          'Signup',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3F2C2C),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Name
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator:
                          (v) =>
                              (v?.isEmpty ?? true)
                                  ? 'Please enter your name'
                                  : null,
                    ),
                    const SizedBox(height: 12),

                    // Email
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v?.isEmpty ?? true) return 'Enter email';
                        return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v!)
                            ? null
                            : 'Invalid email';
                      },
                    ),
                    const SizedBox(height: 12),

                    // Password
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
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
                      obscureText: !passwordVisible,
                      validator:
                          (v) =>
                              ((v?.length ?? 0) < 6)
                                  ? 'Password too short'
                                  : null,
                    ),
                    const SizedBox(height: 12),

                    // Confirm Password
                    TextFormField(
                      controller: confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            confirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed:
                              () => setState(
                                () =>
                                    confirmPasswordVisible =
                                        !confirmPasswordVisible,
                              ),
                        ),
                      ),
                      obscureText: !confirmPasswordVisible,
                      validator:
                          (v) =>
                              v != passwordController.text
                                  ? 'Passwords do not match'
                                  : null,
                    ),
                    const SizedBox(height: 16),

                    // Role selector
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Select Role',
                        style: TextStyle(
                          color: Color(0xFF3F2C2C),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Radio<String>(
                          value: 'mentor',
                          groupValue: role,
                          onChanged: (v) => setState(() => role = v!),
                        ),
                        const Text('Mentor'),
                        const SizedBox(width: 16),
                        Radio<String>(
                          value: 'mentee',
                          groupValue: role,
                          onChanged: (v) => setState(() => role = v!),
                        ),
                        const Text('Mentee'),
                      ],
                    ),
                    if (role.isEmpty)
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Please select a role',
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                    const SizedBox(height: 12),

                    // Skill dropdown
                    DropdownButtonFormField<String>(
                      value: skill.isEmpty ? null : skill,
                      decoration: const InputDecoration(labelText: 'Skill'),
                      items:
                          [
                                'Frontend',
                                'Backend',
                                'Fullstack',
                                'DevOps',
                                'Design',
                              ]
                              .map(
                                (s) =>
                                    DropdownMenuItem(value: s, child: Text(s)),
                              )
                              .toList(),
                      onChanged: (v) => setState(() => skill = v ?? ''),
                      validator:
                          (v) => (v?.isEmpty ?? true) ? 'Select a skill' : null,
                    ),
                    const SizedBox(height: 24),

                    // Sign Up button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed:
                            isLoading
                                ? null
                                : () {
                                  if (_formKey.currentState!.validate() &&
                                      role.isNotEmpty) {
                                    ref
                                        .read(signupNotifierProvider.notifier)
                                        .signup(
                                          name: nameController.text.trim(),
                                          email: emailController.text.trim(),
                                          password: passwordController.text,
                                          confirmPassword:
                                              confirmPasswordController.text,
                                          role: role,
                                          skill: skill,
                                        );
                                  } else if (role.isEmpty) {
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child:
                            isLoading
                                ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                : const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Already have account?
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () => context.push("/login"),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF3F2C2C)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Already have an account? Login',
                          style: TextStyle(
                            color: Color(0xFF3F2C2C),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
