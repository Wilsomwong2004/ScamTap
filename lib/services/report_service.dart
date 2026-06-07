import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReportService {
  static String _resolveScamType(String type, Map<String, dynamic>? result, String verdict) {
    if (type == 'link') {
      final int malicious = result?['virustotal']?['malicious'] ?? 0;
      final int suspicious = result?['virustotal']?['suspicious'] ?? 0;

      if (malicious > 0) return 'Malware';
      if (suspicious > 0) return 'Phishing';
      return 'Suspicious Link';
    }

    if (type == 'phone') {
      final bool isFraud = result?['penipumy']?['fraud'] ?? false;
      final bool isSpam = result?['penipumy']?['spam'] ?? false;
      final int policeReports = result?['penipumy']?['police_report_count'] ?? 0;

      if (isFraud || policeReports > 0) return 'Phone Fraud';
      if (isSpam) return 'Spam Call';
      return 'Suspicious Number';
    }

    if (type == 'message') {
      final bool isSpam = result?['huggingface']?['is_spam'] ?? false;
      final double spamScore = (result?['huggingface']?['spam_score'] as num?)?.toDouble() ?? 0.0;

      if (isSpam && spamScore > 0.9) return 'Scam Message';
      if (isSpam) return 'Spam Message';
      return 'Suspicious Message';
    }

    return 'Unknown';
  }

  static Future<bool> submitReport({
    required String value,
    required Map<String, dynamic>? result,
    required double riskScore,
    required String verdict,
    required String reason,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final String type = result?['type'] ?? 'unknown';
      final String scamType = _resolveScamType(type, result, verdict);

      await FirebaseFirestore.instance.collection('scam_reports').add({
        'reportBy'          : user?.displayName ?? user?.email ?? 'Anonymous',
        'reportDate'        : Timestamp.now(),
        'reportDescription' : reason,
        'reportStatus'      : 'Pending',
        'reportedLink'      : type == 'link'  ? value : '',
        'reportedNumber'    : type == 'phone' ? value : '',
        'riskLevel'         : riskScore.toInt(),
        'scamType'          : scamType,
      });

      return true;
    } catch (e) {
      print('Report submit error: $e');
      return false;
    }
  }
}