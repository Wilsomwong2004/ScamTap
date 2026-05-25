import 'package:flutter/material.dart';

class AdminLoginPage extends StatelessWidget {
  const AdminLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [

              const Text(
                "Admin Login",

                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              TextField(
                decoration: InputDecoration(
                  hintText: "Admin Email",

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                obscureText: true,

                decoration: InputDecoration(
                  hintText: "Password",

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

                  child: const Text("Login"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}