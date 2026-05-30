import 'package:flutter/material.dart';

class ManageReportsPage extends StatelessWidget {
  const ManageReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7F1),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        title: const Text(
          "Manage Scam Reports",

          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),

        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // TITLE
            const Text(
              "Scam Reports Overview",

              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const Text(
              "Review and manage scam reports submitted by users.",

              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),

            const SizedBox(height: 30),

            // REPORTS
            reportCard(
              title: "SMS Phishing",
              description:
                  "Fake banking SMS asking users to click suspicious links.",

              status: "Pending",
              statusColor: Colors.orange,

              icon: Icons.sms,
            ),

            const SizedBox(height: 18),

            reportCard(
              title: "Fake Bank Link",
              description:
                  "Suspicious website pretending to be official bank portal.",

              status: "Approved",
              statusColor: Colors.green,

              icon: Icons.link,
            ),

            const SizedBox(height: 18),

            reportCard(
              title: "Suspicious Call",
              description:
                  "Unknown caller pretending to be government officer.",

              status: "Rejected",
              statusColor: Colors.red,

              icon: Icons.call,
            ),

            const SizedBox(height: 18),

            reportCard(
              title: "QR Code Scam",
              description:
                  "Users reported fake QR payment stickers in public areas.",

              status: "Pending",
              statusColor: Colors.orange,

              icon: Icons.qr_code,
            ),
          ],
        ),
      ),
    );
  }

  Widget reportCard({
    required String title,
    required String description,
    required String status,
    required Color statusColor,
    required IconData icon,
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
          // TOP ROW
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: statusColor.withOpacity(0.15),

                child: Icon(icon, color: statusColor),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Text(
                  title,

                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 7,
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

          const SizedBox(height: 18),

          // DESCRIPTION
          Text(
            description,

            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 20),

          // BUTTONS
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),

                  child: const Text(
                    "Approve",

                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: ElevatedButton(
                  onPressed: () {},

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),

                  child: const Text(
                    "Reject",

                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
