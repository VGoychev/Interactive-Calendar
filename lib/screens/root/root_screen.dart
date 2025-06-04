import 'package:flutter/material.dart';
import 'package:interactive_calendar_app/screens/calendar/calendar.dart';
import 'package:interactive_calendar_app/screens/login/login.dart';
import 'package:interactive_calendar_app/services/auth_service.dart';

class RootScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final ThemeMode themeMode;

  const RootScreen({
    super.key,
    required this.onToggleTheme,
    required this.themeMode,
  });

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  String? _uid;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final uid = await AuthService().getCurrentUserId();
    if (!mounted) return;
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() => _uid = uid);
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (_uid == null) {
      content = const Center(
        key: ValueKey('loading'),
        child: CircularProgressIndicator(),
      );
    } else if (_uid != 'guest') {
      content = Calendar(
        onToggleTheme: widget.onToggleTheme,
        themeMode: widget.themeMode,
      );
    } else {
      content = Login(
        key: const ValueKey('login'),
        onToggleTheme: widget.onToggleTheme,
        themeMode: widget.themeMode,
      );
    }

    return Scaffold(
      body: _buildAnimatedTransition(content),
    );
  }

  Widget _buildAnimatedTransition(Widget child) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 600),
      switchInCurve: Curves.easeOutBack,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (Widget child, Animation<double> animation) {
        final fade = CurvedAnimation(parent: animation, curve: Curves.easeOut);
        final scale = Tween<double>(begin: 0.85, end: 1.0).animate(animation);

        return FadeTransition(
          opacity: fade,
          child: ScaleTransition(scale: scale, child: child),
        );
      },
      child: child,
    );
  }
  
}
