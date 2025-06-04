import 'package:flutter/material.dart';
import 'package:interactive_calendar_app/screens/calendar/calendar.dart';
import 'package:interactive_calendar_app/screens/login/login_view.dart';
import 'package:interactive_calendar_app/services/auth_service.dart';
import 'package:interactive_calendar_app/services/shared_prefs_service.dart';

class Login extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final ThemeMode themeMode;
  const Login({
    super.key, 
    required this.onToggleTheme, 
    required this.themeMode,
  });
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

    final authService = AuthService();
    String? result = await authService.loginUser(
      email: email,
      password: password,
    );

    if (result == null) {
      emailCtrl.clear();
      passCtrl.clear();

      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Calendar(
              onToggleTheme: widget.onToggleTheme,
              themeMode: widget.themeMode,
            ),
          ),
        );
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoginView(this);
  }
}
