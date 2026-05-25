import 'package:flutter/material.dart';

class ManageUsersPage extends StatelessWidget {
  const ManageUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Users"),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),

        children: [

          userCard(
            "Wilsomwong",
            "Free User",
            Icons.person,
          ),

          userCard(
            "John Tan",
            "Premium User",
            Icons.workspace_premium,
          ),

          userCard(
            "Admin",
            "Administrator",
            Icons.admin_panel_settings,
          ),
        ],
      ),
    );
  }

  Widget userCard(
    String name,
    String role,
    IconData icon,
  ) {

    return Card(
      margin: const EdgeInsets.only(bottom: 15),

      child: ListTile(
        leading: Icon(icon),
        title: Text(name),
        subtitle: Text(role),

        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 18,
        ),
      ),
    );
  }
}