import 'package:flutter_test/flutter_test.dart';

int calculateFallbackRiskScore({
  required bool isValidNumber,
  required bool isSpam,
  required bool isFraud,
  required bool hfIsSpam,
  required int policeReports,
}) {
  int score = 10;
  if (!isValidNumber) score += 10;
  if (isSpam) score += 20;
  if (isFraud) score += 35;
  if (hfIsSpam) score += 20;
  score += (policeReports * 5).clamp(0, 25);
  return score.clamp(1, 100);
}

bool determineFinalIsScam({
  required bool isFraud,
  required bool isSpam,
  required bool hfIsSpam,
  required int policeReports,
  required bool aiSaysScam,
  required double riskScore,
}) {
  return isFraud ||
      isSpam ||
      hfIsSpam ||
      policeReports > 0 ||
      aiSaysScam ||
      riskScore >= 60;
}

void main() {
  group('Fallback Risk Score Calculation', () {
    test('Clean number with no flags returns base score of 10', () {
      final score = calculateFallbackRiskScore(
        isValidNumber: true,
        isSpam: false,
        isFraud: false,
        hfIsSpam: false,
        policeReports: 0,
      );
      expect(score, 10);
    });
 
    test('Invalid number adds 10 to score', () {
      final score = calculateFallbackRiskScore(
        isValidNumber: false,
        isSpam: false,
        isFraud: false,
        hfIsSpam: false,
        policeReports: 0,
      );
      expect(score, 20);
    });
 
    test('Fraud flag adds 35 to score', () {
      final score = calculateFallbackRiskScore(
        isValidNumber: true,
        isSpam: false,
        isFraud: true,
        hfIsSpam: false,
        policeReports: 0,
      );
      expect(score, 45);
    });
 
    test('Spam and HuggingFace spam flags combined adds 40 to score', () {
      final score = calculateFallbackRiskScore(
        isValidNumber: true,
        isSpam: true,
        isFraud: false,
        hfIsSpam: true,
        policeReports: 0,
      );
      expect(score, 50);
    });
 
    test('Police reports contribution is capped at 25 points', () {
      final score = calculateFallbackRiskScore(
        isValidNumber: true,
        isSpam: false,
        isFraud: false,
        hfIsSpam: false,
        policeReports: 10,
      );
      expect(score, 35);
    });
 
    test('All flags active returns score capped at 100', () {
      final score = calculateFallbackRiskScore(
        isValidNumber: false,
        isSpam: true,
        isFraud: true,
        hfIsSpam: true,
        policeReports: 10,
      );
      expect(score, 100);
    });
  });
 
  group('Final Verdict Determination', () {
    test('Clean entry with low risk score returns safe', () {
      final result = determineFinalIsScam(
        isFraud: false,
        isSpam: false,
        hfIsSpam: false,
        policeReports: 0,
        aiSaysScam: false,
        riskScore: 15,
      );
      expect(result, false);
    });
 
    test('Fraud flag alone triggers scam verdict', () {
      final result = determineFinalIsScam(
        isFraud: true,
        isSpam: false,
        hfIsSpam: false,
        policeReports: 0,
        aiSaysScam: false,
        riskScore: 10,
      );
      expect(result, true);
    });
 
    test('Police report count above 0 triggers scam verdict', () {
      final result = determineFinalIsScam(
        isFraud: false,
        isSpam: false,
        hfIsSpam: false,
        policeReports: 1,
        aiSaysScam: false,
        riskScore: 10,
      );
      expect(result, true);
    });
 
    test('AI scam flag triggers scam verdict', () {
      final result = determineFinalIsScam(
        isFraud: false,
        isSpam: false,
        hfIsSpam: false,
        policeReports: 0,
        aiSaysScam: true,
        riskScore: 10,
      );
      expect(result, true);
    });
 
    test('Risk score >= 60 triggers scam verdict', () {
      final result = determineFinalIsScam(
        isFraud: false,
        isSpam: false,
        hfIsSpam: false,
        policeReports: 0,
        aiSaysScam: false,
        riskScore: 60,
      );
      expect(result, true);
    });
 
    test('Risk score 59 with no flags returns safe', () {
      final result = determineFinalIsScam(
        isFraud: false,
        isSpam: false,
        hfIsSpam: false,
        policeReports: 0,
        aiSaysScam: false,
        riskScore: 59,
      );
      expect(result, false);
    });
  });
}