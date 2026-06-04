import 'package:ScamTap/models/search_record_model.dart';

class AnalyticsService {
  /// Get number of days from period string
  int getPeriodDays(String period) {
    switch (period) {
      case '7 days':
        return 7;
      case '30 days':
        return 30;
      case '90 days':
        return 90;
      case '1 year':
        return 365;
      default:
        return 30;
    }
  }

  /// Calculate comprehensive statistics from search records
  Map<String, dynamic> calculateStats(
    List<SearchRecordModel> records,
    String period,
  ) {
    final daysBack = getPeriodDays(period);
    final cutoff = DateTime.now().subtract(Duration(days: daysBack));
    final filtered =
        records.where((r) => r.timestamp.isAfter(cutoff)).toList();

    final totalScans = filtered.length;
    
    final totalScams = filtered.where((r) {
      final detail = r.detail;
      return detail['is_scam'] == true || detail['verdict'] == 'SCAM';
    }).length;

    final totalSafe = totalScans - totalScams;

    final phoneScams = filtered
        .where((r) => r.type == 'phone' && (r.detail['is_scam'] == true))
        .length;

    final linkScams = filtered
        .where((r) => r.type == 'link' && (r.detail['is_scam'] == true))
        .length;

    final msgScams = filtered
        .where((r) => r.type == 'message' && (r.detail['is_scam'] == true))
        .length;

    final dangerous =
        filtered.where((r) => r.riskLevel == 'Dangerous').length;

    final warning = filtered.where((r) => r.riskLevel == 'Warning').length;

    return {
      'totalScans': totalScans,
      'totalScams': totalScams,
      'totalSafe': totalSafe,
      'phoneScams': phoneScams,
      'linkScams': linkScams,
      'msgScams': msgScams,
      'dangerous': dangerous,
      'warning': warning,
      'scamPercentage': totalScans > 0
          ? ((totalScams / totalScans) * 100).toStringAsFixed(1)
          : '0',
    };
  }

  /// Get statistics by type
  Map<String, int> getStatsByType(List<SearchRecordModel> records) {
    return {
      'phone':
          records.where((r) => r.type == 'phone').length,
      'link': records.where((r) => r.type == 'link').length,
      'message': records.where((r) => r.type == 'message').length,
    };
  }

  /// Get statistics by risk level
  Map<String, int> getStatsByRiskLevel(List<SearchRecordModel> records) {
    return {
      'Dangerous': records.where((r) => r.riskLevel == 'Dangerous').length,
      'Warning': records.where((r) => r.riskLevel == 'Warning').length,
      'Safe': records.where((r) => r.riskLevel == 'Safe').length,
    };
  }

  /// Get high-risk numbers (for alerts)
  List<String> getHighRiskNumbers(List<SearchRecordModel> records) {
    return records
        .where((r) => r.riskLevel == 'Dangerous')
        .map((r) => r.value)
        .toList();
  }

  /// Calculate average risk score
  double getAverageRiskScore(List<SearchRecordModel> records) {
    if (records.isEmpty) return 0;
    
    final total =
        records.fold<int>(0, (sum, r) => sum + r.riskScore);
    
    return total / records.length;
  }

  /// Get top scam types
  Map<String, int> getTopScamTypes(List<SearchRecordModel> records) {
    final scams = records.where((r) => r.detail['is_scam'] == true).toList();
    
    final typeCount = <String, int>{};
    for (var record in scams) {
      final type = record.type;
      typeCount[type] = (typeCount[type] ?? 0) + 1;
    }
    
    return typeCount;
  }

  /// Build chart data for visualization
  List<Map<String, dynamic>> buildChartData(
    List<SearchRecordModel> records,
    String period,
  ) {
    final daysBack = getPeriodDays(period);
    final now = DateTime.now();

    final chartData = <Map<String, dynamic>>[];

    for (int i = daysBack; i > 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dayRecords = records.where((r) {
        final recordDate = DateTime(
          r.timestamp.year,
          r.timestamp.month,
          r.timestamp.day,
        );
        final checkDate = DateTime(date.year, date.month, date.day);
        return recordDate.isAtSameMomentAs(checkDate);
      }).toList();

      final scams = dayRecords
          .where((r) => r.detail['is_scam'] == true)
          .length;

      chartData.add({
        'date': '${date.month}/${date.day}',
        'scans': dayRecords.length,
        'scams': scams,
        'safe': dayRecords.length - scams,
      });
    }

    return chartData;
  }
}
