import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  String? error;

  Future<void> _run(Future<void> Function() action) async {
    try {
      setState(() => error = null);
      await action();
    } catch (e) {
      setState(() => error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('YCL Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Ynov email')),
            TextField(controller: passCtrl, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
            if (error != null) Text(error!, style: const TextStyle(color: Colors.red)),
            ElevatedButton(
              onPressed: () => _run(() async => AuthService.instance.loginWithEmail(email: emailCtrl.text, password: passCtrl.text)),
              child: const Text('Login'),
            ),
            OutlinedButton(onPressed: () => _run(() async => AuthService.instance.loginWithGoogle()), child: const Text('Google Login')),
            OutlinedButton(onPressed: () => _run(() async => AuthService.instance.loginWithMicrosoft()), child: const Text('Microsoft Login')),
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterPage())),
              child: const Text('Create account'),
            ),
          ],
        ),
      ),
    );
  }
}
