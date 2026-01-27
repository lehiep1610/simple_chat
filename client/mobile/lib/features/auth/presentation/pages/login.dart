import 'package:flutter/material.dart';
import 'package:simple_chat/core/router/app_router.dart';
import 'package:simple_chat/core/router/route_names.dart';
import 'package:simple_chat/core/theme/theme_provider.dart';
import 'package:simple_chat/core/utils/either_extension.dart';
import 'package:simple_chat/core/utils/validators.dart';
import 'package:simple_chat/core/widgets/app_button.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../../domain/usecases/login_usecase.dart';

class LoginPage extends StatefulWidget {
  final ThemeProvider themeProvider;
  const LoginPage({super.key, required this.themeProvider});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controller for text fields
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  //Error messages
  String? _emailError;

  // Login usecase
  final LoginUsecase _loginUsecase = sl<LoginUsecase>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController.text = 'test@gmail.com';
    _passwordController.text = '12345678a@';
    _passwordController.addListener(_onPasswordChanged);
  }

  void _onPasswordChanged() {
    setState(() {});
  }

  bool _arePasswordRequirements() {
    final password = _passwordController.text;
    return Validators.hasValidLength(password) &&
        Validators.hasDigit(password) &&
        Validators.hasSpecialChar(password);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordController.removeListener(_arePasswordRequirements);
    super.dispose();
  }

  Future<void> _handleLogin() async {
    // Reset errors
    setState(() {
      _emailError = null;
    });

    //Validate email
    final emailError = Validators.validateEmail(_emailController.text);
    if (emailError != null) {
      setState(() {
        _emailError = emailError;
      });
    }

    // If both are valid, perform login
    if (emailError == null && _arePasswordRequirements()) {
      await _performLogin();
    }
  }

  Future<void> _performLogin() async {
    setState(() {
      _isLoading = true;
    });
    final result = await _loginUsecase.call(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (mounted) {
      result.handleResult(
        context,
        onSuccess: (user) {
          SnackbarHelper.showSuccess(context, 'Login successful!');
          // Navigate to home page
          AppRouter.navigateAndReplace(context, RouteNames.home);
        },
        onError: (failure) {
          ErrorHandler.handleFailure(context, failure);
        },
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoginEnabled = _arePasswordRequirements();
    return LoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, kToolbarHeight),
          child: _AppBar(themeProvider: widget.themeProvider),
        ),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.12),
                    Text(
                      'Welcome to\nSimple Chat!',
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    _EmailField(
                      controller: _emailController,
                      errorText: _emailError,
                    ),
                    SizedBox(height: 16),
                    _PasswordField(controller: _passwordController),
                    SizedBox(height: 40),
                    AppButton.primary(
                      text: 'Login',
                      onPressed: isLoginEnabled ? _handleLogin : null,
                      isLoading: _isLoading,
                    ),
                    SizedBox(height: 16),
                    AppButton.primary(
                      text: 'Sign up',
                      onPressed: () {
                        AppRouter.navigateTo(context, RouteNames.register);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  final ThemeProvider themeProvider;
  const _AppBar({required this.themeProvider});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        Switch(
          activeTrackColor: Colors.white,
          activeThumbColor: Colors.blue,
          value: themeProvider.isDarkMode,
          onChanged: (value) {
            themeProvider.toggleTheme();
          },
        ),
      ],
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
        prefixIcon: const Icon(Icons.email_outlined),
        labelText: 'Email',
        errorText: errorText,
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
      crossAxisAlignment: .start,
      children: [
        TextField(
          controller: widget.controller,
          obscureText: _obscureText,
          onTapOutside: (event) => FocusScope.of(context).unfocus(),
          onChanged: (value) {
            setState(() {});
          },
          autocorrect: false,
          decoration: InputDecoration(
            labelText: 'Password',
            prefixIcon: const Icon(Icons.lock_outline),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
              icon: Icon(
                _obscureText ? Icons.visibility : Icons.visibility_off,
              ),
            ),
          ),
        ),
        SizedBox(height: 12),
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
    final hasDigit = Validators.hasDigit(password);
    final hasValidLength = Validators.hasValidLength(password);
    final hasSpecialChar = Validators.hasSpecialChar(password);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _RequirementItem(
          text: 'Password length is between 8-16',
          isValid: hasValidLength,
        ),
        SizedBox(height: 4),
        _RequirementItem(
          text: 'Contains at least one digit',
          isValid: hasDigit,
        ),
        SizedBox(height: 4),
        _RequirementItem(
          text: 'Contains at least one special character',
          isValid: hasSpecialChar,
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
        // Check icon - shows checkmark when valid
        Icon(
          isValid ? Icons.check_circle : Icons.check_circle_outline,
          size: 20,
          color: isValid
              ? Colors.green
              : Theme.of(context).colorScheme.onSurface.withAlpha(50),
        ),
        SizedBox(width: 8),
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
