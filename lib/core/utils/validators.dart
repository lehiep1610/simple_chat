class Validators {
  // Validate email
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) return 'Invalid email';
    // Regex pattern cho email
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(email)) {
      return 'Invalid email';
    }

    return null; // Valid
  }

  // Check if password has at least one digit
  static bool hasDigit(String password) {
    return RegExp(r'[0-9]').hasMatch(password);
  }

  // Check if password has at least one letter
  static bool hasLetter(String password) {
    return RegExp(r'[a-zA-Z]').hasMatch(password);
  }

  // Check if password has at least one special character
  static bool hasSpecialChar(String password) {
    return RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
  }

  // Check if password length is between 8-16
  static bool hasValidLength(String password) {
    return password.length >= 8 && password.length <= 16;
  }
}
