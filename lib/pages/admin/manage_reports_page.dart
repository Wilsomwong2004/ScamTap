import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_dashboard_page.dart';
import 'manage_users_page.dart';
import 'settings_page.dart';

class ManageReportsPage extends StatelessWidget {
  const ManageReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7F1),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F7F1),
        elevation: 0,

        title: const Text(
          "Manage Reports",

          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),

        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('scam_reports')
            .snapshots(),

        builder: (context, snapshot) {
          // LOADING
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // NO DATA
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No Reports Found"));
          }

          var reports = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),

            itemCount: reports.length,

            itemBuilder: (context, index) {
              var report = reports[index];

              Map<String, dynamic> data = report.data() as Map<String, dynamic>;

              String scamType = data['scamType'] ?? "Unknown";

              String description =
                  data['reportDescription'] ?? "No description";

              String status = data['reportStatus'] ?? "Pending";

              int riskLevel = 0;

              // FIX RISK LEVEL
              if (data['riskLevel'] != null) {
                if (data['riskLevel'] is int) {
                  riskLevel = data['riskLevel'];
                } else if (data['riskLevel'] is String) {
                  riskLevel = int.tryParse(data['riskLevel']) ?? 0;
                }
              }

              // STATUS COLOR
              Color statusColor = Colors.orange;

              if (status == "Approved") {
                statusColor = Colors.green;
              } else if (status == "Rejected") {
                statusColor = Colors.red;
              }

              // ICON
              IconData iconData = Icons.warning;

              if (scamType.toLowerCase().contains("sms")) {
                iconData = Icons.sms;
              } else if (scamType.toLowerCase().contains("link")) {
                iconData = Icons.link;
              } else if (scamType.toLowerCase().contains("call")) {
                iconData = Icons.call;
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 20),

                padding: const EdgeInsets.all(22),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(28),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 12,
                    ),
                  ],
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    // TOP ROW
                    Row(
                      children: [
                        // ICON
                        Container(
                          padding: const EdgeInsets.all(16),

                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.15),

                            shape: BoxShape.circle,
                          ),

                          child: Icon(iconData, color: statusColor, size: 28),
                        ),

                        const SizedBox(width: 16),

                        // TITLE
                        Expanded(
                          child: Text(
                            scamType,

                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        // STATUS
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 10,
                          ),

                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.15),

                            borderRadius: BorderRadius.circular(20),
                          ),

                          child: Text(
                            status,

                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 22),

                    // DESCRIPTION
                    Text(
                      description,

                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 15,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 18),

                    // RISK LEVEL
                    Text(
                      "Risk Level: $riskLevel",

                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 25),

                    // BUTTONS
                    Row(
                      children: [
                        // APPROVE
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              // UPDATE REPORT STATUS
                              await FirebaseFirestore.instance
                                  .collection('scam_reports')
                                  .doc(report.id)
                                  .update({'reportStatus': 'Approved'});

                              // CREATE NOTIFICATION
                              await FirebaseFirestore.instance
                                  .collection('notifications')
                                  .add({
                                    'title': 'Report Approved',

                                    'message':
                                        'Your scam report has been approved by admin.',

                                    'targetUser': data['reportBy'] ?? '',

                                    'createdAt': DateTime.now(),

                                    'isRead': false,
                                  });

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Report Approved"),
                                ),
                              );
                            },

                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,

                              padding: const EdgeInsets.symmetric(vertical: 14),

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),

                            child: const Text(
                              "Approve",

                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        // REJECT
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              // UPDATE REPORT STATUS
                              await FirebaseFirestore.instance
                                  .collection('scam_reports')
                                  .doc(report.id)
                                  .update({'reportStatus': 'Rejected'});

                              // CREATE NOTIFICATION
                              await FirebaseFirestore.instance
                                  .collection('notifications')
                                  .add({
                                    'title': 'Report Rejected',

                                    'message':
                                        'Your scam report has been rejected by admin.',

                                    'targetUser': data['reportBy'] ?? '',

                                    'createdAt': DateTime.now(),

                                    'isRead': false,
                                  });

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Report Rejected"),
                                ),
                              );
                            },

                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,

                              padding: const EdgeInsets.symmetric(vertical: 14),

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),

                            child: const Text(
                              "Reject",

                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),

      // ADMIN NAVBAR
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),

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
            navButton(
              context,
              Icons.dashboard,
              "Dashboard",
              const AdminDashboardPage(),
              false,
            ),

            navButton(
              context,
              Icons.people,
              "Users",
              const ManageUsersPage(),
              false,
            ),

            navButton(
              context,
              Icons.report,
              "Reports",
              const ManageReportsPage(),
              true,
            ),

            navButton(
              context,
              Icons.settings,
              "Settings",
              const SettingsPage(),
              false,
            ),
          ],
        ),
      ),
    );
  }
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

      margin: const EdgeInsets.symmetric(vertical: 6),

      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),

      decoration: BoxDecoration(
        color: isSelected ? Colors.green : Colors.transparent,

        borderRadius: BorderRadius.circular(30),
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,

        children: [
          Icon(icon, size: 20, color: isSelected ? Colors.white : Colors.grey),

          const SizedBox(height: 4),

          Text(
            label,

            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,

              color: isSelected ? Colors.white : Colors.grey,
            ),
          ),
        ],
      ),
    ),
  );
}
