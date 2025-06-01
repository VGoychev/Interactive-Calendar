import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:interactive_calendar_app/screens/calendar/calendar_view.dart';
import 'package:interactive_calendar_app/screens/profile/profile_view.dart';
import 'package:interactive_calendar_app/services/shared_prefs_service.dart';
import 'package:interactive_calendar_app/widgets/custom_day_view.dart';
import 'package:interactive_calendar_app/widgets/custom_month_view.dart';
import 'package:interactive_calendar_app/widgets/custom_week_view.dart';

class Calendar extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final ThemeMode themeMode;

  const Calendar(
      {super.key, required this.onToggleTheme, required this.themeMode});
  @override
  State<Calendar> createState() => CalendarState();
}

class CalendarState extends State<Calendar> {
  final SharedPrefsService _prefsService = SharedPrefsService();
  int _selectedIndex = 0;
  String _selectedView = 'Month';

  final EventController<CalendarEventData<Object?>> _eventController =
      EventController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  void initState(){
    super.initState();
    _initPrefs();
  }
  Future<void> _initPrefs() async {
    await _prefsService.init();
  }

  void _onViewChanged(String? view) {
    if (view != null) {
      setState(() {
        _selectedView = view;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: _selectedIndex,
      children: [
        CalendarView(
          this,
          selectedView: _selectedView,
          onViewChanged: _onViewChanged,
          eventController: _eventController,
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
        ProfileView(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      ],
    );
  }
}

Widget getCalendarView({
  required BuildContext context,
  required EventController<CalendarEventData<Object?>> eventController,
  required String selectedView,
}) {
  return CalendarControllerProvider(
    controller: eventController,
    child: Builder(
      builder: (context) {
        switch (selectedView) {
          case 'Day':
            return CustomDayView(eventController: eventController);
          case 'Week':
            return CustomWeekView(eventController: eventController);
          case 'Month':
          default:
            return CustomMonthView(eventController: eventController);
        }
      },
    ),
  );
}
