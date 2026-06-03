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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
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

                    // FORGOT PASSWORD
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () async {
                          if (emailController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Enter your email first")),
                            );
                            return;
                          }
                          try {
                            await FirebaseAuth.instance.sendPasswordResetEmail(
                              email: emailController.text.trim(),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Password reset email sent")),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Failed to send reset email")),
                            );
                          }
                        },
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: Color.fromARGB(255, 44, 106, 46),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // LOGIN BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        // onPressed: () async {
                        //   String email = emailController.text.trim();
                        //   String password = passwordController.text.trim();

                        //   try {
                        //     // QuerySnapshot userData = await FirebaseFirestore.instance
                        //     //     .collection("usersData")
                        //     //     .where("Email", isEqualTo: email)
                        //     //     .where("Password", isEqualTo: password)
                        //     //     .get();
                        //     final userData = await FirebaseAuth.instance
                        //           .signInWithEmailAndPassword(email: email, password: password);

                        //     final uid = userData.user!.uid;

                        //     final doc = await FirebaseFirestore.instance
                        //         .collection("usersData")
                        //         .doc(uid)
                        //         .get();

                        //     // String role = doc.data()?['Role'] ?? 'user';

                        //     if (userData.docs.isNotEmpty) {
                        //       var user = userData.docs.first;

                        //       String role = user["Role"];

                        //       // ADMIN LOGIN
                        //       if (role == "admin") {
                        //         Navigator.pushAndRemoveUntil(
                        //           context,

                        //           MaterialPageRoute(
                        //             builder: (context) => const AdminDashboardPage(),
                        //           ),

                        //           (route) => false,
                        //         );
                        //       }
                        //       // NORMAL USER LOGIN
                        //       else {
                        //         Navigator.pushAndRemoveUntil(
                        //           context,

                        //           MaterialPageRoute(
                        //             builder: (context) => const Navibar(),
                        //           ),

                        //           (route) => false,
                        //         );
                        //       }
                        //     } else {
                        //       ScaffoldMessenger.of(context).showSnackBar(
                        //         const SnackBar(
                        //           content: Text("Invalid Email or Password"),
                        //         ),
                        //       );
                        //     }
                        //   } catch (e) {
                        //     print(e);

                        //     ScaffoldMessenger.of(context).showSnackBar(
                        //       const SnackBar(content: Text("Login Failed")),
                        //     );
                        //   }
                        // },

                        onPressed: () async {
                          String input = emailController.text.trim();
                          String password = passwordController.text.trim();

                          if (input.isEmpty || password.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Please fill all fields")),
                            );
                            return;
                          }

                          try {
                            String email = input;

                            if (!input.contains('@')) {
                              final query = await FirebaseFirestore.instance
                                  .collection("usersData")
                                  .where("Username", isEqualTo: input)
                                  .limit(1)
                                  .get();

                              if (query.docs.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Username not found")),
                                );
                                return;
                              }
                              email = query.docs.first.data()['Email'];
                            }

                            final userCredential = await FirebaseAuth.instance
                                .signInWithEmailAndPassword(email: email, password: password);

                            final uid = userCredential.user!.uid;

                            final doc = await FirebaseFirestore.instance
                                .collection("usersData")
                                .doc(uid)
                                .get();

                            String role = doc.data()?['Role'] ?? 'user';

                            if (role == "admin") {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => const AdminDashboardPage()),
                                (route) => false,
                              );
                            } else {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => const Navibar()),
                                (route) => false,
                              );
                            }
                          } catch (e) {
                            print(e);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Invalid credentials")),
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

                    // GOOGLE BUTTON
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: signInWithGoogle,
                          child: socialButton(Icons.g_mobiledata),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // REGISTER
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegisterPage()),
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
        },
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
