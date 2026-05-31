import 'package:flutter/material.dart';
import 'register_page.dart';
import '../widgets/navibar.dart';
import '../admin/pages/admin_dashboard_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Navibar()),
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        decoration: const BoxDecoration(color: Colors.white),

        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 95),

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
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Username / Email",

                  filled: true,
                  fillColor: const Color.fromARGB(255, 233, 247, 235),

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
                controller: passwordController,
                obscureText: true,

                decoration: InputDecoration(
                  hintText: "Password",

                  filled: true,
                  fillColor: const Color.fromARGB(255, 233, 247, 235),

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
                  onPressed: () async {
                    String email = emailController.text.trim();

                    String password = passwordController.text.trim();

                    try {
                      QuerySnapshot userData = await FirebaseFirestore.instance
                          .collection("usersData")
                          .where("Email", isEqualTo: email)
                          .where("Password", isEqualTo: password)
                          .get();

                      if (userData.docs.isNotEmpty) {
                        var user = userData.docs.first;

                        String role = user["Role"];

                        // ADMIN LOGIN
                        if (role == "admin") {
                          Navigator.pushReplacement(
                            context,

                            MaterialPageRoute(
                              builder: (context) => const AdminDashboardPage(),
                            ),
                          );
                        }
                        // NORMAL USER LOGIN
                        else {
                          Navigator.pushReplacement(
                            context,

                            MaterialPageRoute(
                              builder: (context) => const Navibar(),
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Invalid Email or Password"),
                          ),
                        );
                      }
                    } catch (e) {
                      print(e);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Login Failed")),
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
                  GestureDetector(
                    onTap: signInWithGoogle,
                    child: socialButton(Icons.g_mobiledata),
                  ),

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
      backgroundColor: const Color.fromARGB(255, 233, 247, 235),

      child: Icon(icon, color: Colors.green),
    );
  }
}
