import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:interactive_calendar_app/theme/app_theme.dart';
import 'package:intl/intl.dart';

class CustomWeekView extends StatelessWidget {
  final List<CalendarEventData<Object?>> events;
  final EventController<Object?> eventController;

  const CustomWeekView({
    super.key,
    this.events = const [],
    required this.eventController,
  });

  @override
  Widget build(BuildContext context) {
    return WeekView(
      controller: eventController,
      backgroundColor: AppTheme.backgroundColor(context),
      headerStringBuilder: (start, {secondaryDate}) {
        final formatter = DateFormat('MMMM d, y');
        final startStr = formatter.format(start);
        final endStr =
            secondaryDate != null ? formatter.format(secondaryDate) : '';
        return '$startStr to $endStr';
      },
      timeLineStringBuilder: (dateTime, {secondaryDate}) {
        return DateFormat('HH:mm').format(dateTime);
      },
      weekNumberBuilder: (date) {
        final weekOfYear = weekNumber(date);
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(color: Theme.of(context).colorScheme.onSurface),
            ),
          ),
          child: Text(
            'Week $weekOfYear',
            style: TextStyle(fontSize: 13.5),
          ),
        );
      },
      headerStyle: HeaderStyle(
        headerTextStyle: TextStyle(
            fontSize: 18, color: Theme.of(context).colorScheme.onPrimary),
        decoration: BoxDecoration(color: Colors.orange),
        leftIconConfig:
            IconDataConfig(color: Theme.of(context).colorScheme.onPrimary),
        rightIconConfig:
            IconDataConfig(color: Theme.of(context).colorScheme.onPrimary),
      ),
      liveTimeIndicatorSettings: const LiveTimeIndicatorSettings(
        color: Colors.redAccent,
        height: 1.5,
      ),
      hourIndicatorSettings: HourIndicatorSettings(
          color: AppTheme.hourLineColor(context), offset: 5),
    );
  }

// ISO 8601 week number function
  int weekNumber(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysOffset = firstDayOfYear.weekday - 1;
    final firstMonday = firstDayOfYear.subtract(Duration(days: daysOffset));
    final diff = date.difference(firstMonday).inDays;
    return (diff / 7).ceil() + 1;
  }
}
