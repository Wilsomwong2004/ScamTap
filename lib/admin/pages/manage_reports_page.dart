import 'package:flutter/material.dart';

class ManageReportsPage extends StatelessWidget {
  const ManageReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Scam Reports"),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),

        children: [

          reportCard(
            "SMS Phishing",
            "Pending",
            Colors.orange,
          ),

          reportCard(
            "Fake Bank Link",
            "Approved",
            Colors.green,
          ),

          reportCard(
            "Suspicious Call",
            "Rejected",
            Colors.red,
          ),
        ],
      ),
    );
  }

  Widget reportCard(
    String title,
    String status,
    Color color,
  ) {

    return Card(
      margin: const EdgeInsets.only(bottom: 15),

      child: Padding(
        padding: const EdgeInsets.all(18),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Text(
              title,

              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),

              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),

              child: Text(
                status,

                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}