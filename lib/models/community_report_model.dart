import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityReport {
  final String id;
  final String value;
  final String type;
  final String reportType;
  final String description;
  final int reportCount;
  final DateTime reportedAt;
  final String reportedBy;
  final String status;

  CommunityReport({
    required this.id,
    required this.value,
    required this.type,
    required this.reportType,
    required this.description,
    required this.reportCount,
    required this.reportedAt,
    required this.reportedBy,
    required this.status,
  });

  factory CommunityReport.fromMap(Map<String, dynamic> map, String id) {
    return CommunityReport(
      id: id,
      value: map['value'] ?? '',
      type: map['type'] ?? 'unknown',
      reportType: map['reportType'] ?? 'scam',
      description: map['description'] ?? '',
      reportCount: map['reportCount'] ?? 1,
      reportedAt: (map['reportedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      reportedBy: map['reportedBy'] ?? 'Anonymous',
      status: map['status'] ?? 'Pending',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'value': value,
      'type': type,
      'reportType': reportType,
      'description': description,
      'reportCount': reportCount,
      'reportedAt': Timestamp.fromDate(reportedAt),
      'reportedBy': reportedBy,
      'status': status,
    };
  }
}