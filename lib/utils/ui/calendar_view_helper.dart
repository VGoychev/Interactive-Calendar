import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:interactive_calendar_app/models/calendar_event.dart';
import 'package:interactive_calendar_app/widgets/calendar/custom_day_view.dart';
import 'package:interactive_calendar_app/widgets/calendar/custom_month_view.dart';
import 'package:interactive_calendar_app/widgets/calendar/custom_week_view.dart';


Widget getCalendarView({
  required BuildContext context,
  required EventController<CalendarEvent> eventController,
  required String selectedView,
  required void Function(DateTime) onDateSelected,
  required String uid,
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
              uid: uid,
            );
          case 'Week':
            return CustomWeekView(
              eventController: eventController,
              uid: uid,
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