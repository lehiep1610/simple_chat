import 'package:flutter/material.dart';
import 'package:simple_chat/core/router/app_router.dart';
import 'package:simple_chat/core/router/route_names.dart';
import 'package:simple_chat/core/utils/validators.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../../domain/usecases/register_usecase.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // Controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _userNameController = TextEditingController();

  // Form key
  final _formKey = GlobalKey<FormState>();

  // Error messages
  String? _emailError;
  String? _userNameError;

  // Register usecase
  final RegisterUsecase _registerUsecase = sl<RegisterUsecase>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_onPasswordChanged);
  }

  void _onPasswordChanged() {
    setState(() {});
  }

  bool _arePasswordRequirementsMet() {
    final password = _passwordController.text;
    return Validators.hasValidLength(password) &&
        Validators.hasDigit(password) &&
        Validators.hasSpecialChar(password);
  }

  bool _isFormValid() {
    return _emailController.text.isNotEmpty &&
        _userNameController.text.isNotEmpty &&
        _arePasswordRequirementsMet();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _userNameController.dispose();
    _passwordController.removeListener(_onPasswordChanged);
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    // Reset errors
    setState(() {
      _emailError = null;
      _userNameError = null;
    });

    // Validate email
    final emailError = Validators.validateEmail(_emailController.text);
    if (emailError != null) {
      setState(() => _emailError = emailError);
    }

    // Validate username
    final userNameError = _validateUserName(_userNameController.text);
    if (userNameError != null) {
      setState(() => _userNameError = userNameError);
    }

    // If all valid, perform sign up
    if (emailError == null &&
        userNameError == null &&
        _arePasswordRequirementsMet()) {
      await _performSignUp();
    }
  }

  String? _validateUserName(String? userName) {
    if (userName == null || userName.isEmpty) {
      return 'Username is required';
    }
    if (userName.length < 3) {
      return 'Username must be at least 3 characters';
    }
    if (userName.length > 20) {
      return 'Username must be less than 20 characters';
    }
    return null;
  }

  Future<void> _performSignUp() async {
    setState(() => _isLoading = true);

    final result = await _registerUsecase.call(
      email: _emailController.text,
      password: _passwordController.text,
      name: _userNameController.text,
    );

    if (mounted) {
      result.fold(
        (failure) {
          ErrorHandler.handleFailure(context, failure);
        },
        (user) {
          SnackbarHelper.showSuccess(context, 'Account created successfully!');
          // Navigate back to login
          AppRouter.pop(context);
        },
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    'Create Account',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign up to get started',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  _UserNameField(
                    controller: _userNameController,
                    errorText: _userNameError,
                  ),
                  const SizedBox(height: 16),
                  _EmailField(
                    controller: _emailController,
                    errorText: _emailError,
                  ),
                  const SizedBox(height: 16),
                  _PasswordField(controller: _passwordController),
                  const SizedBox(height: 40),
                  _SignUpButton(
                    onPressed: _isFormValid() ? _handleSignUp : null,
                  ),
                  const SizedBox(height: 16),
                  _LoginLink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _UserNameField extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;

  const _UserNameField({required this.controller, this.errorText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: 'Username',
        hintText: 'Enter your username',
        errorText: errorText,
        prefixIcon: const Icon(Icons.person_outline),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

class _EmailField extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;

  const _EmailField({required this.controller, this.errorText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'Enter your email',
        errorText: errorText,
        prefixIcon: const Icon(Icons.email_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

class _PasswordField extends StatefulWidget {
  final TextEditingController controller;

  const _PasswordField({required this.controller});

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: widget.controller,
          obscureText: _obscureText,
          onTapOutside: (event) => FocusScope.of(context).unfocus(),
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            labelText: 'Password',
            hintText: 'Enter your password',
            prefixIcon: const Icon(Icons.lock_outline),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            suffixIcon: IconButton(
              onPressed: () => setState(() => _obscureText = !_obscureText),
              icon: Icon(
                _obscureText ? Icons.visibility : Icons.visibility_off,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        _PasswordRequirements(password: widget.controller.text),
      ],
    );
  }
}

class _PasswordRequirements extends StatelessWidget {
  final String password;

  const _PasswordRequirements({required this.password});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _RequirementItem(
          text: 'Password length is between 8-16',
          isValid: Validators.hasValidLength(password),
        ),
        const SizedBox(height: 4),
        _RequirementItem(
          text: 'Contains at least one digit',
          isValid: Validators.hasDigit(password),
        ),
        const SizedBox(height: 4),
        _RequirementItem(
          text: 'Contains at least one special character',
          isValid: Validators.hasSpecialChar(password),
        ),
      ],
    );
  }
}

class _RequirementItem extends StatelessWidget {
  final String text;
  final bool isValid;

  const _RequirementItem({required this.text, required this.isValid});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          isValid ? Icons.check_circle : Icons.check_circle_outline,
          size: 20,
          color: isValid
              ? Colors.green
              : Theme.of(context).colorScheme.onSurface.withAlpha(50),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: isValid
                ? Colors.green
                : Theme.of(context).colorScheme.onSurface.withAlpha(70),
          ),
        ),
      ],
    );
  }
}

class _SignUpButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const _SignUpButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Text('Sign Up'),
      ),
    );
  }
}

class _LoginLink extends StatelessWidget {
  const _LoginLink();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        TextButton(
          onPressed: () => AppRouter.pop(context),
          child: const Text('Login'),
        ),
      ],
    );
  }
}
