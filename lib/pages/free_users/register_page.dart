import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth_service.dart';
import '../../services/validation_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              "Welcome new users!\nBecome one of us member!",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),

            buildField("Username", Icons.person, usernameController),

            buildField("Email", Icons.email, emailController),

            buildField(
              "Password",
              Icons.lock,
              passwordController,
              isPassword: true,
            ),

            buildField(
              "Confirm Password",
              Icons.lock,
              confirmPasswordController,
              isPassword: true,
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton(
                onPressed: () async {
                  String username = usernameController.text.trim();

                  String email = emailController.text.trim();

                  String password = passwordController.text.trim();

                  String confirmPassword = confirmPasswordController.text
                      .trim();

                  // VALIDATION
                  String? usernameError = ValidationService.validateUsername(username);
                  String? emailError = ValidationService.validateEmail(email);
                  String? passwordError = ValidationService.validatePassword(password);

                  if (usernameError != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(usernameError)),
                    );
                    return;
                  }

                  if (emailError != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(emailError)),
                    );
                    return;
                  }

                  if (passwordError != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(passwordError)),
                    );
                    return;
                  }

                  // PASSWORD MATCH CHECK
                  if (password != confirmPassword) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Password does not match")),
                    );

                    return;
                  }

                  try {
                    final authService = AuthService();
                    final result = await authService.registerUser(
                      username: username,
                      email: email,
                      password: password,
                    );

                    if (result.success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Register Successful")),
                      );

                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(result.message)),
                      );
                    }
                  } catch (e) {
                    print(e);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Register Failed")),
                    );
                  }
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 44, 106, 46),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),

                child: const Text(
                  "Register",

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

  Widget buildField(
    String hint,
    IconData icon,
    TextEditingController controller, {
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),

      child: TextField(
        controller: controller,
        obscureText: isPassword,

        decoration: InputDecoration(
          hintText: hint,

          filled: true,
          fillColor: const Color.fromARGB(255, 233, 247, 235),

          prefixIcon: Icon(icon),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),

            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
