import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:interactive_calendar_app/screens/register/register_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Register extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final ThemeMode themeMode;

  const Register(
      {super.key, required this.onToggleTheme, required this.themeMode});
  @override
  State<StatefulWidget> createState() => RegisterState();
}

class RegisterState extends State<Register> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late final TextEditingController nameCtrl,
      passCtrl,
      emailCtrl,
      confirmPassCtrl;
  bool agreedToTerms = false;

  void setAgreement(bool? value) {
    setState(() {
      agreedToTerms = value ?? false;
    });
  }

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController();
    emailCtrl = TextEditingController();
    passCtrl = TextEditingController();
    confirmPassCtrl = TextEditingController();
  }

  Future<void> register() async {
    if (!formKey.currentState!.validate()) return;

    if (!agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You must agree to the terms & conditions.")),
      );
      return;
    }
    final name = nameCtrl.text.trim();
    final email = emailCtrl.text.trim();
    final password = passCtrl.text.trim();
    final confirmPassword = confirmPassCtrl.text.trim();

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final uid = userCredential.user!.uid;

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'name': name,
        'email': email,
        'createdAt': Timestamp.now(),
      });

      await userCredential.user!.updateDisplayName(name);
      await userCredential.user!.reload();

      emailCtrl.clear();
      passCtrl.clear();
      confirmPassCtrl.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Account created successfully!")),
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      if (e.code == 'email-already-in-use') {
        errorMessage =
            'This email is already in use. Please log in or use a different email.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is not valid.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'The password is too weak.';
      } else {
        errorMessage = 'Registration failed. Please try again.';
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e, stacktrace) {
      print(stacktrace);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registration failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return RegisterView(this);
  }
}
