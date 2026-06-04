class ValidationService {
  /// Check if a string field is empty
  static bool isEmptyField(String value) {
    return value.trim().isEmpty;
  }

  /// Check if passwords match
  static bool passwordsMatch(String password, String confirmPassword) {
    return password == confirmPassword;
  }

  /// Validate email format
  static String? validateEmail(String email) {
    if (email.trim().isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email';
    }

    return null; // Valid email
  }

  /// Validate password strength
  static String? validatePassword(String password) {
    if (password.isEmpty) {
      return 'Password is required';
    }

    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }

    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain uppercase letter';
    }

    if (!password.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain lowercase letter';
    }

    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain a number';
    }

    return null; // Valid password
  }

  /// Validate username
  static String? validateUsername(String username) {
    if (username.trim().isEmpty) {
      return 'Username is required';
    }

    if (username.length < 3) {
      return 'Username must be at least 3 characters';
    }

    if (username.length > 20) {
      return 'Username must not exceed 20 characters';
    }

    if (!RegExp(r'^[a-zA-Z0-9_-]+$').hasMatch(username)) {
      return 'Username can only contain letters, numbers, underscore and hyphen';
    }

    return null; // Valid username
  }

  /// Check if phone number is valid
  static bool isValidPhoneNumber(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    return RegExp(r'^\+?[0-9]{7,15}$').hasMatch(cleaned);
  }

  /// Check if URL is valid
  static bool isValidUrl(String url) {
    return url.startsWith('http://') ||
        url.startsWith('https://') ||
        url.startsWith('www.');
  }

  /// Validate all registration fields
  static Map<String, String?> validateRegistrationForm({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
  }) {
    return {
      'username': validateUsername(username),
      'email': validateEmail(email),
      'password': validatePassword(password),
      'confirmPassword': !passwordsMatch(password, confirmPassword)
          ? 'Passwords do not match'
          : null,
    };
  }

  /// Check if all required fields are filled
  static bool areAllFieldsFilled(List<String> fields) {
    return fields.every((field) => field.trim().isNotEmpty);
  }

  /// Check if form is valid (no errors)
  static bool isFormValid(Map<String, String?> errors) {
    return errors.values.every((error) => error == null);
  }

  /// Format phone number to standard format
  static String formatPhoneNumber(String phone) {
    String cleaned = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    if (cleaned.startsWith('+60')) return cleaned.replaceFirst('+', '');
    if (cleaned.startsWith('60')) return cleaned;
    if (cleaned.startsWith('0')) return '60${cleaned.substring(1)}';

    return cleaned;
  }

  /// Validate search input
  static String? validateSearchInput(String input) {
    if (input.trim().isEmpty) {
      return 'Please enter something to search';
    }

    if (input.length < 3) {
      return 'Search input must be at least 3 characters';
    }

    return null; // Valid
  }
}
