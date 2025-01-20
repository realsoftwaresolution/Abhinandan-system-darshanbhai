import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_web_rough_entry_system/common/widgets.dart';

class LoginDialog extends StatelessWidget {
  // Controllers to capture user input for username and password
  final TextEditingController usernameController = TextEditingController(text: 'A');
  final TextEditingController passwordController = TextEditingController(text: 'A');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  LoginDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Login'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          // To ensure the dialog doesn't take up too much space
          children: [
            TextFormField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your username';
                }
                return null; // No error
              },
            ),
            const SizedBox(height: 16),
            // Spacing between the username and password fields
            TextFormField(
              controller: passwordController,
              obscureText: true, // Hides the password input
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null; // No error
              },
            ),
          ],
        ),
      ),
      actions: [
        Obx(
          () => OutlinedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                await defaultController.login(
                    usernameController.text, passwordController.text);
              }
            },
            child: defaultController.isLoading.value
                ? const CupertinoActivityIndicator()
                : const Text('Login'),
          ),
        ),
      ],
    );
  }
}
