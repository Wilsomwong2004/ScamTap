import 'package:flutter_test/flutter_test.dart';

String classifyRiskScore(int score) {
  if (score >= 75) return 'High Risk';
  if (score >= 40) return 'Warning';
  return 'Safe';
}

void main() {
  group('Risk Score Validation Logic', () {
    test('Score 0 is classified as Safe', () {
      expect(classifyRiskScore(0), 'Safe');
    });

    test('Score 15 is classified as Safe', () {
      expect(classifyRiskScore(15), 'Safe');
    });

    test('Score 39 is classified as Safe (boundary)', () {
      expect(classifyRiskScore(39), 'Safe');
    });

    test('Score 40 is classified as Warning (boundary)', () {
      expect(classifyRiskScore(40), 'Warning');
    });

    test('Score 60 is classified as Warning', () {
      expect(classifyRiskScore(60), 'Warning');
    });

    test('Score 74 is classified as Warning (boundary)', () {
      expect(classifyRiskScore(74), 'Warning');
    });

    test('Score 75 is classified as High Risk (boundary)', () {
      expect(classifyRiskScore(75), 'High Risk');
    });

    test('Score 100 is classified as High Risk', () {
      expect(classifyRiskScore(100), 'High Risk');
    });
  });
}