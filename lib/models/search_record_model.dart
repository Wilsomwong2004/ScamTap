import 'package:cloud_firestore/cloud_firestore.dart';

class SearchRecordModel {
  final String type;
  final String value;
  final int riskScore;
  final String riskLevel;
  final DateTime timestamp;
  final Map<String, dynamic> detail;
  final Map<String, dynamic>? rawData;

  SearchRecordModel({
    required this.type,
    required this.value,
    required this.riskScore,
    required this.riskLevel,
    required this.timestamp,
    required this.detail,
    this.rawData,
  });

  factory SearchRecordModel.fromMap(Map<String, dynamic> map) {
    return SearchRecordModel(
      type: map['type'],
      value: map['value'],
      riskScore: map['riskScore'],
      riskLevel: map['riskLevel'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      detail: map['detail'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'value': value,
      'riskScore': riskScore,
      'riskLevel': riskLevel,
      'timestamp': Timestamp.fromDate(timestamp),
      'detail': detail,
    };
  }
}