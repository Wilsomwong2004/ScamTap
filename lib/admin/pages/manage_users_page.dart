import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageUsersPage extends StatelessWidget {
  const ManageUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7F1),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        title: const Text(
          "Manage Users",

          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),

        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("usersData")
            .snapshots(),

        builder: (context, snapshot) {

          if (!snapshot.hasData) {

            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          var users = snapshot.data!.docs;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                // TITLE
                const Text(
                  "User Management",

                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  "Manage user accounts and permissions.",

                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 30),

                // FIREBASE USERS
                ...users.map((user) {

                  String username =
                      user["Username"] ?? "No Name";

                  String email =
                      user["Email"] ?? "No Email";

                  String role =
                      user["Role"] ?? "User";

                  Color roleColor =
                      role == "admin"
                          ? Colors.green
                          : Colors.blue;

                  IconData roleIcon =
                      role == "admin"
                          ? Icons.admin_panel_settings
                          : Icons.person;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 18),

                    child: userCard(
                      context: context,
                      name: username,
                      role: role,
                      email: email,
                      icon: roleIcon,
                      color: roleColor,
                    ),
                  );
                }).toList(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget userCard({
    required BuildContext context,
    required String name,
    required String role,
    required String email,
    required IconData icon,
    required Color color,
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
        children: [

          // TOP ROW
          Row(
            children: [

              CircleAvatar(
                radius: 26,
                backgroundColor: color.withOpacity(0.15),

                child: Icon(
                  icon,
                  color: color,
                ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    Text(
                      name,

                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      email,

                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 7,
                ),

                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),

                  borderRadius: BorderRadius.circular(20),
                ),

                child: Text(
                  role,

                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // BUTTONS
          Row(
            children: [

              Expanded(
                child: ElevatedButton(
                  onPressed: () {

                    showDialog(
                      context: context,

                      builder: (context) {

                        return AlertDialog(
                          title: const Text("User Details"),

                          content: Text(
                            "Username: $name\n\nEmail: $email\n\nRole: $role",
                          ),

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

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),

                  child: const Text(
                    "View",

                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: ElevatedButton(
                  onPressed: () {

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "$name removed successfully",
                        ),
                      ),
                    );
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),

                  child: const Text(
                    "Remove",

                    style: TextStyle(
                      color: Colors.white,
                    ),
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
