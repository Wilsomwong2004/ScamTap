import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_dashboard_page.dart';
import 'manage_users_page.dart';
import 'manage_reports_page.dart';
import 'settings_page.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final TextEditingController titleController = TextEditingController();

  final TextEditingController messageController = TextEditingController();

  Future<void> sendNotification() async {
    if (titleController.text.isEmpty || messageController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));

      return;
    }

    await FirebaseFirestore.instance.collection('notifications').add({
      'title': titleController.text.trim(),

      'message': messageController.text.trim(),

      'targetUser': 'all',

      'createdAt': Timestamp.now(),

      'isRead': false,
    });

    titleController.clear();
    messageController.clear();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Notification Sent")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7F1),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F7F1),
        elevation: 0,

        title: const Text(
          "Notifications",

          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),

        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),

        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(25),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),

              child: Column(
                children: [
                  TextField(
                    controller: titleController,

                    decoration: InputDecoration(
                      hintText: "Notification Title",

                      filled: true,

                      fillColor: const Color(0xFFF3F7F1),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),

                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: messageController,

                    maxLines: 5,

                    decoration: InputDecoration(
                      hintText: "Notification Message",

                      filled: true,

                      fillColor: const Color(0xFFF3F7F1),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),

                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
                    width: double.infinity,
                    height: 55,

                    child: ElevatedButton(
                      onPressed: sendNotification,

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),

                      child: const Text(
                        "Send Notification",

                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Align(
              alignment: Alignment.centerLeft,

              child: Text(
                "Recent Notifications",

                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 15),

            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('notifications')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),

              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                var notifications = snapshot.data!.docs;

                return ListView.builder(
                  shrinkWrap: true,

                  physics: const NeverScrollableScrollPhysics(),

                  itemCount: notifications.length,

                  itemBuilder: (context, index) {
                    var data = notifications[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 15),

                      padding: const EdgeInsets.all(18),

                      decoration: BoxDecoration(
                        color: Colors.white,

                        borderRadius: BorderRadius.circular(20),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                          ),
                        ],
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            data['title'] ?? "",

                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(data['message'] ?? ""),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),

      bottomNavigationBar: adminNavbar(context),
    );
  }
}

Widget adminNavbar(BuildContext context) {
  return Container(
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
