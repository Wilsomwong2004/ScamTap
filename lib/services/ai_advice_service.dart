import 'dart:developer';
import 'package:firebase_ai/firebase_ai.dart';

class AIAdviceService {
  static Future<String> generateAdvice({
    required String input,
    required String type,
    required int riskScore,
    required String verdict,
  }) async {
    try {
      final model = FirebaseAI.googleAI().generativeModel(
        model: 'gemini-2.5-flash',
      );

      final prompt = '''
You are a scam prevention assistant for a mobile app called ScamTap.

The user scanned a $type.

Input:
$input

Scan result:
- Verdict: $verdict
- Risk score: $riskScore/100

Write 3 short sentences of safety advice for the user.
Use simple English.
Do not use markdown.
Do not use bullet points.
Do not mention that you are an AI.
''';

      final response = await model.generateContent([
        Content.text(prompt),
      ]);

      final text = response.text?.trim() ?? '';

      if (text.isEmpty) {
        throw Exception('AI returned empty response');
      }

      return text;
    } catch (e) {
      log('AI advice generation failed: $e');

      return _fallbackAdvice(
        type: type,
        riskScore: riskScore,
        verdict: verdict,
      );
    }
  }

  static String _fallbackAdvice({
    required String type,
    required int riskScore,
    required String verdict,
  }) {
    if (verdict.toUpperCase() == 'SCAM' || riskScore >= 60) {
      return 'This $type looks suspicious based on the scan result. Do not reply, click links, send money, or share OTP codes. Verify the source through an official website or hotline before taking any action.';
    }

    return 'This $type does not show strong scam signs based on the scan result. However, stay careful if it asks for money, passwords, OTP codes, or personal details. Always verify unknown sources before responding.';
  }
}