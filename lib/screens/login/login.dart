import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:interactive_calendar_app/screens/calendar/calendar.dart';
import 'package:interactive_calendar_app/screens/login/login_view.dart';
import 'package:interactive_calendar_app/services/shared_prefs_service.dart';

class Login extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final ThemeMode themeMode;
  const Login(
      {super.key, required this.onToggleTheme, required this.themeMode});
  @override
  State<StatefulWidget> createState() => LoginState();
}

class LoginState extends State<Login> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late final TextEditingController passCtrl, emailCtrl;
  final SharedPrefsService _prefsService = SharedPrefsService();
  bool rememberMe = false;

  void onRememberMeChanged(bool? value) {
    setState(() {
      rememberMe = value ?? false;
    });
  }

  @override
  void initState() {
    super.initState();
    passCtrl = TextEditingController();
    emailCtrl = TextEditingController();

    _initPrefs();
  }

  Future<void> _initPrefs() async {
    await _prefsService.init();
  }

  Future<void> login() async {
    final email = emailCtrl.text.trim();
    final password = passCtrl.text;

    if (!formKey.currentState!.validate()) return;

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      emailCtrl.clear();
      passCtrl.clear();
      print('User logged in!');
      Navigator.push(context, MaterialPageRoute(builder: (context) => Calendar(onToggleTheme: widget.onToggleTheme, themeMode: widget.themeMode,)));
    } on FirebaseAuthException catch (e) {
      String message = 'Login failed';
      if (e.code == 'user-not-found') {
        message = 'No user found with that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Incorrect password.';
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoginView(this);
  }
}
