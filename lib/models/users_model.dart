import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  static Future<String> getUsername() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc = await FirebaseFirestore.instance
          .collection('usersData')
          .doc(uid)
          .get();
      return doc.data()?['Username'] ?? 'User';
    }
    return 'User';
  }
}