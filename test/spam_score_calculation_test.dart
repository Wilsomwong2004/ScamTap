import 'package:flutter_test/flutter_test.dart';

double calculateSpamScore(String message) {
  final spamKeywords = [
    'winner',
    'prize',
    'claim',
    'free',
    'urgent',
    'bank account',
    'verify',
    'click here',
    'limited offer',
    'congratulations',
  ];

  int matchCount = 0;
  final lowerMsg = message.toLowerCase();

  for (final keyword in spamKeywords) {
    if (lowerMsg.contains(keyword)) matchCount++;
  }

  return (matchCount / spamKeywords.length) * 100;
}

void main() {
  group('Spam Score Calculation', () {
    test('Normal message has 0% spam score', () {
      final score = calculateSpamScore('How are you doing today?');
      expect(score, 0.0);
    });

    test('Empty message has 0% spam score', () {
      final score = calculateSpamScore('');
      expect(score, 0.0);
    });

    test('Message with one spam keyword has non-zero spam score', () {
      final score = calculateSpamScore('You are the winner of this draw.');
      expect(score, greaterThan(0));
    });

    test('Message with one spam keyword has score below 50%', () {
      final score = calculateSpamScore('You are the winner of this draw.');
      expect(score, lessThan(50));
    });

    test('Message with multiple spam keywords has score above 30%', () {
      final score = calculateSpamScore(
        'Congratulations! You are the winner. Claim your free prize now. Urgent: click here.',
      );
      expect(score, greaterThan(30));
    });

    test('Message with all spam keywords returns 100% spam score', () {
      final score = calculateSpamScore(
        'winner prize claim free urgent bank account verify click here limited offer congratulations',
      );
      expect(score, 100.0);
    });

    test('Case-insensitive matching works correctly', () {
      final score1 = calculateSpamScore('WINNER PRIZE FREE');
      final score2 = calculateSpamScore('winner prize free');
      expect(score1, equals(score2));
    });
  });
}