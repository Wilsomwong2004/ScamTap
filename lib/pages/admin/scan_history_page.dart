import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_dashboard_page.dart';
import 'manage_users_page.dart';
import 'manage_reports_page.dart';
import 'notifications_page.dart';
import 'settings_page.dart';

class ScanHistoryPage extends StatelessWidget {
  const ScanHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F1),

      appBar: AppBar(
        title: const Text(
          "Scan History",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),

        backgroundColor: const Color(0xFFF5F7F1),
        elevation: 0,
        centerTitle: true,
      ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('scam_checks')
            .orderBy('checked_at', descending: true)
            .snapshots(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No Scan History"));
          }

          var docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
            itemCount: docs.length,

            itemBuilder: (context, index) {
              var data = docs[index];

              String type = "";

              if (data.data().toString().contains('type')) {
                type = data['type'] ?? "Unknown";
              }

              String value = "";

              if (data.data().toString().contains('value')) {
                value = data['value'];
              }
              String verdict = "Unknown";

              if (data.data().toString().contains('verdict')) {
                verdict = data['verdict'] ?? "Unknown";
              }

              int riskScore = 0;

              if (data.data().toString().contains('ai_analysis')) {
                riskScore = data['ai_analysis']['risk_score'] ?? 0;
              }

              Color riskColor = Colors.green;

              if (riskScore >= 7) {
                riskColor = Colors.red;
              } else if (riskScore >= 4) {
                riskColor = Colors.orange;
              }

              IconData typeIcon = Icons.security;

              if (type == "phone") {
                typeIcon = Icons.phone;
              } else if (type == "link") {
                typeIcon = Icons.link;
              } else if (type == "message") {
                typeIcon = Icons.message;
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 18),
                padding: const EdgeInsets.all(18),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                    ),
                  ],
                ),

                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),

                      decoration: BoxDecoration(
                        color: riskColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(18),
                      ),

                      child: Icon(typeIcon, color: riskColor, size: 28),
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            value,

                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            "Type: ${type.toUpperCase()}",
                            style: TextStyle(color: Colors.grey.shade700),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            "Verdict: $verdict",
                            style: TextStyle(
                              color: riskColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),

                      decoration: BoxDecoration(
                        color: riskColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: Text(
                        "Risk $riskScore",

                        style: TextStyle(
                          color: riskColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),

      bottomNavigationBar: adminNavbar(context),
    );
  }
}

Widget adminNavbar(BuildContext context) {
  return Container(
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
        // DASHBOARD
        navButton(
          context,
          Icons.dashboard,
          "Dashboard",
          const AdminDashboardPage(),
          false,
        ),

        // USERS
        navButton(
          context,
          Icons.people,
          "Users",
          const ManageUsersPage(),
          false,
        ),

        // REPORTS
        navButton(
          context,
          Icons.report,
          "Reports",
          const ManageReportsPage(),
          false,
        ),

        // NOTIFICATIONS
        navButton(
          context,
          Icons.notifications,
          "Alerts",
          const NotificationsPage(),
          false,
        ),

        // SETTINGS
        navButton(
          context,
          Icons.settings,
          "Settings",
          const SettingsPage(),
          false,
        ),
      ],
    ),
  );
}

Widget navButton(
  BuildContext context,
  IconData icon,
  String label,
  Widget page,
  bool isSelected,
) {
  return GestureDetector(
    onTap: () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => page),
      );
    },

    child: AnimatedContainer(
      duration: const Duration(milliseconds: 250),

      margin: const EdgeInsets.symmetric(vertical: 10),

      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),

      decoration: BoxDecoration(
        color: isSelected ? Colors.green : Colors.transparent,

        borderRadius: BorderRadius.circular(30),
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,

        children: [
          Icon(icon, size: 24, color: isSelected ? Colors.white : Colors.grey),

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
