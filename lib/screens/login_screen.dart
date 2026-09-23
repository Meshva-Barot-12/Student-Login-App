import 'package:flutter/material.dart';

import '../core/validators.dart';
import '../state/auth_controller.dart';
import '../widgets/app_logo.dart';
import '../widgets/auth_shell.dart';
import 'dashboard_screen.dart';
import 'registration_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.auth});

  final AuthController auth;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _quickFillDemoCredentials() {
    final account = widget.auth.account;
    final demoEmail = account?.email ?? 'meshva.barot@example.com';
    final demoPass = account?.password ?? 'Student@123';

    setState(() {
      _identifierController.text = demoEmail;
      _passwordController.text = demoPass;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF1E293B),
        content: Row(
          children: [
            const Icon(Icons.bolt_rounded, color: Colors.amberAccent),
            const SizedBox(width: 12),
            Expanded(child: Text('Auto-filled demo account for ${account?.fullName ?? "Meshva Barot"}!')),
          ],
        ),
      ),
    );
  }

  void _showSecurityModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.verified_user_rounded, color: Color(0xFF3559E0), size: 28),
                    SizedBox(width: 10),
                    Text('Portal Security Status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                const Divider(height: 24),
                const Text(
                  'Student Portal uses client-side state verification with protected route navigation and gesture interactions.',
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.touch_app_rounded, color: Colors.deepPurple, size: 20),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Gesture shortcuts enabled: Double-tap logo to auto-fill; Long-press for security info.',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.tonal(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final message = await widget.auth.login(
      emailOrUsername: _identifierController.text,
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (message != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF065F46),
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(child: Text(message)),
            ],
          ),
        ),
      );

      // Smooth navigation to Student Dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => DashboardScreen(auth: widget.auth),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color(0xFF991B1B),
          content: Row(
            children: [
              Icon(Icons.error_outline_rounded, color: Colors.white),
              SizedBox(width: 12),
              Expanded(child: Text('Login failed. Please check your credentials.')),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AuthShell(
      title: 'Welcome Back',
      subtitle: 'Sign in to access your student dashboard, view enrolled courses, and track academic metrics.',
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: AppLogo(
                    onDoubleTap: _quickFillDemoCredentials,
                    onLongPress: _showSecurityModal,
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    'Student Sign In',
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
                const SizedBox(height: 6),
                Center(
                  child: Text(
                    'Use your email or student name to continue',
                    style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _identifierController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Email / Username',
                    prefixIcon: Icon(Icons.person_outline_rounded),
                  ),
                  validator: Validators.emailOrUsername,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  onFieldSubmitted: (_) => _login(),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      icon: Icon(_obscurePassword ? Icons.visibility_rounded : Icons.visibility_off_rounded),
                    ),
                  ),
                  validator: Validators.password,
                ),
                const SizedBox(height: 22),
                AnimatedBuilder(
                  animation: widget.auth,
                  builder: (context, _) => FilledButton(
                    onPressed: widget.auth.isBusy ? null : _login,
                    child: widget.auth.isBusy
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('Login', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => RegistrationScreen(auth: widget.auth)),
                  ),
                  icon: const Icon(Icons.person_add_alt_1_rounded),
                  label: const Text('Create New Account'),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.5)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.info_outline_rounded, size: 16, color: Color(0xFF3559E0)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Demo: meshva.barot@example.com | Student@123',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade800),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.touch_app_outlined, size: 16, color: Colors.deepPurple),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Double-tap logo for Quick-Fill • Long-press for security',
                              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
