import 'package:flutter/material.dart';
import '../pages/login_page.dart';

class Miniprofile extends StatelessWidget {
  const Miniprofile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        title: const Text(
          "Settings",

          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.black,
          ),
        ),

        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 20,
        ),

        child: Column(
          children: [

            const SizedBox(height: 10),

            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.green,

              child: const Icon(
                Icons.person,
                size: 65,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              "Wilsomwong",

              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Text(
              "Manage profile",

              style: TextStyle(
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 35),

            buildCard(
              context,
              Icons.person,
              "Edit Profile",
            ),

            buildCard(
              context,
              Icons.notifications,
              "Notifications",
            ),

            buildCard(
              context,
              Icons.lock,
              "Privacy",
            ),

            buildCard(
              context,
              Icons.help,
              "Help Center",
            ),

            const SizedBox(height: 50),

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton(

                onPressed: () {

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );

                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),

                child: const Text(
                  "Sign Out",

                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildCard(
    BuildContext context,
    IconData icon,
    String title,
  ) {

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),

      child: GestureDetector(

        onTap: () {

          showDialog(
            context: context,

            builder: (context) {

              return AlertDialog(
                title: Text(title),

                content: Text(
                  getMessage(title),
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

        child: Container(
          padding: const EdgeInsets.all(18),

          decoration: BoxDecoration(
            color: const Color.fromARGB(
              255,
              233,
              247,
              235,
            ),

            borderRadius: BorderRadius.circular(20),

            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),

          child: Row(
            children: [

              Icon(
                icon,
                color: Colors.green,
              ),

              const SizedBox(width: 15),

              Text(
                title,

                style: const TextStyle(
                  fontSize: 16,
                ),
              ),

              const Spacer(),

              const Icon(
                Icons.arrow_forward_ios_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String getMessage(String title) {

    switch (title) {

      case "Edit Profile":
        return "You can edit your username, email and profile picture here.";

      case "Notifications":
        return "Manage app alerts and scam warnings here.";

      case "Privacy":
        return "Control your password and account privacy settings.";

      case "Help Center":
        return "Need help? Contact support or read our guide.";

      default:
        return "Coming soon!";
    }
  }
}