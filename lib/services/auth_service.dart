import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/auth_result_model.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<AuthResult> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        return AuthResult(success: false, message: 'Sign-in cancelled');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );


      final userCredential = await _auth.signInWithCredential(credential);
      final uid = userCredential.user?.uid;

      if (uid != null) {
        final userDoc = await _firestore.collection('usersData').doc(uid).get();

        if (!userDoc.exists) {
          await _firestore.collection('usersData').doc(uid).set({
            'Username': googleUser.displayName ?? 'Google User',
            'Email': googleUser.email,
            'Password': '',
            'Role': 'free user',
            'RegisterDate': DateTime.now(),
            'Profile Photo': googleUser.photoUrl ?? '',
          });
        }
      }

      return AuthResult(
        success: true,
        message: 'Signed in successfully',
        uid: uid,
      );
    } catch (e) {
      return AuthResult(success: false, message: 'Google sign-in failed: $e');
    }
  }

  Future<AuthResult> signInWithEmail(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      return AuthResult(
        success: true,
        message: 'Signed in successfully',
        uid: userCredential.user?.uid,
      );
    } on FirebaseAuthException catch (e) {
      return AuthResult(success: false, message: e.message ?? 'Sign-in failed');
    } catch (e) {
      return AuthResult(success: false, message: 'Sign-in failed: $e');
    }
  }

  Future<AuthResult> registerUser({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final uid = userCredential.user!.uid;

      await _firestore.collection('usersData').doc(uid).set({
        'Username': username.trim(),
        'Email': email.trim(),
        'Password': password,
        'Role': 'free user',
        'RegisterDate': DateTime.now(),
        'Profile Photo': '',
      });

      return AuthResult(
        success: true,
        message: 'Account created successfully',
        uid: uid,
      );
    } on FirebaseAuthException catch (e) {
      return AuthResult(
        success: false,
        message: e.message ?? 'Registration failed',
      );
    } catch (e) {
      return AuthResult(success: false, message: 'Registration failed: $e');
    }
  }

  Future<void> upgradeToPremium() async {
    try {
      String uid = _auth.currentUser!.uid;

      await _firestore.collection('usersData').doc(uid).update({
        'Role': 'premium user',
      });
    } catch (e) {
      print('Upgrade premium error: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await GoogleSignIn().signOut();
    } catch (e) {
      print('Sign out error: $e');
    }
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
