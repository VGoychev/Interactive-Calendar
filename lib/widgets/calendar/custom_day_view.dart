import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:interactive_calendar_app/theme/app_theme.dart';
import 'package:interactive_calendar_app/widgets/custom_alertdialog.dart';
import 'package:intl/intl.dart';

class CustomDayView extends StatelessWidget {
  final EventController<Object?> eventController;
  final DateTime? initialDate;
  final String uid;
  const CustomDayView({
    super.key,
    required this.uid,
    required this.eventController,
    this.initialDate,
  });
  @override
  Widget build(BuildContext context) {
    return DayView(
      controller: eventController,
      initialDay: initialDate,
      eventTileBuilder: (date, events, boundary, start, end) {
        final event = events.first;

        return Container(
          margin: const EdgeInsets.all(2),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.orangeAccent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            event.title,
            style:  TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      },
      backgroundColor: AppTheme.backgroundColor(context),
      dateStringBuilder: (date, {secondaryDate}) {
        final formatter = DateFormat('EEEE - MMMM d, y');
        return formatter.format(date);
      },
      timeStringBuilder: (dateTime, {secondaryDate}) {
        return DateFormat('HH:mm').format(dateTime);
      },
      headerStyle: HeaderStyle(
        headerTextStyle: TextStyle(
            fontSize: 18, color: Theme.of(context).colorScheme.onPrimary),
        decoration: const BoxDecoration(color: Colors.orange),
        leftIconConfig:
            IconDataConfig(color: Theme.of(context).colorScheme.onPrimary),
        rightIconConfig:
            IconDataConfig(color: Theme.of(context).colorScheme.onPrimary),
      ),
      timeLineBuilder: (dateTime) {
        return Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            DateFormat('HH:mm').format(dateTime),
            style: TextStyle(
              color: AppTheme.timeTextColor(context),
              fontSize: 14,
            ),
          ),
        );
      },
      liveTimeIndicatorSettings: const LiveTimeIndicatorSettings(
          color: Colors.redAccent, height: 1.5, offset: 15),
      onEventTap: (events, date) {
        if (events.isNotEmpty) {
          final event = events.first;
          showDialog(
              context: context,
              builder: (context) => CustomAlertDialog(event: event, uid: uid, eventController: eventController,));
        }
      },
    );
  }
}
