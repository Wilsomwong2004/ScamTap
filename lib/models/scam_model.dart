import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;


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
  return value.startsWith('http://') ||
      value.startsWith('https://') ||
      value.startsWith('www.');
}


Future<Map<String, dynamic>> fetchData(String value) async {
  String numverifyAPI = dotenv.env['NUMVERIFY_API_KEY'] ?? '';
  String penipuMYAPI = dotenv.env['PENIPUMY_API_KEY'] ?? '';
  String virustotalAPI = dotenv.env['VIRUSTOTAL_API_KEY'] ?? '';
  String huggingfaceAPI = dotenv.env['HUGGINGFACE_API_KEY'] ?? '';

  Map<String, dynamic> result = {};

  if (_isPhoneNumber(value)) {
    final formattedPhone = _formatPhoneNumber(value);

    result['type'] = 'phone';

    try {
      final numverifyUrl = Uri.parse(
        "http://apilayer.net/api/validate?access_key=$numverifyAPI&number=$formattedPhone"
      );
      print("Numverify API: $numverifyAPI");
      print("Numverify URL: $numverifyUrl");
      final numverifyResponse = await http.get(numverifyUrl);

      print("Numverify Status: ${numverifyResponse.statusCode}");
      print("Numverify Raw Body: ${numverifyResponse.body}");

      if (numverifyResponse.statusCode == 200) {
        final data = jsonDecode(numverifyResponse.body);
        
        if (data['success'] == false) {
          log("Numverify API error: ${data['error']}"); 
        } else {
          result['numverify'] = data;
          print("Numverify: ${result['numverify']}");
        }
      }
    } catch (e) {
      print("Numverify error: $e");
    }

    try {
      final penipuUrl = Uri.parse(
        "https://penipu.my/api/v1/phone?q=$formattedPhone"
      );
      final penipuResponse = await http.get(
        penipuUrl,
        headers: {
          "X-API-Key": penipuMYAPI,
        },
      );

      if (penipuResponse.statusCode == 200) {
        result['penipumy'] = jsonDecode(penipuResponse.body);
        print("PenipuMY: ${result['penipumy']}");
      } else if (penipuResponse.statusCode == 429) {
        log("PenipuMY: Rate limit reached!");
      } else {
        log("PenipuMY error: ${penipuResponse.statusCode}");
        log("PenipuMY body: ${penipuResponse.body}");
      }
    } catch (e) {
      log("PenipuMY exception: $e");
    }
  } else if (_isLink(value)) {
    result['type'] = 'link';
    log('link');

    print("VirusTotal API Key: '$virustotalAPI'");
    print("URL value: '$value'");

    try {
      final virustotalUrlResponse = await http.post(
        Uri.parse("https://www.virustotal.com/api/v3/urls"),
        headers: {
          "x-apikey"     : virustotalAPI,
          "Content-Type" : "application/x-www-form-urlencoded",
        },
        body: "url=$value",
      );

      if (virustotalUrlResponse.statusCode != 200) {
        log("VirusTotal submit error: ${virustotalUrlResponse.statusCode}");
        result['error'] = 'VirusTotal submit failed: ${virustotalUrlResponse.statusCode}';
        return result;
      }

      final submitData = jsonDecode(virustotalUrlResponse.body);
      final analysisId = submitData['data']['id'];
      print("VirusTotal Analysis ID: $analysisId");

      if (virustotalUrlResponse.statusCode == 200) {
        result['virustotal'] = jsonDecode(virustotalUrlResponse.body);
        print("Virustotal: ${result['virustotal']}");
      }

      await Future.delayed(Duration(seconds: 3));

      final reportResponse = await http.get(
        Uri.parse("https://www.virustotal.com/api/v3/analyses/$analysisId"),
        headers: {"x-apikey": virustotalAPI},
      );

      if (reportResponse.statusCode == 200) {
        final reportData = jsonDecode(reportResponse.body);
        final stats = reportData['data']['attributes']['stats'];

        result['virustotal'] = stats;
        result['virustotal_flagged'] = (stats['malicious'] ?? 0) > 0;

        log("VirusTotal stats: $stats");
      }

    } catch (e) {
      log("VirusTotal exception: $e");
    }

  } else {
    result['type'] = 'message';
    
    try {
      final hfResponse = await http.post(
        Uri.parse("https://router.huggingface.co/hf-inference/models/mshenoda/roberta-spam/pipeline/text-classification"),
        headers: {
          "Authorization" : "Bearer $huggingfaceAPI",
          "Content-Type"  : "application/json",
        },
        body: jsonEncode({"inputs": value}),
      );

      print("HuggingFace Status: ${hfResponse.statusCode}");
      print("HuggingFace Body: ${hfResponse.body}");
      print("HuggingFace API: '$huggingfaceAPI'");

      if (hfResponse.statusCode == 200) {
        final hfData = jsonDecode(hfResponse.body);

        final List predictions = hfData[0];
        final spamEntry = predictions.firstWhere(
          (p) => p['label'] == 'LABEL_1',
          orElse: () => {'score': 0.0},
        );

        final double spamScore = (spamEntry['score'] as num).toDouble();
        result['huggingface'] = {
          'spam_score': spamScore,
          'is_spam': spamScore > 0.7,
          'raw': hfData,
        };

        print("HuggingFace Spam Score: $spamScore");
      }
    } catch (e) {
      log("HuggingFace exception: $e");
    }

  }

  await _scamAnalysis(value, result);
  await _saveToFirebase(value, result);

  return result;
  
}

