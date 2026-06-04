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
    // print('Firestore Data: $map');

    return SearchRecordModel(
      type      : map['type']      ?? 'unknown',
      value     : map['value']     ?? '',
      riskScore : (map['riskScore'] as num?)?.toInt() ?? 0,
      riskLevel : map['riskLevel'] ?? 'UNKNOWN',
      timestamp : (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      detail    : Map<String, dynamic>.from(map['detail'] ?? {}),
      rawData   : Map<String, dynamic>.from(map),
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