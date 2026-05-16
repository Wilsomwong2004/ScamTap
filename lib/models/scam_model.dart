import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  Map<String, dynamic> result = {};

  if (_isPhoneNumber(value)) {
    final formattedPhone = _formatPhoneNumber(value);

    result['type'] = 'phone';

    try {
      final numverifyUrl = Uri.parse(
        "https://apilayer.net/api/validate?access_key=$numverifyAPI&number=$formattedPhone"
      );
      final numverifyResponse = await http.get(numverifyUrl);

      if (numverifyResponse.statusCode == 200) {
        result['numverify'] = jsonDecode(numverifyResponse.body);
        print("Numverify: ${result['numverify']}");
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
      } else {
        log("PenipuMY error: ${penipuResponse.statusCode}");
      }
    } catch (e) {
      log("PenipuMY exception: $e");
    }
  } else if (_isLink(value)) {
    result['type'] = 'link';
    log('link');

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
      }

      final submitData = jsonDecode(virustotalUrlResponse.body);
      final analysisId = submitData['data']['id'];
      log("VirusTotal Analysis ID: $analysisId");

      if (virustotalUrlResponse.statusCode == 200) {
        result['numverify'] = jsonDecode(virustotalUrlResponse.body);
        print("Virustotal: ${result['virustotal']}");
      }

      await Future.delayed(Duration(seconds: 3));

      final reportResponse = await http.get(
      Uri.parse("https://www.virustotal.com/api/v3/analyses/$analysisId"),
      headers: {"x-apikey": virustotalAPI},
    );

    if (reportResponse.statusCode == 200) {
      final reportData  = jsonDecode(reportResponse.body);
      final stats       = reportData['data']['attributes']['stats'];

      result['virustotal']          = stats;
      result['virustotal_flagged']  = (stats['malicious'] ?? 0) > 0;

      log("VirusTotal stats: $stats");
    }

    } catch (e) {
      log("VirusTotal exception: $e");
    }

  } else {
    result['type'] = 'message';
    
    final List<String> scamKeywords = [
      'you won', 'you have won', 'congratulations',
      'click here', 'claim now', 'claim your',
      'free gift', 'free prize', 'limited time',
      'urgent', 'act now', 'immediately',
      'verify your account', 'your account has been',
      'bank account', 'credit card', 'transfer',
      'rm ', 'rm500', 'rm1000',
      'whatsapp', 'telegram',
      'lucky draw', 'selected winner',
      'otp', 'pin number', 'password',
    ];


  }

  await _scamAnalysis(value, result);

  await _saveToFirebase(value, result);

  return result;
  
}

Future<void> _scamAnalysis(String value, Map<String, dynamic> result) async {
  
}

Future<void> _saveToFirebase(String value, Map<String, dynamic> result) async {
  try {
    final db = FirebaseFirestore.instance;

    if(_isPhoneNumber(value)) {
      await db.collection('scam_checks').add({
        'value'      : value,
        'type'       : result['type'],
        'numverify'  : result['numverify']  ?? null,
        'penipumy'   : result['penipumy']   ?? null,
        'is_scam'    : result['penipumy']?['is_scam'] ?? false,
        'checked_at' : FieldValue.serverTimestamp(),
      });
    } else if(_isLink(value)) {
      await db.collection('scam_checks').add({
        'value'      : value,
        'type'       : result['type'],
        'numverify'  : result['numverify']  ?? null,
        'penipumy'   : result['penipumy']   ?? null,
        'is_scam'    : result['penipumy']?['is_scam'] ?? false,
        'checked_at' : FieldValue.serverTimestamp(),
      });
    } else {
      
    }

  } catch(e) {
    log("Database save error: $e");
  }
}