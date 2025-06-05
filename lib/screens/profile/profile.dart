import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:interactive_calendar_app/models/calendar_event.dart';
import 'package:interactive_calendar_app/screens/profile/profile_view.dart';
import 'package:interactive_calendar_app/screens/root/root_screen.dart';
import 'package:interactive_calendar_app/services/auth_service.dart';
import 'package:interactive_calendar_app/services/firestore_service.dart';

class Profile extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final VoidCallback onToggleTheme;
  final ThemeMode themeMode;

  const Profile({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.onToggleTheme,
    required this.themeMode,
  });

  @override
  State<Profile> createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  String? _name;
  String? _email;
  DateTime? _createdAt;
  Stream<List<CalendarEvent>>? _events;
  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final user = AuthService().getCurrentUser();
    if (user != null) {
      final data = await FirestoreService().getUserById(user.uid);
      if (data != null) {
        setState(() {
          _name = data['name'];
          _email = data['email'];
          _createdAt = (data['createdAt'] as Timestamp).toDate();
          _events = FirestoreService().getUserEventsStream(user.uid);
        });
      }
    }
  }

  void logout(BuildContext context) async {
    await AuthService().logout();
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => RootScreen(
            onToggleTheme: widget.onToggleTheme,
            themeMode: widget.themeMode,
          ),
        ),
        (route) => false,
      );
    }
  }

  String? get name => _name;
  String? get email => _email;
  DateTime? get createdAt => _createdAt;
Stream<List<CalendarEvent>>? get eventsStream => _events;
  @override
  Widget build(BuildContext context) {
    return ProfileView(this);
  }
}
