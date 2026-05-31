import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();

                  Navigator.pushAndRemoveUntil(
                    context,

                    MaterialPageRoute(builder: (context) => const LoginPage()),

                    (route) => false,
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
          // MANAGE PROFILE
          if (title == "Manage Profile") {
            TextEditingController usernameController = TextEditingController(
              text: "Admin",
            );

            TextEditingController emailController = TextEditingController(
              text: "admin@scamtap.com",
            );

            showDialog(
              context: context,

              builder: (context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),

                  title: const Text(
                    "Manage Profile",

                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.green.shade700,

                          child: const Icon(
                            Icons.admin_panel_settings,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),

                        const SizedBox(height: 25),

                        TextField(
                          controller: usernameController,

                          decoration: InputDecoration(
                            labelText: "Username",

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        TextField(
                          controller: emailController,

                          decoration: InputDecoration(
                            labelText: "Email",

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },

                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),

                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Profile Updated Successfully"),
                          ),
                        );
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),

                      child: const Text(
                        "Save",

                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                );
              },
            );
          }
          // SECURITY SETTINGS
          else if (title == "Security Settings") {
            TextEditingController passwordController = TextEditingController();

            TextEditingController confirmController = TextEditingController();

            showDialog(
              context: context,

              builder: (context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),

                  title: const Text(
                    "Security Settings",

                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        TextField(
                          controller: passwordController,
                          obscureText: true,

                          decoration: InputDecoration(
                            labelText: "New Password",

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        TextField(
                          controller: confirmController,
                          obscureText: true,

                          decoration: InputDecoration(
                            labelText: "Confirm Password",

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },

                      child: const Text("Cancel"),
                    ),

                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Password Updated Successfully"),
                          ),
                        );
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),

                      child: const Text(
                        "Save",

                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                );
              },
            );
          }
          // NOTIFICATION SETTINGS
          else if (title == "Notification Settings") {
            showDialog(
              context: context,

              builder: (context) {
                bool scamAlert = true;
                bool emailAlert = true;
                bool pushAlert = false;

                return StatefulBuilder(
                  builder: (context, setState) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),

                      title: const Text(
                        "Notification Settings",

                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),

                      content: Column(
                        mainAxisSize: MainAxisSize.min,

                        children: [
                          SwitchListTile(
                            value: scamAlert,

                            onChanged: (value) {
                              setState(() {
                                scamAlert = value;
                              });
                            },

                            title: const Text("Scam Alerts"),
                          ),

                          SwitchListTile(
                            value: emailAlert,

                            onChanged: (value) {
                              setState(() {
                                emailAlert = value;
                              });
                            },

                            title: const Text("Email Notifications"),
                          ),

                          SwitchListTile(
                            value: pushAlert,

                            onChanged: (value) {
                              setState(() {
                                pushAlert = value;
                              });
                            },

                            title: const Text("Push Notifications"),
                          ),
                        ],
                      ),

                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Notification Settings Saved"),
                              ),
                            );
                          },

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),

                          child: const Text(
                            "Save",

                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            );
          }
          // ABOUT SYSTEM
          else {
            showDialog(
              context: context,

              builder: (context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),

                  title: const Text(
                    "About ScamTap",

                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  content: const Column(
                    mainAxisSize: MainAxisSize.min,

                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text("Version: 1.0.0"),

                      SizedBox(height: 10),

                      Text("Developer: ScamTap Team"),

                      SizedBox(height: 10),

                      Text(
                        "ScamTap helps users detect scam phone numbers, suspicious links and dangerous messages using AI-powered scam analysis.",
                      ),
                    ],
                  ),

                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),

                      child: const Text(
                        "OK",

                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                );
              },
            );
          }
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
