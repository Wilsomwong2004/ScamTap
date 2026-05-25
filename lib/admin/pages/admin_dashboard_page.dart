import 'package:flutter/material.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7F1),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        title: const Text(
          "Admin Dashboard",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),

        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              "Welcome Admin!",

              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const Text(
              "Monitor ScamTap system activities",

              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),

            const SizedBox(height: 30),

            Row(
              children: [
                Expanded(
                  child: dashboardCard(
                    title: "Total Users",
                    value: "120",
                    icon: Icons.people,
                    color: Colors.blue,
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: dashboardCard(
                    title: "Reports",
                    value: "45",
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
                    value: "10",
                    icon: Icons.warning,
                    color: Colors.orange,
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: dashboardCard(
                    title: "Notifications",
                    value: "23",
                    icon: Icons.notifications,
                    color: Colors.green,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 35),

            const Text(
              "Quick Actions",

              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            actionButton(
              icon: Icons.manage_accounts,
              title: "Manage Users",
              color: Colors.blue,
            ),

            const SizedBox(height: 15),

            actionButton(
              icon: Icons.report_gmailerrorred,
              title: "Manage Scam Reports",
              color: Colors.red,
            ),

            const SizedBox(height: 15),

            actionButton(
              icon: Icons.notifications_active,
              title: "Send Notifications",
              color: Colors.green,
            ),

            const SizedBox(height: 15),

            actionButton(
              icon: Icons.history,
              title: "View Scan History",
              color: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

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

        borderRadius: BorderRadius.circular(20),

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
            backgroundColor: color.withOpacity(0.15),

            child: Icon(icon, color: color),
          ),

          const SizedBox(height: 18),

          Text(
            value,

            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 5),

          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        ],
      ),
    );
  }

  Widget actionButton({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

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
            backgroundColor: color.withOpacity(0.15),

            child: Icon(icon, color: color),
          ),

          const SizedBox(width: 18),

          Expanded(
            child: Text(
              title,

              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),

          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 18,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}
