class AuthResult {
  final bool success;
  final String message;
  final String? uid;

  AuthResult({
    required this.success,
    required this.message,
    this.uid,
  });
}
