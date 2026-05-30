import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7F1),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        title: const Text(
          "Notifications",

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
              "Broadcast Notifications",

              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const Text(
              "Send announcements and alerts to ScamTap users.",

              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),

            const SizedBox(height: 30),

            // TITLE FIELD
            Container(
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

              child: TextField(
                decoration: InputDecoration(
                  hintText: "Notification Title",

                  prefixIcon: const Icon(Icons.title),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),

                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // MESSAGE FIELD
            Container(
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

              child: TextField(
                maxLines: 6,

                decoration: InputDecoration(
                  hintText: "Type notification message here...",

                  alignLabelWithHint: true,

                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(bottom: 90),

                    child: Icon(Icons.message_outlined),
                  ),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),

                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // SEND BUTTON
            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,

                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Notification Sent"),

                        content: const Text(
                          "Your notification has been sent successfully.",
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
                  backgroundColor: Colors.green.shade700,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),

                child: const Text(
                  "Send Notification",

                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 35),

            // RECENT NOTIFICATIONS
            const Text(
              "Recent Notifications",

              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            notificationCard(
              title: "Scam Alert",
              message: "Beware of fake banking SMS spreading recently.",
              color: Colors.red,
            ),

            const SizedBox(height: 15),

            notificationCard(
              title: "System Maintenance",
              message: "ScamTap system maintenance tonight at 12AM.",
              color: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget notificationCard({
    required String title,
    required String message,
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

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.15),

            child: Icon(Icons.notifications_active, color: color),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  message,

                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
