class Validators {
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  static bool isValidPassword(String password) {
    return password.length >= 6;
  }

  static bool isValidPhoneNumber(String phoneNumber) {
    // Adaptado para formato brasileiro
    final phoneRegex = RegExp(r'^\d{10,11}$');
    return phoneRegex.hasMatch(phoneNumber.replaceAll(RegExp(r'\D'), ''));
  }

  static bool isValidName(String name) {
    return name.length >= 3;
  }
}