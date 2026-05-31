import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
            padding: const EdgeInsets.all(20),
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
                        horizontal: 12,
                        vertical: 8,
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
    );
  }
}
