import 'dart:convert';
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'firestore_service.dart';

String _formatPhoneNumber(String value) {
  String cleaned = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');
  if (cleaned.startsWith('+60')) return cleaned.replaceFirst('+', '');
  if (cleaned.startsWith('60')) return cleaned;
  if (cleaned.startsWith('0')) return '60${cleaned.substring(1)}';
  return cleaned;
}

bool _isPhoneNumber(String value) {
  final cleaned = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');
  return RegExp(r'^\+?[0-9]{7,15}$').hasMatch(cleaned);
}

bool _isLink(String value) {
  final lower = value.toLowerCase().trim();
  return lower.startsWith('http://') ||
      lower.startsWith('https://') ||
      lower.startsWith('www.');
}

Future<Map<String, dynamic>> fetchData(String value) async {
  final String numverifyAPI = dotenv.env['NUMVERIFY_API_KEY'] ?? '';
  final String penipuMYAPI = dotenv.env['PENIPUMY_API_KEY'] ?? '';
  final String virustotalAPI = dotenv.env['VIRUSTOTAL_API_KEY'] ?? '';
  final String huggingfaceAPI = dotenv.env['HUGGINGFACE_API_KEY'] ?? '';

  Map<String, dynamic> result = {};

  if (_isPhoneNumber(value)) {
    final formattedPhone = _formatPhoneNumber(value);
    result['type'] = 'phone';

    try {
      final numverifyUrl = Uri.parse(
        'http://apilayer.net/api/validate?access_key=$numverifyAPI&number=$formattedPhone',
      );
      final numverifyResponse = await http.get(numverifyUrl);
      if (numverifyResponse.statusCode == 200) {
        final data = jsonDecode(numverifyResponse.body);
        if (data['success'] != false) {
          result['numverify'] = data;
        }
      }
    } catch (e) {
      log('Numverify error: $e');
    }

    try {
      final penipuUrl = Uri.parse(
        'https://penipu.my/api/v1/phone?q=$formattedPhone',
      );
      final penipuResponse = await http.get(
        penipuUrl,
        headers: {'X-API-Key': penipuMYAPI},
      );
      if (penipuResponse.statusCode == 200) {
        result['penipumy'] = jsonDecode(penipuResponse.body);
      }
    } catch (e) {
      log('PenipuMY exception: $e');
    }
  } else if (_isLink(value)) {
    result['type'] = 'link';

    try {
      final cleanUrl = value.startsWith('www.') ? 'https://$value' : value;
      final virustotalSubmitResponse = await http.post(
        Uri.parse('https://www.virustotal.com/api/v3/urls'),
        headers: {
          'x-apikey': virustotalAPI,
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'url=${Uri.encodeQueryComponent(cleanUrl)}',
      );

      if (virustotalSubmitResponse.statusCode == 200) {
        final submitData = jsonDecode(virustotalSubmitResponse.body);
        final analysisId = submitData['data']['id'];
        await Future.delayed(const Duration(seconds: 3));
        final reportResponse = await http.get(
          Uri.parse('https://www.virustotal.com/api/v3/analyses/$analysisId'),
          headers: {'x-apikey': virustotalAPI},
        );
        if (reportResponse.statusCode == 200) {
          final reportData = jsonDecode(reportResponse.body);
          result['virustotal'] = reportData['data']['attributes']['stats'] ?? {};
        }
      }
    } catch (e) {
      log('VirusTotal exception: $e');
    }
  } else {
    result['type'] = 'message';

    try {
      final hfResponse = await http.post(
        Uri.parse(
          'https://router.huggingface.co/hf-inference/models/mshenoda/roberta-spam/pipeline/text-classification',
        ),
        headers: {
          'Authorization': 'Bearer $huggingfaceAPI',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'inputs': value}),
      );

      if (hfResponse.statusCode == 200) {
        final hfData = jsonDecode(hfResponse.body);
        List predictions = [];
        if (hfData is List && hfData.isNotEmpty) {
          if (hfData[0] is List) {
            predictions = hfData[0];
          } else {
            predictions = hfData;
          }
        }
        final spamEntry = predictions.firstWhere(
          (p) => p['label'] == 'LABEL_1',
          orElse: () => {'score': 0.0},
        );
        final double spamScore = (spamEntry['score'] as num?)?.toDouble() ?? 0.0;
        result['huggingface'] = {
          'spam_score': spamScore,
          'is_spam': spamScore > 0.7,
        };
      }
    } catch (e) {
      log('HuggingFace exception: $e');
    }
  }

  await _getAIAnalysis(value, result);
  await _saveToFirebase(value, result);

  log('=== FINAL RESULT ===');
  log('AI Advice: ${result['ai_analysis']?['advice']}');

  return result;
}

