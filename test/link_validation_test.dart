import 'package:ScamTap/services/validation_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Link Validation', () {
    test('URL starting with https:// is valid', () {
      final result = ValidationService.isValidUrl('https://google.com');
      expect(result, true);
    });

    test('URL starting with http:// is valid', () {
      final result = ValidationService.isValidUrl('http://example.com');
      expect(result, true);
    });

    test('URL starting with www. is valid', () {
      final result = ValidationService.isValidUrl('www.scamsite.com');
      expect(result, true);
    });

    test('Suspicious URL with https:// prefix is still structurally valid', () {
      final result = ValidationService.isValidUrl('https://mayb4nk.com/login');
      expect(result, true);
    });

    test('URL without any valid prefix is invalid', () {
      final result = ValidationService.isValidUrl('google.com');
      expect(result, false);
    });

    test('Empty string is invalid', () {
      final result = ValidationService.isValidUrl('');
      expect(result, false);
    });

    test('Random text without URL format is invalid', () {
      final result = ValidationService.isValidUrl('not a link at all');
      expect(result, false);
    });
  });
}