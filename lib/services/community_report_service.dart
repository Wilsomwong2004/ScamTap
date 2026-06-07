import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/community_report_model.dart';

class CommunityReportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get approved reports from scam_reports collection
  Stream<List<CommunityReport>> getApprovedReports() {
    return _firestore
        .collection('scam_reports')
        .where('reportStatus', isEqualTo: 'Approved')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            return CommunityReport(
              id: doc.id,
              value: data['reportedNumber'] ?? data['reportedLink'] ?? data['reportDescription'] ?? '',
              type: _getType(data['scamType'] ?? ''),
              reportType: 'scam',
              description: data['reportDescription'] ?? '',
              reportCount: 1,
              reportedAt: (data['reportDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
              reportedBy: data['reportBy'] ?? 'Anonymous',
              status: data['reportStatus'] ?? 'Pending',
            );
          }).toList();
        });
  }

  // Get reports by type
  Stream<List<CommunityReport>> getReportsByType(String type) {
    return _firestore
        .collection('scam_reports')
        .where('reportStatus', isEqualTo: 'Approved')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .where((doc) => _getType(doc.data()['scamType'] ?? '') == type)
              .map((doc) {
                final data = doc.data();
                return CommunityReport(
                  id: doc.id,
                  value: data['reportedNumber'] ?? data['reportedLink'] ?? data['reportDescription'] ?? '',
                  type: _getType(data['scamType'] ?? ''),
                  reportType: 'scam',
                  description: data['reportDescription'] ?? '',
                  reportCount: 1,
                  reportedAt: (data['reportDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
                  reportedBy: data['reportBy'] ?? 'Anonymous',
                  status: data['reportStatus'] ?? 'Pending',
                );
              }).toList();
        });
  }

  // Get all reports (for community page)
  Stream<List<CommunityReport>> getAllReports() {
    return _firestore
        .collection('scam_reports')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            return CommunityReport(
              id: doc.id,
              value: data['reportedNumber'] ?? data['reportedLink'] ?? data['reportDescription'] ?? '',
              type: _getType(data['scamType'] ?? ''),
              reportType: 'scam',
              description: data['reportDescription'] ?? '',
              reportCount: 1,
              reportedAt: (data['reportDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
              reportedBy: data['reportBy'] ?? 'Anonymous',
              status: data['reportStatus'] ?? 'Pending',
            );
          }).toList();
        });
  }

  // Get pending reports
  Stream<List<CommunityReport>> getPendingReports() {
    return _firestore
        .collection('scam_reports')
        .where('reportStatus', isEqualTo: 'Pending')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            return CommunityReport(
              id: doc.id,
              value: data['reportedNumber'] ?? data['reportedLink'] ?? data['reportDescription'] ?? '',
              type: _getType(data['scamType'] ?? ''),
              reportType: 'scam',
              description: data['reportDescription'] ?? '',
              reportCount: 1,
              reportedAt: (data['reportDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
              reportedBy: data['reportBy'] ?? 'Anonymous',
              status: data['reportStatus'] ?? 'Pending',
            );
          }).toList();
        });
  }

  String _getType(String scamType) {
    final lower = scamType.toLowerCase();
    if (lower.contains('call') || lower.contains('phone')) return 'phone';
    if (lower.contains('link')) return 'link';
    return 'message';
  }

  // Submit a new report to scam_reports
  Future<bool> submitReport({
    required String value,
    required String type,
    required String reportType,
    required String description,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      await _firestore.collection('scam_reports').add({
        'reportBy': user.displayName ?? user.email ?? 'Anonymous',
        'reportDate': FieldValue.serverTimestamp(),
        'reportDescription': description,
        'reportStatus': 'Pending',
        'reportedNumber': type == 'phone' ? value : '',
        'reportedLink': type == 'link' ? value : '',
        'riskLevel': 5,
        'scamType': type == 'phone' ? 'Phone Call' : type == 'link' ? 'Malicious Link' : 'Scam Message',
      });
      return true;
    } catch (e) {
      print('Submit report error: $e');
      return false;
    }
  }

  // Get total count
  Future<int> getTotalReportCount() async {
    final snapshot = await _firestore.collection('scam_reports').get();
    return snapshot.docs.length;
  }

  // Get approved count
  Future<int> getApprovedReportCount() async {
    final snapshot = await _firestore
        .collection('scam_reports')
        .where('reportStatus', isEqualTo: 'Approved')
        .get();
    return snapshot.docs.length;
  }

  // Get pending count
  Future<int> getPendingReportCount() async {
    final snapshot = await _firestore
        .collection('scam_reports')
        .where('reportStatus', isEqualTo: 'Pending')
        .get();
    return snapshot.docs.length;
  }
}