import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simple_todo_app/services/auth.dart';
import 'package:simple_todo_app/widgets/submit_button_reusable.dart';
import 'package:simple_todo_app/widgets/textformfield_reusable.dart';
import 'package:get/get.dart';

class Login extends StatefulWidget {
  final FirebaseAuth auth;
  const Login({super.key, required this.auth});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  String? validateEmail(String? formEmail) {
    if (formEmail == null || formEmail.isEmpty) return 'Email can not be empty';
    String pattern = r'\w+@\w+\.\w+';
    RegExp reg = RegExp(pattern);
    if (!reg.hasMatch(formEmail)) return 'Invalid Email format';

    return null;
  }

  String? validatePassword(String? formPassword) {
    if (formPassword == null || formPassword.isEmpty) {
      return 'Password can not be empty';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30.0, 220.0, 30.0, 20.0),
          child: Form(
            key: _key,
            child: Column(
              children: [
                const Image(image: AssetImage('assets/option.png')),
                const SizedBox(height: 15),
                reusableTextField('Email Address', _emailController, false,
                    const Icon(Icons.person), validateEmail),
                const SizedBox(height: 15),
                reusableTextField('Password', _passwordController, true,
                    const Icon(Icons.lock), validatePassword),
                const SizedBox(height: 20),
                signInsignUp(context, 'LOGIN', () async {
                  if (_key.currentState!.validate()) {
                    String res = await Auth(auth: widget.auth).signInUser(
                        email: _emailController.text,
                        password: _passwordController.text);
                    if (res == 'Success') {
                      _emailController.clear();
                      _passwordController.clear();
                    } else {
                      Get.snackbar('ALERT', res);
                    }
                  }
                }),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () async {
                    if (_key.currentState!.validate()) {
                      String res = await Auth(auth: widget.auth)
                          .createNewAccount(
                              email: _emailController.text,
                              password: _passwordController.text);

                      if (res == 'Success') {
                        _emailController.clear();
                        _passwordController.clear();
                      } else {
                        Get.snackbar('ALERT', res);
                      }
                    }
                  },
                  child: const Text(
                    'Create New Account',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
                const SizedBox(height: 170),
                const Text(
                  'Coded By Keith Jason',
                  style: TextStyle(fontSize: 12),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
