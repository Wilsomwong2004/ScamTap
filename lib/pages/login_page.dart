import 'package:flutter/material.dart';
import 'register_page.dart';
import '../widgets/navibar.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        decoration: const BoxDecoration(
          color: Colors.white,
        ),

        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 80,
          ),

          child: Column(
            children: [

              const SizedBox(height: 40),

              // LOGO
              ClipRRect(
                borderRadius: BorderRadius.circular(28),

                child: Image.asset(
                  "assets/images/scamtap_logo.png",
                  height: 110,
                  width: 110,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 40),

              // USERNAME
              TextField(
                decoration: InputDecoration(
                  hintText: "Username / Email",

                  filled: true,
                  fillColor: const Color.fromARGB(
                    255,
                    233,
                    247,
                    235,
                  ),

                  prefixIcon: const Icon(Icons.person),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // PASSWORD
              TextField(
                obscureText: true,

                decoration: InputDecoration(
                  hintText: "Password",

                  filled: true,
                  fillColor: const Color.fromARGB(
                    255,
                    233,
                    247,
                    235,
                  ),

                  prefixIcon: const Icon(Icons.lock),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              const Align(
                alignment: Alignment.centerRight,

                child: Text(
                  "Forgot Password?",

                  style: TextStyle(
                    color: Color.fromARGB(255, 44, 106, 46),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // LOGIN BUTTON
              SizedBox(
                width: double.infinity,
                height: 55,

                child: ElevatedButton(
                  onPressed: () {

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Navibar(),
                      ),
                    );

                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color.fromARGB(255, 44, 106, 46),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),

                  child: const Text(
                    "Login",

                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                "OR",

                style: TextStyle(
                  color: Color.fromARGB(255, 44, 106, 46),
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              // SOCIAL BUTTONS
              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  socialButton(Icons.g_mobiledata),

                  const SizedBox(width: 15),

                  socialButton(Icons.facebook),

                  const SizedBox(width: 15),

                  socialButton(Icons.apple),
                ],
              ),

              const SizedBox(height: 30),

              // REGISTER
              GestureDetector(
                onTap: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterPage(),
                    ),
                  );

                },

                child: const Text(
                  "No account? Register",

                  style: TextStyle(
                    color: Color.fromARGB(255, 44, 106, 46),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget socialButton(IconData icon) {
    return CircleAvatar(
      radius: 22,
      backgroundColor: const Color.fromARGB(
        255,
        233,
        247,
        235,
      ),

      child: Icon(
        icon,
        color: Colors.green,
      ),
    );
  }
}