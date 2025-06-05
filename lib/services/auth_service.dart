import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:interactive_calendar_app/services/firestore_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final firestoreService = FirestoreService();

  Future<String?> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;

      await firestoreService.addUser(
        uid: uid,
        name: name,
        email: email,
        createdAt: Timestamp.now(),
      );

      await userCredential.user!.updateDisplayName(name);
      await userCredential.user!.reload();

      await logout();

      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return 'This email is already in use. Please log in or use a different email.';
      } else if (e.code == 'invalid-email') {
        return 'The email address is not valid.';
      } else if (e.code == 'weak-password') {
        return 'The password is too weak.';
      } else {
        return 'Registration failed. Please try again.';
      }
    } catch (e) {
      print('Registration error: $e');
      return 'An unknown error occurred.';
    }
  }

  Future<String?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found with that email.';
      } else if (e.code == 'wrong-password') {
        return 'Incorrect password.';
      } else {
        return 'Login failed. Please try again.';
      }
    } catch (_) {
      return 'An unknown error occurred.';
    }
  }

  Future<String> getCurrentUserId() async {
    final user = _auth.currentUser;
    if (user == null) {
      return 'guest';
    }
    return user.uid;
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
