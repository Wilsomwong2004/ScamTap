import 'package:ScamTap/services/validation_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Phone Number Validation', () {
    test('Valid Malaysian phone number returns true', () {
      final result = ValidationService.isValidPhoneNumber('0123456789');
      expect(result, true);
    });

    test('Valid international format with +60 returns true', () {
      final result = ValidationService.isValidPhoneNumber('+60123456789');
      expect(result, true);
    });

    test('Phone number with spaces is cleaned and valid', () {
      final result = ValidationService.isValidPhoneNumber('012 345 6789');
      expect(result, true);
    });

    test('Phone number with dashes is cleaned and valid', () {
      final result = ValidationService.isValidPhoneNumber('012-345-6789');
      expect(result, true);
    });

    test('Too short number returns false', () {
      final result = ValidationService.isValidPhoneNumber('123');
      expect(result, false);
    });

    test('Non-numeric input returns false', () {
      final result = ValidationService.isValidPhoneNumber('abcdefg');
      expect(result, false);
    });

    test('Empty string returns false', () {
      final result = ValidationService.isValidPhoneNumber('');
      expect(result, false);
    });
  });
}