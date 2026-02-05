import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import '../firebase/auth.dart';
import '../password_reset.dart';

class FacultyLogin extends StatefulWidget {
  const FacultyLogin({Key? key}) : super(key: key);

  @override
  State<FacultyLogin> createState() => _FacultyLoginState();
}

class _FacultyLoginState extends State<FacultyLogin> {
  static const String _title = 'Log In';
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isVisible = false;
  bool isClicked = false;

  Future<void> _social(bool google) async {
    try {
      if (google) {
        await Auth().signInWithGoogle(isStudent: false);
      } else {
        await Auth().signInWithMicrosoft(isStudent: false);
      }
      if (mounted) Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? e.code)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isKeyboardVisible = KeyboardVisibilityProvider.isKeyboardVisible(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(centerTitle: true, title: const Text(_title), backgroundColor: Colors.indigo[300]),
      body: GestureDetector(
        onTap: () => WidgetsBinding.instance.focusManager.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(children: <Widget>[
              isKeyboardVisible
                  ? SizedBox(width: 150, child: Image.asset("assets/images/keyboardLoad.gif"))
                  : Container(margin: const EdgeInsets.all(10), child: Image.asset("assets/icons/teacher_login.gif")),
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(20),
                  child: const Text('Faculty', style: TextStyle(fontSize: 30, fontFamily: 'Custom'))),
              Form(
                key: formKey,
                child: Column(children: [
                  Container(
                    padding: const EdgeInsets.only(left: 40, right: 40, bottom: 20),
                    child: TextFormField(
                      controller: emailController,
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-z]|[A-Z]|[0-9]|\.|@'))],
                      validator: (name) => (name == null || name.isEmpty) ? 'Enter Email Address' : null,
                      decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Email'),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 40, right: 40, bottom: 20),
                    child: TextFormField(
                      obscureText: !isVisible,
                      validator: (pswd) => (pswd == null || pswd.isEmpty) ? 'Enter Password' : null,
                      controller: passwordController,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'Password',
                          suffixIcon: IconButton(
                              onPressed: () => setState(() => isVisible = !isVisible), icon: const Icon(Icons.remove_red_eye))),
                    ),
                  ),
                  isClicked
                      ? FloatingActionButton(
                          heroTag: null,
                          onPressed: null,
                          backgroundColor: Colors.indigo[300],
                          child: const CircularProgressIndicator(color: Colors.white),
                        )
                      : FloatingActionButton.extended(
                          heroTag: null,
                          backgroundColor: Colors.indigo[300],
                          label: const Text('Log In', style: TextStyle(fontSize: 17)),
                          onPressed: () async {
                            setState(() => isClicked = true);
                            if (formKey.currentState!.validate()) {
                              try {
                                final ok = await Auth().signIn(
                                  username: emailController.text.trim(),
                                  password: passwordController.text,
                                  isStudent: false,
                                );
                                if (ok == true && mounted) {
                                  Navigator.of(context).pop();
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(content: Text("Wrong portal or user not found.")));
                                }
                              } on FirebaseAuthException catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? e.code)));
                              }
                            }
                            setState(() => isClicked = false);
                          },
                        ),
                  const SizedBox(height: 10),
                  FloatingActionButton.extended(
                    label: const Text('Forgot Password'),
                    heroTag: null,
                    backgroundColor: Colors.indigo[300],
                    onPressed: () async {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const ResetPassword()));
                    },
                  ),
                  const SizedBox(height: 10),
                  FloatingActionButton.extended(
                    label: const Text('Register'),
                    heroTag: null,
                    backgroundColor: Colors.indigo[100],
                    onPressed: () async {
                      try {
                        final ok = await Auth().createUser(
                            username: emailController.text.trim(), password: passwordController.text, isStudent: false);
                        if (ok == true && mounted) Navigator.of(context).pop();
                      } on FirebaseAuthException catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? e.code)));
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    OutlinedButton.icon(onPressed: () => _social(true), icon: const Icon(Icons.g_mobiledata), label: const Text('Google')),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(onPressed: () => _social(false), icon: const Icon(Icons.business), label: const Text('Microsoft')),
                  ])
                ]),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
