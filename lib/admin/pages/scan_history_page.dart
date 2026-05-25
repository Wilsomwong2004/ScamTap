import 'package:flutter/material.dart';

class ScanHistoryPage extends StatelessWidget {
  const ScanHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan History"),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),

        children: [

          historyCard(
            "Fake bank SMS detected",
            "High Risk",
            Colors.red,
          ),

          historyCard(
            "Unknown number detected",
            "Medium Risk",
            Colors.orange,
          ),

          historyCard(
            "Safe message",
            "Low Risk",
            Colors.green,
          ),
        ],
      ),
    );
  }

  Widget historyCard(
    String text,
    String risk,
    Color color,
  ) {

    return Card(
      margin: const EdgeInsets.only(bottom: 15),

      child: ListTile(
        title: Text(text),

        subtitle: Text(risk),

        trailing: Icon(
          Icons.warning,
          color: color,
        ),
      ),
    );
  }
}