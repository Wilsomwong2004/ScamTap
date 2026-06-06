import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/admin_service.dart';

import 'manage_users_page.dart';
import 'manage_reports_page.dart';
import 'notifications_page.dart';
import 'scan_history_page.dart';
import 'settings_page.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  int selectedIndex = 0;

  int totalUsers = 0;
  int totalReports = 0;
  int pendingReports = 0;
  int totalNotifications = 0;
  final _adminService = AdminService();

  @override
  void initState() {
    super.initState();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    final stats = await _adminService.getDashboardStats();

    final pendingSnapshot = await FirebaseFirestore.instance
        .collection('scam_reports')
        .where('reportStatus', isEqualTo: 'Pending')
        .get();

    final notificationSnapshot = await FirebaseFirestore.instance
        .collection('notifications')
        .get();

    setState(() {
      totalUsers = stats.totalUsers;
      totalReports = stats.totalReports;

      pendingReports = pendingSnapshot.docs.length;
      totalNotifications = notificationSnapshot.docs.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7F1),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F7F1),
        elevation: 0,

        title: const Text(
          "Admin Dashboard",

          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),

        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // WELCOME SECTION
            const Text(
              "System Overview",

              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const Text(
              "Monitor ScamTap system activities",

              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),

            const SizedBox(height: 5),

            const Text(
              "Last updated: Today",

              style: TextStyle(
                fontSize: 13,
                color: Colors.green,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 30),

            // DASHBOARD CARDS
            Row(
              children: [
                Expanded(
                  child: dashboardCard(
                    title: "Total Users",
                    value: "$totalUsers",
                    icon: Icons.people,
                    color: Colors.blue,
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: dashboardCard(
                    title: "Reports",
                    value: "$totalReports",
                    icon: Icons.report,
                    color: Colors.red,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            Row(
              children: [
                Expanded(
                  child: dashboardCard(
                    title: "Pending",
                    value: "$pendingReports",
                    icon: Icons.warning_amber_rounded,
                    color: Colors.orange,
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: dashboardCard(
                    title: "Notifications",
                    value: "$totalNotifications",
                    icon: Icons.notifications,
                    color: Colors.green,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 35),

            // QUICK ACTIONS
            const Text(
              "Quick Actions",

              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            actionButton(
              context: context,
              icon: Icons.manage_accounts,
              title: "Manage Users",
              subtitle: "View and manage user accounts",
              color: Colors.blue,
              page: const ManageUsersPage(),
            ),

            const SizedBox(height: 15),

            actionButton(
              context: context,
              icon: Icons.report_gmailerrorred,
              title: "Manage Scam Reports",
              subtitle: "Review scam reports submitted",
              color: Colors.red,
              page: const ManageReportsPage(),
            ),

            const SizedBox(height: 15),

            actionButton(
              context: context,
              icon: Icons.notifications_active,
              title: "Send Notifications",
              subtitle: "Broadcast announcements to users",
              color: Colors.green,
              page: const NotificationsPage(),
            ),

            const SizedBox(height: 15),

            actionButton(
              context: context,
              icon: Icons.history,
              title: "View Scan History",
              subtitle: "Check all scam detection records",
              color: Colors.orange,
              page: const ScanHistoryPage(),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),

      // ADMIN NAVBAR
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(40),

          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,

          children: [
            navItem(icon: Icons.dashboard, label: "Dashboard", index: 0),

            navItem(icon: Icons.people, label: "Users", index: 1),

            navItem(icon: Icons.report, label: "Reports", index: 2),

            navItem(icon: Icons.settings, label: "Settings", index: 3),
          ],
        ),
      ),
    );
  }

  // DASHBOARD CARD
  Widget dashboardCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(22),

        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: color.withOpacity(0.15),

            child: Icon(icon, color: color),
          ),

          const SizedBox(height: 18),

          Text(
            value,

            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 5),

          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        ],
      ),
    );
  }

  // ACTION BUTTON
  Widget actionButton({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required Widget page,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },

      child: Container(
        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(20),

          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),

        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: color.withOpacity(0.15),

              child: Icon(icon, color: color),
            ),

            const SizedBox(width: 18),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    title,

                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    subtitle,

                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  // NAVBAR ITEM
  Widget navItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });

        // NAVIGATION
        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ManageUsersPage()),
          );
        } else if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ManageReportsPage()),
          );
        } else if (index == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsPage()),
          );
        }
      },

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),

        margin: const EdgeInsets.symmetric(vertical: 10),

        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),

        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.transparent,

          borderRadius: BorderRadius.circular(30),
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected ? Colors.white : Colors.grey,
            ),

            const SizedBox(height: 4),

            Text(
              label,

              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,

                color: isSelected ? Colors.white : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
