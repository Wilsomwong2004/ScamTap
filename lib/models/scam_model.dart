import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

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

  Map<String, dynamic> result = {};

  if (_isPhoneNumber(value)) {
    result['type'] = 'phone';

    try {
      final numverifyUrl = Uri.parse(
        "http://apilayer.net/api/validate?access_key=$numverifyAPI&number=$value"
      );
      final numverifyResponse = await http.get(numverifyUrl);

      if (numverifyResponse.statusCode == 200) {
        result['numverify'] = jsonDecode(numverifyResponse.body);
        log("Numverify: ${result['numverify']}");
      }
    } catch (e) {
      log("Numverify error: $e");
    }

    try {
      final penipuUrl = Uri.parse(
        "https://penipu.my/api/v1/phone?q=$value"
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
        print("PenipuMY error: ${penipuResponse.statusCode}");
      }
    } catch (e) {
      log("PenipuMY exception: $e");
    }
  } else if (_isLink(value)) {
    result['type'] = 'link';
    log('link');

  } else {
    result['type'] = 'message';
    log('message');
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