Future<void> _scamAnalysis(String value, Map<String, dynamic> result) async {

  bool isValidNumber = result['numverify']?['valid'] ?? false;
  bool isFraud = result['penipumy']?['fraud']  ?? false;
  bool isSpam = result['penipumy']?['spam']   ?? false;
  int  policeReports = result['penipumy']?['police_report_count'] ?? 0;
  bool   hfIsSpam    = result['huggingface']?['is_spam']    ?? false;
  double hfSpamScore = (result['huggingface']?['spam_score'] as num?)?.toDouble() ?? 0.0;

  try {
    final model = FirebaseAI.googleAI().templateGenerativeModel();

    final String type = result['type'] ?? 'message';
    String extraData;
        if (type == 'phone') {
          extraData = jsonEncode({
            'numverify' : result['numverify'] ?? {},
            'penipumy'  : result['penipumy']  ?? {},
          });
        } else if (type == 'link') {
          extraData = jsonEncode(result['virustotal'] ?? {});
        } else {
          extraData = jsonEncode({
            'huggingface_spam_score' : hfSpamScore,
            'huggingface_is_spam'    : hfIsSpam,
          });
        }

    log("Calling AI with type: $type");

    final response = await model.generateContent(
      'scam-analysis',
      inputs: {
        'type': type,
        'value': value,
        'isValid': isValidNumber.toString(),
        'isFraud': isFraud.toString(),
        'isSpam': (isSpam || hfIsSpam).toString(), 
        'policeReports': policeReports.toString(),
        'extraData': extraData,
      },
    );

    final aiText = response.text ?? '';
    log("AI Raw: $aiText");

    if (aiText.isEmpty) {
      log("AI returned empty response!");
      return;
    }

    final cleanJson = aiText
        .replaceAll('```json', '')
        .replaceAll('```', '')
        .trim();

    final aiJson = jsonDecode(cleanJson);
    result['ai_analysis'] = aiJson;

    final double aiRiskScore = (aiJson['risk_score'] as num?)?.toDouble() ?? 50;
    result['risk_score']  = aiRiskScore;

    log("AI Risk Score : $aiRiskScore / 100");
    log("AI Analysis   : $aiJson");

  } catch (e) {
    log("AI exception: $e");

    int fallbackScore = 10;
    if (!isValidNumber) fallbackScore += 10;
    if (isSpam)         fallbackScore += 20;
    if (isFraud)        fallbackScore += 35;
    if (hfIsSpam)       fallbackScore += 20;
    fallbackScore += (policeReports * 5).clamp(0, 25);
    result['risk_score'] = fallbackScore.clamp(1, 100);
  }

  bool aiSaysScam = result['ai_analysis']?['is_scam'] ?? false;
  double riskScore = (result['risk_score'] as num?)?.toDouble() ?? 50;
  bool finalIsScam = isFraud || isSpam || hfIsSpam || policeReports > 0 || aiSaysScam || riskScore >= 60;

  result['is_scam'] = finalIsScam;
  result['verdict'] = finalIsScam ? 'SCAM' : 'SAFE';

  log("Final verdict : ${result['verdict']}");
  log("Final score : $riskScore / 100");
}

Future<void> _saveToFirebase(String value, Map<String, dynamic> result) async {
  try {
    final db = FirebaseFirestore.instance;

    if (_isPhoneNumber(value)) {
      await db.collection('scam_checks').add({
        'value'      : value,
        'type'       : result['type'],
        'numverify'  : result['numverify']  ?? null,
        'penipumy'   : result['penipumy']   ?? null,
        'is_scam'    : result['is_scam']    ?? false,
        'risk_score' : result['risk_score'] ?? 0,
        'verdict'    : result['verdict']    ?? 'UNKNOWN',
        'ai_analysis': result['ai_analysis'] ?? null,
        'checked_at' : FieldValue.serverTimestamp(),
      });
    } else if (_isLink(value)) {
      await db.collection('scam_checks').add({
        'value'      : value,
        'type'       : result['type'],
        'virustotal' : result['virustotal'] ?? null,
        'is_scam'    : result['is_scam']    ?? false,
        'risk_score' : result['risk_score'] ?? 0,
        'verdict'    : result['verdict']    ?? 'UNKNOWN',
        'ai_analysis': result['ai_analysis'] ?? null,
        'checked_at' : FieldValue.serverTimestamp(),
      });
    } else {
      await db.collection('scam_checks').add({
        'value'       : value,
        'type'        : result['type'],
        'huggingface' : result['huggingface'] ?? null,
        'is_scam'     : result['is_scam']     ?? false,
        'risk_score'  : result['risk_score']  ?? 0,
        'verdict'     : result['verdict']     ?? 'UNKNOWN',
        'ai_analysis' : result['ai_analysis'] ?? null,
        'checked_at'  : FieldValue.serverTimestamp(),
      });
    }

  } catch(e) {
    log("Database save error: $e");
  }
}