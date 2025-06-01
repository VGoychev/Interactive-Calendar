import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

class CustomDayView extends StatelessWidget{
  final List<CalendarEventData<Object?>> events;
  final EventController<CalendarEventData<Object?>> eventController;
  const CustomDayView({super.key, this.events = const [], required this.eventController});
  @override
  Widget build(BuildContext context) {
    return DayView(
      controller: eventController,
    );
  }

}