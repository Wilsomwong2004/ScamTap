import 'package:ScamTap/services/validation_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Message Validation', () {
    test('Empty message returns error', () {
      final result = ValidationService.validateSearchInput('');
      expect(result, 'Please enter something to search');
    });

    test('Whitespace-only input returns error', () {
      final result = ValidationService.validateSearchInput('   ');
      expect(result, 'Please enter something to search');
    });

    test('Message shorter than 3 characters returns error', () {
      final result = ValidationService.validateSearchInput('hi');
      expect(result, 'Search input must be at least 3 characters');
    });

    test('Valid normal message returns null', () {
      final result = ValidationService.validateSearchInput('How are you today?');
      expect(result, null);
    });

    test('Valid scam-like message returns null (passes input validation)', () {
      final result = ValidationService.validateSearchInput(
          'Congratulations! You have won a free prize. Click here to claim.');
      expect(result, null);
    });

    test('Message with exactly 3 characters returns null', () {
      final result = ValidationService.validateSearchInput('hey');
      expect(result, null);
    });
  });
}