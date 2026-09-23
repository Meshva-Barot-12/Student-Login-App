class Validators {
  const Validators._();

  static String? required(String? value, {String field = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$field is required';
    }
    return null;
  }

  static String? emailOrUsername(String? value) {
    final requiredError = required(value, field: 'Email/Username');
    if (requiredError != null) return requiredError;
    final input = value!.trim();
    if (input.contains('@')) {
      final email = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
      if (!email.hasMatch(input)) return 'Enter a valid email address';
    }
    return null;
  }

  static String? email(String? value) {
    final requiredError = required(value, field: 'Email');
    if (requiredError != null) return requiredError;
    final email = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!email.hasMatch(value!.trim())) return 'Enter a valid email address';
    return null;
  }

  static String? mobile(String? value) {
    final requiredError = required(value, field: 'Mobile Number');
    if (requiredError != null) return requiredError;
    final digits = value!.replaceAll(RegExp(r'\D'), '');
    if (digits.length != 10) return 'Enter a valid 10-digit mobile number';
    return null;
  }

  static String? password(String? value) {
    final requiredError = required(value, field: 'Password');
    if (requiredError != null) return requiredError;
    if (value!.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    final requiredError = required(value, field: 'Confirm Password');
    if (requiredError != null) return requiredError;
    if (value != password) return 'Passwords do not match';
    return null;
  }
}
