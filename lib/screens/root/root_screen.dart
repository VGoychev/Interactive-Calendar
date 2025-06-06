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
  bool _showLoader = true;
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
    _startLoadingDelay();
  }

  void _startLoadingDelay() {
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _showLoader = false;
        });
      }
    });
  }

  Future<void> _checkAuthStatus() async {
    try {
      final uid = await AuthService().getCurrentUserId();
      if (!mounted) return;

      setState(() {
        _uid = uid;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _uid = 'guest';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (_uid == null || _showLoader) {
      content = const Center(
        key: ValueKey('loading'),
        child: CircularProgressIndicator(),
      );
    } else if (_uid != 'guest') {
      content = Calendar(
        onToggleTheme: widget.onToggleTheme,
        themeMode: Theme.of(context).brightness == Brightness.dark
            ? ThemeMode.dark
            : ThemeMode.light,
      );
    } else {
      content = Login(
        key: const ValueKey('login'),
        onToggleTheme: widget.onToggleTheme,
        themeMode: Theme.of(context).brightness == Brightness.dark
            ? ThemeMode.dark
            : ThemeMode.light,
      );
    }

    return Scaffold(
      body: _buildAnimatedTransition(content),
    );
  }

  Widget _buildAnimatedTransition(Widget child) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: child,
    );
  }
}
