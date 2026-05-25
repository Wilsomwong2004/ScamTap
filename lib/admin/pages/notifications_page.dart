import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            TextField(
              decoration: InputDecoration(
                hintText: "Notification Title",

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              maxLines: 5,

              decoration: InputDecoration(
                hintText: "Notification Message",

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 50,

              child: ElevatedButton(
                onPressed: () {},

                child: const Text(
                  "Send Notification",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}