import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:interactive_calendar_app/models/calendar_event.dart';
import 'package:interactive_calendar_app/screens/add_event/add_event.dart';
import 'package:interactive_calendar_app/screens/calendar/calendar_view.dart';
import 'package:interactive_calendar_app/screens/profile/profile.dart';
import 'package:interactive_calendar_app/services/auth_service.dart';
import 'package:interactive_calendar_app/services/firestore_service.dart';
import 'package:interactive_calendar_app/services/shared_prefs_service.dart';
import 'package:interactive_calendar_app/utils/events/event_helpers.dart';

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
  final EventController<CalendarEvent> _eventController =
      EventController<CalendarEvent>();
  DateTime? _selectedDate;
  bool _isDateSelectedFromMonth = false;
  String? _uid;

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
    if (!mounted) return;

    setState(() {
      _uid = uid;
    });

    if (uid != 'guest') {
      final events = await FirestoreService().getUserEvents(uid);
      if (!mounted) return;

      for (CalendarEvent event in events) {
        addEventToController(
            event: event, controller: _eventController, context: context);
      }
    } else {
      const guestColorHex = '#ffb74d';
      final guestEvents =
          await FirestoreService().getGuestEventsByColor(guestColorHex);

      for (CalendarEvent event in guestEvents) {
        addEventToController(
          event: event,
          controller: _eventController,
          context: context,
        );
      }
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

  void onAddEventClick({CalendarEvent? existingEvent}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEvent(
          existingEvent: existingEvent,
          onEventAdded: (event) {
            setState(() {
              _eventController.removeWhere((e) {
                return e.event?.id == event.id;
              });

              addEventToController(
                event: event,
                controller: _eventController,
                context: context,
              );
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_uid == null) {
      return const Center(child: CircularProgressIndicator());
    }
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
            uid: _uid!,
          ),
          Profile(
            selectedIndex: _selectedIndex,
            onItemTapped: _onItemTapped,
            onToggleTheme: widget.onToggleTheme,
            themeMode: widget.themeMode,
          ),
        ],
      ),
    );
  }
}
