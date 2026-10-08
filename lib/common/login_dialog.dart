import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:real_web_rough_entry_system/app_theme.dart';
import 'package:real_web_rough_entry_system/common/components/app_button.dart';
import 'package:real_web_rough_entry_system/common/components/app_text_field.dart';
import 'package:real_web_rough_entry_system/common/widgets.dart';

class LoginDialog extends StatefulWidget {
  const LoginDialog({super.key});

  @override
  State<LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  final TextEditingController usernameController = TextEditingController(text: 'A');
  final TextEditingController passwordController = TextEditingController(text: 'A');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _loginButtonFocus = FocusNode();

  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _usernameFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    _usernameFocus.dispose();
    _passwordFocus.dispose();
    _loginButtonFocus.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      await defaultController.login(
        usernameController.text.trim(),
        passwordController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Center(
        child: Container(
          width: 420,
          constraints: const BoxConstraints(maxWidth: 420),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderLight, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo & Header
                  Center(
                    child: Container(
                      width: 56,
                      height: 56,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        "assets/images/logo.svg",
                        colorFilter: const ColorFilter.mode(
                          AppColors.primary,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Welcome to ERP System',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Real Software Solutions | Abhinandan Diamond',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Username Field
                  AppTextField(
                    label: 'Username',
                    controller: usernameController,
                    focusNode: _usernameFocus,
                    nextFocusNode: _passwordFocus,
                    autofocus: true,
                    prefixIcon: const Icon(Icons.person_outline_rounded, size: 20, color: AppColors.textSecondary),
                    hintText: 'Enter your username',
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your username';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password Field
                  AppTextField(
                    label: 'Password',
                    controller: passwordController,
                    focusNode: _passwordFocus,
                    obscureText: _obscurePassword,
                    prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20, color: AppColors.textSecondary),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        size: 20,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    hintText: 'Enter your password',
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _handleLogin(),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Login Button with Loading & Enter shortcut
                  Obx(
                    () => AppButton(
                      text: 'Sign In',
                      icon: Icons.login_rounded,
                      shortcutLabel: 'Enter',
                      height: 42,
                      isLoading: defaultController.isLoading.value,
                      onPressed: _handleLogin,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Press Enter in password field to sign in',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
