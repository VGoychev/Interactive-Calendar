import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:interactive_calendar_app/models/calendar_event.dart';
import 'package:interactive_calendar_app/screens/add_event/add_event.dart';
import 'package:interactive_calendar_app/screens/calendar/calendar_view.dart';
import 'package:interactive_calendar_app/screens/profile/profile_view.dart';
import 'package:interactive_calendar_app/services/auth_service.dart';
import 'package:interactive_calendar_app/services/firestore_service.dart';
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
  final EventController<Object?> _eventController = EventController<Object?>();
  DateTime? _selectedDate;
  bool _isDateSelectedFromMonth = false;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _initPrefs();
    _loadEventsForCurrentUser();
  }

  Future<void> _loadEventsForCurrentUser() async {
    final uid = await AuthService().getCurrentUserId();
    if (uid != 'guest') {
      final events = await FirestoreService().getUserEvents(uid);
      for (CalendarEvent event in events) {
        _addEventToCalendar(event);
      }
    } else {
      // Handle not logged in ---- GUEST USER
    }
  }

  Future<void> _initPrefs() async {
    await _prefsService.init();
  }

  void _onViewChanged(String? view) {
    if (view != null) {
      setState(() {
        _selectedView = view;
        _selectedDate = null;
        _isDateSelectedFromMonth = false;
      });
    }
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
      _selectedView = 'Day';
      _isDateSelectedFromMonth = true;
    });
  }

  void _addEventToCalendar(dynamic event) {
    DateTime startTime = event.startTime;
    DateTime endTime = event.endTime;

    // Checking if event crosses midnight
    bool crossesMidnight = endTime.day != startTime.day;

    if (crossesMidnight) {
      DateTime firstEventEnd = DateTime(
        startTime.year,
        startTime.month,
        startTime.day,
        23,
        59,
        59,
      );

      DateTime firstEventDate =
          DateTime(startTime.year, startTime.month, startTime.day);

      final firstEvent = CalendarEventData<Object?>(
        date: firstEventDate,
        startTime: startTime,
        endTime: firstEventEnd,
        title: '${event.title ?? 'Untitled Event'} (Day 1)',
        description: event.description ?? '',
        color: Theme.of(context).colorScheme.primary,
      );

      DateTime secondEventStart = DateTime(
        endTime.year,
        endTime.month,
        endTime.day,
        0,
        0,
        0,
      );

      DateTime secondEventDate =
          DateTime(endTime.year, endTime.month, endTime.day);

      final secondEvent = CalendarEventData<Object?>(
        date: secondEventDate,
        startTime: secondEventStart,
        endTime: endTime,
        title: '${event.title ?? 'Untitled Event'} (Day 2)',
        description: event.description ?? '',
        color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
      );

      _eventController.add(firstEvent);
      _eventController.add(secondEvent);
    } else {
      DateTime eventDate =
          DateTime(startTime.year, startTime.month, startTime.day);

      final calendarEvent = CalendarEventData<Object?>(
        date: eventDate,
        startTime: startTime,
        endTime: endTime,
        title: event.title ?? 'Untitled Event',
        description: event.description ?? '',
        color: Theme.of(context).colorScheme.primary,
      );

      _eventController.add(calendarEvent);
    }
  }

  void onAddEventClick() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddEvent(onEventAdded: (event) {
            _addEventToCalendar(event);
          }),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return CalendarControllerProvider(
      controller: _eventController,
      child: IndexedStack(
        index: _selectedIndex,
        children: [
          CalendarView(
            this,
            selectedView: _selectedView,
            onViewChanged: _onViewChanged,
            eventController: _eventController,
            selectedIndex: _selectedIndex,
            onItemTapped: _onItemTapped,
            onDateSelected: _onDateSelected,
            selectedDate: _selectedDate,
            isDateSelectedFromMonth: _isDateSelectedFromMonth,
          ),
          ProfileView(
            selectedIndex: _selectedIndex,
            onItemTapped: _onItemTapped,
          ),
        ],
      ),
    );
  }
}

Widget getCalendarView({
  required BuildContext context,
  required EventController<Object?> eventController,
  required String selectedView,
  required void Function(DateTime) onDateSelected,
  DateTime? selectedDate,
}) {
  return CalendarControllerProvider(
    controller: eventController,
    child: Builder(
      builder: (context) {
        switch (selectedView) {
          case 'Day':
            return CustomDayView(
              eventController: eventController,
              initialDate: selectedDate ?? DateTime.now(),
            );
          case 'Week':
            return CustomWeekView(
              eventController: eventController,
            );
          case 'Month':
          default:
            return CustomMonthView(
              eventController: eventController,
              onDateSelected: onDateSelected,
            );
        }
      },
    ),
  );
}