Future<void> _getAIAnalysis(
  String value,
  Map<String, dynamic> result,
) async {
  final bool isValidNumber = result['numverify']?['valid'] ?? false;
  final bool isFraud = result['penipumy']?['fraud'] ?? false;
  final bool isSpam = result['penipumy']?['spam'] ?? false;
  final int policeReports = result['penipumy']?['police_report_count'] ?? 0;
  final bool hfIsSpam = result['huggingface']?['is_spam'] ?? false;
  final double hfSpamScore = (result['huggingface']?['spam_score'] as num?)?.toDouble() ?? 0.0;
  final int malicious = result['virustotal']?['malicious'] ?? 0;
  final int suspicious = result['virustotal']?['suspicious'] ?? 0;
  final String country = result['numverify']?['country_name'] ?? 'Unknown';
  final String carrier = result['numverify']?['carrier'] ?? 'Unknown';
  final String type = result['type'] ?? 'message';

  int riskScore = 10;
  if (type == 'phone' && !isValidNumber) riskScore += 10;
  if (isSpam) riskScore += 20;
  if (isFraud) riskScore += 35;
  if (policeReports > 0) riskScore += (policeReports * 5).clamp(0, 25).toInt();
  if (hfIsSpam) riskScore += 20;
  if (malicious > 0) riskScore += (malicious * 5).clamp(0, 30).toInt();
  if (suspicious > 0) riskScore += (suspicious * 3).clamp(0, 15).toInt();
  riskScore = riskScore.clamp(1, 100);

  final bool finalIsScam = isFraud || isSpam || policeReports > 0 || hfIsSpam || malicious > 0 || suspicious > 0 || riskScore >= 60;
  final String verdict = finalIsScam ? 'SCAM' : 'SAFE';
  final String confidence = (isFraud || policeReports > 0 || malicious > 0) ? 'high' : (isSpam || hfIsSpam || suspicious > 0) ? 'medium' : 'low';

  String prompt = '';

  if (type == 'phone') {
    prompt = '''
You are a scam prevention expert. Give safety advice for this phone number.

Phone number: "$value"
Risk score: $riskScore/100
Country: $country
Carrier: $carrier
Valid number: ${isValidNumber ? 'Yes' : 'No'}
Fraud reported: ${isFraud ? 'Yes' : 'No'}
Spam reported: ${isSpam ? 'Yes' : 'No'}
Police reports: $policeReports

Write 3 to 4 complete sentences of safety advice in plain text. Do not use bullet points, asterisks, markdown, or special characters. Just write normal sentences. Tell the user what to do.
''';
  } else if (type == 'link') {
    prompt = '''
You are a scam prevention expert. Give safety advice for this link.

Link: "$value"
Risk score: $riskScore/100
Malicious engines: $malicious
Suspicious engines: $suspicious

Write 3 to 4 complete sentences of safety advice in plain text. Do not use bullet points, asterisks, markdown, or special characters. Just write normal sentences. Tell the user what to do.
''';
  } else {
    prompt = '''
You are a scam prevention expert. Give safety advice for this message.

Message: "$value"
Risk score: $riskScore/100
Spam probability: ${(hfSpamScore * 100).toStringAsFixed(0)}%
Likely spam: ${hfIsSpam ? 'Yes' : 'No'}

Write 3 to 4 complete sentences of safety advice in plain text. Do not use bullet points, asterisks, markdown, or special characters. Just write normal sentences. Tell the user what to do.
''';
  }

  String aiAdvice = '';

  try {
    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? 'AIzaSyDkVcm9kTtCz6MRd8PuClV5-TX5n-Rcnl4';
    
    log('Calling Gemini API for $type...');
    
    final response = await http.post(
      Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-flash-latest:generateContent?key=$apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': prompt}
            ]
          }
        ],
        'generationConfig': {
          'temperature': 0.7,
          'maxOutputTokens': 400,
          'topP': 0.95,
        }
      }),
    );
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      aiAdvice = data['candidates']?[0]?['content']?['parts']?[0]?['text'] ?? '';
      
      // Clean up the response - remove any special characters
      aiAdvice = aiAdvice
          .replaceAll('*', '')
          .replaceAll('-', '')
          .replaceAll('```', '')
          .replaceAll('markdown', '')
          .replaceAll('Actionable Advice', '')
          .replaceAll('Next steps/monitoring', '')
          .replaceAll(':', '')
          .trim();
      
      // Clean up multiple spaces
      aiAdvice = aiAdvice.replaceAll(RegExp(r'\s+'), ' ');
      
      // If the advice starts with a number or bullet, clean it
      if (aiAdvice.startsWith(RegExp(r'[\d\*\-•]'))) {
        aiAdvice = aiAdvice.substring(aiAdvice.indexOf(' ') + 1);
      }
      
      log('AI Advice: $aiAdvice');
      log('AI Advice length: ${aiAdvice.length}');
    } else {
      log('Gemini API error: ${response.statusCode}');
      aiAdvice = 'Unable to generate advice. Please try again later.';
    }
    
    if (aiAdvice.isEmpty || aiAdvice.length < 20) {
      aiAdvice = 'Based on our analysis, this ${type == 'phone' ? 'phone number' : type == 'link' ? 'link' : 'message'} has a risk score of $riskScore/100. We recommend avoiding any interaction and reporting suspicious activity through our app.';
    }
    
  } catch (e) {
    log('AI generation failed: $e');
    aiAdvice = 'Unable to connect to AI service. Please check your internet connection and try again.';
  }

  result['ai_analysis'] = {
    'advice': aiAdvice,
    'is_scam': finalIsScam,
    'confidence': confidence,
    'risk_score': riskScore,
  };

  result['is_scam'] = finalIsScam;
  result['verdict'] = verdict;
  result['risk_score'] = riskScore;
}

