import 'package:ScamTap/services/validation_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Email Validation', () {
    test('Empty email returns error', () {
      final result = ValidationService.validateEmail('');
      expect(result, 'Email is required');
    });

    test('Email without @ symbol returns error', () {
      final result = ValidationService.validateEmail('invalidemail.com');
      expect(result, 'Please enter a valid email');
    });

    test('Email without domain returns error', () {
      final result = ValidationService.validateEmail('user@');
      expect(result, 'Please enter a valid email');
    });

    test('Email without TLD returns error', () {
      final result = ValidationService.validateEmail('user@domain');
      expect(result, 'Please enter a valid email');
    });

    test('Valid email returns null', () {
      final result = ValidationService.validateEmail('user@example.com');
      expect(result, null);
    });

    test('Valid email with subdomain returns null', () {
      final result = ValidationService.validateEmail('user@mail.example.com');
      expect(result, null);
    });
  });
}