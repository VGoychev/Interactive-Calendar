import 'package:calendar_view/calendar_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:interactive_calendar_app/firebase_options.dart';
import 'package:interactive_calendar_app/screens/login/login.dart';
import 'package:interactive_calendar_app/services/shared_prefs_service.dart';
import 'package:interactive_calendar_app/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  try {
    final prefsService = SharedPrefsService();
    await prefsService.init();
    runApp(MyApp(
      prefsService: prefsService,
    ));
  } catch (e) {
    throw ErrorDescription('Error: $e');
  }
}

class MyApp extends StatefulWidget {
  final SharedPrefsService prefsService;
  const MyApp({super.key, required this.prefsService});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ThemeMode _themeMode;
  @override
  void initState() {
    super.initState();
    _themeMode =
        widget.prefsService.getThemeMode() ? ThemeMode.dark : ThemeMode.light;
  }

  void _toggleTheme() async {
    final isDark = _themeMode == ThemeMode.dark;
    final newMode = isDark ? ThemeMode.light : ThemeMode.dark;
    await widget.prefsService.setThemeMode(!isDark);
    setState(() => _themeMode = newMode);
  }

  @override
  Widget build(BuildContext context) {
    return CalendarControllerProvider(
      controller: EventController<CalendarEventData<Object?>>(),
      child: MaterialApp(
        title: 'Interactive Calendar',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: _themeMode,
        home: Login(onToggleTheme: _toggleTheme, themeMode: _themeMode),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
