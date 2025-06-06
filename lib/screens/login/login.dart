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
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    passCtrl = TextEditingController();
    emailCtrl = TextEditingController();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    try {
      await _prefsService.init();
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    }
  }

  @override
  void dispose() {
    passCtrl.dispose();
    emailCtrl.dispose();
    super.dispose();
  }

  Future<void> login() async {
    if (!_isInitialized) return;

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
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 1000),
            pageBuilder: (context, animation, secondaryAnimation) => Calendar(
              onToggleTheme: widget.onToggleTheme,
              themeMode: Theme.of(context).brightness == Brightness.dark
                  ? ThemeMode.dark
                  : ThemeMode.light,
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
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
    if (!_isInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return LoginView(this);
  }
}
