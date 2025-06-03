import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:interactive_calendar_app/models/calendar_event.dart';
import 'package:interactive_calendar_app/theme/app_theme.dart';
import 'package:interactive_calendar_app/widgets/custom_alertdialog.dart';
import 'package:intl/intl.dart';

class CustomWeekView extends StatelessWidget {
  final EventController<CalendarEvent> eventController;
  final String uid;

  const CustomWeekView(
      {super.key, required this.eventController, required this.uid});

  @override
  Widget build(BuildContext context) {
    return WeekView(
      controller: eventController,
      backgroundColor: AppTheme.backgroundColor(context),
      timeLineStringBuilder: _buildTimeline,
      headerStringBuilder: _buildHeader,
      weekNumberBuilder: (date) => _buildWeekNumber(context, date),
      headerStyle: _buildHeaderStyle(context),
      liveTimeIndicatorSettings: const LiveTimeIndicatorSettings(
        color: Colors.redAccent,
        height: 1.5,
      ),
      hourIndicatorSettings: HourIndicatorSettings(
          color: AppTheme.hourLineColor(context), offset: 5),
      onEventTap: (events, date) {
        if (events.isNotEmpty) {
          final event = events.first;
          showDialog(
            context: context,
            builder: (context) => CustomAlertDialog(
              event: event,
              uid: uid,
              eventController: eventController,
            ),
          );
        }
      },
    );
  }

  String _buildHeader(DateTime start, {DateTime? secondaryDate}) {
    final formatter = DateFormat('MMMM d, y');
    final startStr = formatter.format(start);
    final endStr = secondaryDate != null ? formatter.format(secondaryDate) : '';
    return '$startStr to $endStr';
  }

  String _buildTimeline(DateTime dateTime, {DateTime? secondaryDate}) {
    return DateFormat('HH:mm').format(dateTime);
  }

  Widget _buildWeekNumber(BuildContext context, DateTime date) {
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
        style: const TextStyle(fontSize: 13.5),
      ),
    );
  }

  HeaderStyle _buildHeaderStyle(BuildContext context) {
    final color = Theme.of(context).colorScheme.onPrimary;
    return HeaderStyle(
      headerTextStyle: TextStyle(fontSize: 18, color: color),
      decoration: const BoxDecoration(color: Colors.orange),
      leftIconConfig: IconDataConfig(color: color),
      rightIconConfig: IconDataConfig(color: color),
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
