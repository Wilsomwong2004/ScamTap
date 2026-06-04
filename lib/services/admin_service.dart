import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/admin_stats_model.dart';

class AdminService {
  final _firestore = FirebaseFirestore.instance;

  /// Get dashboard statistics
  Future<AdminStats> getDashboardStats() async {
    try {
      // Get total users
      final usersSnap = await _firestore.collection('usersData').get();
      final totalUsers = usersSnap.docs.length;

      // Get total reports/scam checks
      final reportsSnap = await _firestore.collection('scam_reports').get();
      final totalReports = reportsSnap.docs.length;

      // Count scams
      int totalScams = 0;

      for (var doc in reportsSnap.docs) {
        final data = doc.data();

        int riskLevel = 0;

        if (data['riskLevel'] != null) {
          riskLevel = int.tryParse(data['riskLevel'].toString()) ?? 0;
        }

        if (riskLevel >= 7) {
          totalScams++;
        }
      }

      // Count active users (users with recent activity)
      int activeUsers = 0;
      final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));

      for (var doc in usersSnap.docs) {
        final data = doc.data();
        final lastActive = data['lastActive'] as Timestamp?;

        if (lastActive != null && lastActive.toDate().isAfter(thirtyDaysAgo)) {
          activeUsers++;
        }
      }

      return AdminStats(
        totalUsers: totalUsers,
        totalReports: totalReports,
        totalScams: totalScams,
        activeUsers: activeUsers,
      );
    } catch (e) {
      print('Error getting dashboard stats: $e');
      return AdminStats(
        totalUsers: 0,
        totalReports: 0,
        totalScams: 0,
        activeUsers: 0,
      );
    }
  }

  /// Get all users
  Future<List<Map<String, dynamic>>> getUsers() async {
    try {
      final snapshot = await _firestore.collection('usersData').get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error getting users: $e');
      return [];
    }
  }

  /// Get user by ID
  Future<Map<String, dynamic>?> getUserById(String uid) async {
    try {
      final snapshot = await _firestore.collection('usersData').doc(uid).get();
      return snapshot.data();
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  /// Get all reports
  Future<List<Map<String, dynamic>>> getReports() async {
    try {
      final snapshot = await _firestore.collection('scam_reports').get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error getting reports: $e');
      return [];
    }
  }

  /// Update user role
  Future<bool> updateUserRole(String uid, String role) async {
    try {
      await _firestore.collection('usersData').doc(uid).update({'Role': role});
      return true;
    } catch (e) {
      print('Error updating user role: $e');
      return false;
    }
  }

  /// Deactivate user
  Future<bool> deactivateUser(String uid) async {
    try {
      await _firestore.collection('usersData').doc(uid).update({
        'active': false,
      });
      return true;
    } catch (e) {
      print('Error deactivating user: $e');
      return false;
    }
  }

  /// Activate user
  Future<bool> activateUser(String uid) async {
    try {
      await _firestore.collection('usersData').doc(uid).update({
        'active': true,
      });
      return true;
    } catch (e) {
      print('Error activating user: $e');
      return false;
    }
  }

  /// Remove report
  Future<bool> removeReport(String reportId) async {
    try {
      await _firestore.collection('scam_reports').doc(reportId).delete();
      return true;
    } catch (e) {
      print('Error removing report: $e');
      return false;
    }
  }

  /// Stream of dashboard statistics (real-time)
  Stream<AdminStats> getDashboardStatsStream() {
    return Stream.periodic(
      const Duration(seconds: 30),
      (_) => getDashboardStats(),
    ).asyncExpand((future) => Stream.fromFuture(future));
  }

  /// Get system health status
  Future<Map<String, dynamic>> getSystemHealth() async {
    try {
      final stats = await getDashboardStats();

      return {
        'status': 'healthy',
        'totalUsers': stats.totalUsers,
        'totalReports': stats.totalReports,
        'totalScams': stats.totalScams,
        'scamPercentage': stats.totalReports > 0
            ? ((stats.totalScams / stats.totalReports) * 100).toStringAsFixed(2)
            : '0',
        'activeUsers': stats.activeUsers,
        'timestamp': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      return {'status': 'error', 'message': 'System health check failed: $e'};
    }
  }
}
