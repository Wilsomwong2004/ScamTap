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
  String? _username;
  String? _email;

  bool _scamAlerts = true;
  bool _appUpdates = false;


  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc = await FirebaseFirestore.instance
          .collection('usersData')
          .doc(uid)
          .get();
      if (mounted) {
        setState(() {
          _username = doc.data()?['Username'] ?? 'User';
          _email = doc.data()?['Email'] ?? '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Settings",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: Column(
          children: [
            const SizedBox(height: 10),

            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.green,
              child: const Icon(Icons.person, size: 65, color: Colors.white),
            ),

            const SizedBox(height: 15),

            Text(
              _username ?? '...',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            Text(
              _email ?? '',
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 35),

            _buildCard(context, Icons.person, "Edit Profile", onTap: () {
              _showEditProfileDialog(context);
            }),

            _buildCard(context, Icons.notifications, "Notifications", onTap: () {
              _showNotificationsDialog(context);
            }),

            _buildCard(context, Icons.lock, "Privacy", onTap: () {
              _showChangePasswordDialog(context);
            }),

            _buildCard(context, Icons.help, "Help Center", onTap: () {
              _showHelpCenterDialog(context);
            }),

            const SizedBox(height: 160),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  if (mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text(
                  "Sign Out",
                  style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // EDIT PROFILE DIALOG
  void _showEditProfileDialog(BuildContext context) {
    final usernameController = TextEditingController(text: _username);
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Profile"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: "Username",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: currentPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Current Password (required to change password)",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "New Password (optional)",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Confirm New Password",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final newUsername = usernameController.text.trim();
              final currentPassword = currentPasswordController.text.trim();
              final newPassword = newPasswordController.text.trim();
              final confirmPassword = confirmPasswordController.text.trim();

              if (newUsername.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Username cannot be empty")),
                );
                return;
              }

              if (newPassword.isNotEmpty && newPassword != confirmPassword) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Passwords do not match")),
                );
                return;
              }

              if (newPassword.isNotEmpty && currentPassword.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Enter current password to change password")),
                );
                return;
              }

              try {
                final user = FirebaseAuth.instance.currentUser!;
                final uid = user.uid;

                // UPDATE USERNAME IN FIRESTORE
                await FirebaseFirestore.instance
                    .collection('usersData')
                    .doc(uid)
                    .update({'Username': newUsername});
                setState(() => _username = newUsername);

                // UPDATE PASSWORD IF FILLED
                if (newPassword.isNotEmpty) {
                  // RE-AUTHENTICATE FIRST
                  final cred = EmailAuthProvider.credential(
                    email: user.email!,
                    password: currentPassword,
                  );
                  await user.reauthenticateWithCredential(cred);

                  // NOW UPDATE PASSWORD
                  await user.updatePassword(newPassword);
                  await FirebaseFirestore.instance
                      .collection('usersData')
                      .doc(uid)
                      .update({'Password': newPassword});
                }

                if (mounted) Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Profile updated!")),
                );
              } on FirebaseAuthException catch (e) {
                String message = "Update failed";
                if (e.code == 'wrong-password') message = "Current password is incorrect";
                if (e.code == 'weak-password') message = "New password is too weak";
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(message)),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error: $e")),
                );
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  // NOTIFICATIONS DIALOG
  void _showNotificationsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text("Notifications"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                title: const Text("Scam Alerts"),
                subtitle: const Text("Get notified about new scams"),
                value: _scamAlerts,
                onChanged: (val) {
                  setDialogState(() => _scamAlerts = val);
                  setState(() => _scamAlerts = val); // saves state outside dialog
                },
                activeColor: Colors.green,
              ),
              SwitchListTile(
                title: const Text("App Updates"),
                subtitle: const Text("Get notified about updates"),
                value: _appUpdates,
                onChanged: (val) {
                  setDialogState(() => _appUpdates = val);
                  setState(() => _appUpdates = val); // saves state outside dialog
                },
                activeColor: Colors.green,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Done"),
            ),
          ],
        ),
      ),
    );
  }

  // CHANGE PASSWORD DIALOG
  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Privacy & Terms"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Terms and Conditions",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                "1. Acceptance of Terms\n"
                "By using ScamTap, you agree to these terms. If you do not agree, please stop using the app.\n\n"
                "2. Use of Service\n"
                "ScamTap is provided for personal, non-commercial use only. You must not misuse our services.\n\n"
                "3. Data Collection\n"
                "We collect search queries and usage data to improve scam detection accuracy. Your data is stored securely and not shared with third parties.\n\n"
                "4. Accuracy Disclaimer\n"
                "ScamTap uses AI and third-party APIs to detect scams. We do not guarantee 100% accuracy. Always use your own judgment.\n\n"
                "5. Account Responsibility\n"
                "You are responsible for maintaining the security of your account and password.\n\n"
                "6. Changes to Terms\n"
                "We reserve the right to update these terms at any time. Continued use of the app means you accept the new terms.\n\n"
                "7. Contact\n"
                "For any concerns, contact us at support@scamtap.com",
                style: TextStyle(fontSize: 13, height: 1.5),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  // HELP CENTER DIALOG
  void _showHelpCenterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Help Center"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("📧 Email: support@scamtap.com"),
            SizedBox(height: 10),
            Text("🕐 Support Hours: Mon-Fri, 9am-6pm"),
            SizedBox(height: 20),
            Text("FAQ", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text("Q: How do I report a scam?"),
            Text("A: Use the Block/Report button on the scan result page."),
            SizedBox(height: 8),
            Text("Q: How accurate is the scan?"),
            Text("A: We use multiple APIs + AI for best accuracy."),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, IconData icon, String title, {required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 233, 247, 235),
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3)),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.green),
              const SizedBox(width: 15),
              Text(title, style: const TextStyle(fontSize: 16)),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios_rounded),
            ],
          ),
        ),
      ),
    );
  }
}