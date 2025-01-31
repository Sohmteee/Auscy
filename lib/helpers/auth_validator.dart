class AuthValidator {
  static String? validateName(String name) {
    if (name.isEmpty) {
      return null;
    }
    if (name.length < 2) {
      return 'Name must be at least 2 characters long';
    }
    return null; // Name is valid
  }

  static String? validateEmail(String email) {
    if (email.isEmpty) {
      return null;
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(email)) {
      return 'Invalid email address';
    }
    return null;
  }

  static String? validatePassword(String password) {
    if (password.isEmpty) {
      return null;
    }
    if (password.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!RegExp(r'\d').hasMatch(password)) {
      return 'Password must contain at least one digit';
    }
    return null; // Password is valid
  }

  static String? validateConfirmPassword(
      String password, String confirmPassword) {
    if (confirmPassword.isEmpty) {
      return null;
    }
    if (password != confirmPassword) {
      return 'Passwords do not match';
    }
    return null; // Passwords match
  }

  static String? validatePhoneNumber(String phone) {
    if (phone.isEmpty) {
      return null;
    }
    final phoneRegex = RegExp(r'^\+?[0-9]\d{1,14}$');
    if (!phoneRegex.hasMatch(phone)) {
      return 'Invalid phone number';
    }
    return null; // Phone number is valid
  }

  static String? validateOtp(String otp) {
    if (otp.isEmpty) {
      return null;
    }
    if (otp.length != 5) {
      return 'OTP must be 5 characters long';
    }
    return null; // OTP is valid
  }
}
