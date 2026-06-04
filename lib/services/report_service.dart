import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReportService {
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

      await FirebaseFirestore.instance.collection('scam_reports').add({
        'reportBy'          : user?.displayName ?? user?.email ?? 'Anonymous',
        'reportDate'        : Timestamp.now(),
        'reportDescription' : reason,
        'reportStatus'      : 'Pending',
        'reportedLink'      : type == 'link'  ? value : '',
        'reportedNumber'    : type == 'phone' ? value : '',
        'riskLevel'         : riskScore.toInt(),
        'scamType'          : verdict == 'SCAM' ? 'Scam' : 'Safe',
      });

      return true;
    } catch (e) {
      print('Report submit error: $e');
      return false;
    }
  }
}