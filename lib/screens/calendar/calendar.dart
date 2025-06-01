import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:interactive_calendar_app/screens/calendar/calendar_view.dart';
import 'package:interactive_calendar_app/screens/profile/profile_view.dart';

class Calendar extends StatefulWidget {
  @override
  State<Calendar> createState() => CalendarState();
}

class CalendarState extends State<Calendar> {
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
  Widget build(BuildContext context) {
    return IndexedStack(
      index: _selectedIndex,
      children: [
        CalendarView(
          selectedView: _selectedView,
          onViewChanged:(view) {
            if(view != null){
            setState(() => _selectedView = view);
            }
          },
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
