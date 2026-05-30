import 'package:flutter/material.dart';
import '../../pages/login_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7F1),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        title: const Text(
          "Admin Settings",

          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),

        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            const SizedBox(height: 20),

            // PROFILE
            CircleAvatar(
              radius: 55,
              backgroundColor: Colors.green.shade700,

              child: const Icon(
                Icons.admin_panel_settings,
                size: 60,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              "Admin",

              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 5),

            const Text(
              "System Administrator",

              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),

            const SizedBox(height: 35),

            // CARDS
            buildCard(
              context,
              Icons.person_outline,
              "Manage Profile",
              "Update admin account information",
            ),

            buildCard(
              context,
              Icons.security,
              "Security Settings",
              "Manage password and authentication",
            ),

            buildCard(
              context,
              Icons.notifications_none,
              "Notification Settings",
              "Control system notifications",
            ),

            buildCard(
              context,
              Icons.info_outline,
              "About System",
              "View application information",
            ),

            const SizedBox(height: 50),

            // SIGN OUT BUTTON
            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,

                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),

                child: const Text(
                  "Sign Out",

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
      ),
    );
  }

  Widget buildCard(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),

      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,

            builder: (context) {
              return AlertDialog(
                title: Text(title),

                content: Text("$title feature coming soon!"),

                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },

                    child: const Text("OK"),
                  ),
                ],
              );
            },
          );
        },

        child: Container(
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

          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.green.withOpacity(0.15),

                child: Icon(icon, color: Colors.green.shade700),
              ),

              const SizedBox(width: 15),

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

              const Icon(Icons.arrow_forward_ios_rounded, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
