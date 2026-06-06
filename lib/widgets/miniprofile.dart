import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../pages/free_users/login_page.dart';

class Miniprofile extends StatefulWidget {
  const Miniprofile({super.key});

  @override
  State<Miniprofile> createState() => _MiniprofileState();
}

class _MiniprofileState extends State<Miniprofile> {
  String username = "";
  String email = "";
  String uid = "";
  String userRole = "";

  @override
  void initState() {
    super.initState();
    loadUserData();
    syncEmailWithFirestore();
  }

  Future<void> syncEmailWithFirestore() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    await user.reload();

    final refreshedUser = FirebaseAuth.instance.currentUser;

    if (refreshedUser == null) return;

    final uid = refreshedUser.uid;

    if (refreshedUser.email != null) {
      await FirebaseFirestore.instance.collection('usersData').doc(uid).update({
        'Email': refreshedUser.email,
      });

      setState(() {
        email = refreshedUser.email!;
      });
    }
  }

  Future<void> loadUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) return;

    final doc = await FirebaseFirestore.instance
        .collection("usersData")
        .doc(uid)
        .get();

    setState(() {
      this.uid = uid;
      username = doc.data()?["Username"] ?? "User";
      email = doc.data()?["Email"] ?? "";

      String role = (doc.data()?["Role"] ?? "free user")
          .toString()
          .toLowerCase();

      if (role == "premium user") {
        userRole = "Premium User";
      } else {
        userRole = "Free User";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7F1),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F7F1),
        elevation: 0,

        title: const Text(
          "Settings",

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

              child: const Icon(Icons.person, size: 60, color: Colors.white),
            ),

            const SizedBox(height: 18),

            Text(
              username,

              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 5),

            Text(
              "ScamTap $userRole",
              style: const TextStyle(color: Colors.grey, fontSize: 15),
            ),
            Text(
              email,
              style: const TextStyle(color: Colors.grey, fontSize: 15),
            ),

            const SizedBox(height: 35),

            // CARDS
            buildCard(
              context,
              Icons.person_outline,
              "Manage Profile",
              "Update user account information",
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
              Icons.lock_outline,
              "Privacy",
              "Terms and conditions",
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
              text: username,
            );

            TextEditingController emailController = TextEditingController(
              text: email,
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
                            Icons.person,
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
                          readOnly: false,

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
                      onPressed: () async {
                        String newEmail = emailController.text.trim();

                        final user = FirebaseAuth.instance.currentUser!;

                        await FirebaseFirestore.instance
                            .collection('usersData')
                            .doc(uid)
                            .update({
                              'Username': usernameController.text.trim(),
                            });

                        if (newEmail != user.email) {
                          await user.verifyBeforeUpdateEmail(newEmail);
                        }

                        setState(() {
                          username = usernameController.text.trim();
                        });
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
                      onPressed: () async {
                        String newPassword = passwordController.text.trim();

                        String confirmPassword = confirmController.text.trim();

                        if (newPassword.isEmpty || confirmPassword.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please fill all fields"),
                            ),
                          );
                          return;
                        }

                        if (newPassword != confirmPassword) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Passwords do not match"),
                            ),
                          );
                          return;
                        }

                        try {
                          await FirebaseAuth.instance.currentUser!
                              .updatePassword(newPassword);

                          await FirebaseFirestore.instance
                              .collection("usersData")
                              .doc(uid)
                              .update({"Password": newPassword});

                          Navigator.pop(context);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Password Updated Successfully"),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text("Error: $e")));
                        }
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
          } else if (title == "Privacy") {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Privacy & Terms"),
                  content: const SingleChildScrollView(
                    child: Text(
                      "ScamTap collects account information and usage data "
                      "to improve scam detection services. User information "
                      "is stored securely and is not shared with third parties.",
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Close"),
                    ),
                  ],
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
