class AdminStats {
  final int totalUsers;
  final int totalReports;
  final int totalScams;
  final int activeUsers;

  AdminStats({
    required this.totalUsers,
    required this.totalReports,
    required this.totalScams,
    required this.activeUsers,
  });

  Map<String, dynamic> toMap() {
    return {
      'totalUsers': totalUsers,
      'totalReports': totalReports,
      'totalScams': totalScams,
      'activeUsers': activeUsers,
    };
  }
}