Future<void> _saveToFirebase(
  String value,
  Map<String, dynamic> result,
) async {
  try {
    final firestoreService = FirestoreService();
    final int riskScore = result['risk_score'] ?? 0;

    Map<String, dynamic> detail = {};

    if (_isPhoneNumber(value)) {
      detail = {
        'type': result['type'] ?? 'phone',
        'numverify': result['numverify'] ?? {},
        'penipumy': result['penipumy'] ?? {},
        'ai_analysis': result['ai_analysis'] ?? {},
        'verdict': result['verdict'] ?? 'UNKNOWN',
        'is_scam': result['is_scam'] ?? false,
        'risk_score': riskScore,
      };
    } else if (_isLink(value)) {
      detail = {
        'type': result['type'] ?? 'link',
        'virustotal': result['virustotal'] ?? {},
        'ai_analysis': result['ai_analysis'] ?? {},
        'verdict': result['verdict'] ?? 'UNKNOWN',
        'is_scam': result['is_scam'] ?? false,
        'risk_score': riskScore,
      };
    } else {
      detail = {
        'type': result['type'] ?? 'message',
        'huggingface': {
          'spam_score': result['huggingface']?['spam_score'] ?? 0.0,
          'is_spam': result['huggingface']?['is_spam'] ?? false,
        },
        'ai_analysis': result['ai_analysis'] ?? {},
        'verdict': result['verdict'] ?? 'UNKNOWN',
        'is_scam': result['is_scam'] ?? false,
        'risk_score': riskScore,
      };
    }

    await firestoreService.saveSearchRecord(
      type: result['type'] ?? 'unknown',
      value: value,
      riskScore: riskScore,
      detail: detail,
    );
  } catch (e) {
    log('Database save error: $e');
  }
}