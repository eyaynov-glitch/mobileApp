import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = 'Student';
  bool _isLogin = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _isInstitutionalEmail(String email) {
    return email.trim().toLowerCase().endsWith('@arabaskenov.com');
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_isLogin) {
      context.go('/student');
    } else {
      context.go('/student');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome back')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              _isLogin ? 'Login' : 'Create account',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Use your institutional email for password login.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required.';
                      }
                      if (_isLogin && !_isInstitutionalEmail(value)) {
                        return 'Use your @arabaskenov.com email.';
                      }
                      if (!_isLogin && !_isInstitutionalEmail(value)) {
                        return 'Institutional email required for signup.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.length < 6) {
                        return 'Password must be 6+ characters.';
                      }
                      return null;
                    },
                  ),
                  if (!_isLogin) ...[
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedRole,
                      decoration:
                          const InputDecoration(labelText: 'Select role'),
                      items: const [
                        DropdownMenuItem(value: 'Student', child: Text('Student')),
                        DropdownMenuItem(value: 'Teacher', child: Text('Teacher')),
                        DropdownMenuItem(value: 'Admin', child: Text('Admin')),
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() => _selectedRole = value);
                      },
                    ),
                  ],
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _submit,
                      child: Text(_isLogin ? 'Login' : 'Register'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => setState(() => _isLogin = !_isLogin),
                    child: Text(
                      _isLogin
                          ? 'Need an account? Register'
                          : 'Have an account? Login',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Or continue with',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _SocialButton(
                  label: 'Google',
                  icon: Icons.g_mobiledata,
                  onTap: () {},
                ),
                _SocialButton(
                  label: 'Facebook',
                  icon: Icons.facebook,
                  onTap: () {},
                ),
                _SocialButton(
                  label: 'Microsoft',
                  icon: Icons.window,
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label),
    );
  }
}
