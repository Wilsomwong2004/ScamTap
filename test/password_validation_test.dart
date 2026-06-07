import 'package:ScamTap/services/validation_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Password Validation', () {
    test('Empty password returns error', () {
      final result = ValidationService.validatePassword('');
      expect(result, 'Password is required');
    });

    test('Password shorter than 6 characters returns error', () {
      final result = ValidationService.validatePassword('Ab1');
      expect(result, 'Password must be at least 6 characters');
    });

    test('Password without uppercase letter returns error', () {
      final result = ValidationService.validatePassword('abcdef1');
      expect(result, 'Password must contain uppercase letter');
    });

    test('Password without lowercase letter returns error', () {
      final result = ValidationService.validatePassword('ABCDEF1');
      expect(result, 'Password must contain lowercase letter');
    });

    test('Password without number returns error', () {
      final result = ValidationService.validatePassword('Abcdefg');
      expect(result, 'Password must contain a number');
    });

    test('Valid password returns null', () {
      final result = ValidationService.validatePassword('Secure1');
      expect(result, null);
    });
  });
}


