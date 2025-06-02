import 'package:flutter/material.dart';
import 'package:interactive_calendar_app/screens/register/register_view.dart';
import 'package:interactive_calendar_app/services/auth_service.dart';

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
        const SnackBar(
            content: Text("You must agree to the terms & conditions.")),
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

    final authService = AuthService();

    String? result = await authService.registerUser(
      name: name,
      email: email,
      password: passCtrl.text,
    );

    if (result == null) {
      emailCtrl.clear();
      passCtrl.clear();
      confirmPassCtrl.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Account created successfully!")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return RegisterView(this);
  }
}
