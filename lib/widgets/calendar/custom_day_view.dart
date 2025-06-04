import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:interactive_calendar_app/models/calendar_event.dart';
import 'package:interactive_calendar_app/theme/app_theme.dart';
import 'package:interactive_calendar_app/widgets/custom_alertdialog.dart';
import 'package:intl/intl.dart';

class CustomDayView extends StatelessWidget {
  final EventController<CalendarEvent> eventController;
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
    final onPrimary = Theme.of(context).colorScheme.onPrimary;
    return DayView(
      controller: eventController,
      initialDay: initialDate,
      eventTileBuilder: (date, events, boundary, start, end) =>
          _buildEventTile(context, events.first, onPrimary),
      backgroundColor: AppTheme.backgroundColor(context),
      dateStringBuilder: (date, {secondaryDate}) => _formatDate(date),
      timeStringBuilder: (dateTime, {secondaryDate}) => _formatTime(dateTime),
      headerStyle: _buildHeaderStyle(onPrimary),
      timeLineBuilder: (dateTime) => _buildTimeLine(context, dateTime),
      liveTimeIndicatorSettings: const LiveTimeIndicatorSettings(
          color: Colors.redAccent, height: 1.5, offset: 15),
      onEventTap: (events, date) {
        if (events.isNotEmpty) {
          final event = events.first;
          showDialog(
              context: context,
              builder: (context) => CustomAlertDialog(
                    event: event,
                    uid: uid,
                    eventController: eventController,
                  ));
        }
      },
    );
  }

  Widget _buildEventTile(
      BuildContext context, CalendarEventData eventData, Color onPrimary) {
    final CalendarEvent event = eventData.event as CalendarEvent;
    final durationMinutes = event.endTime.difference(event.startTime).inMinutes;
    final isShort = durationMinutes < 40;
    const visualMinHeight = 40.0;

    final padding = isShort
        ? const EdgeInsets.symmetric(horizontal: 6, vertical: 4)
        : const EdgeInsets.symmetric(horizontal: 10, vertical: 8);
    final fontSize = isShort ? 11.0 : 14.0;

    return SizedBox(
      height: isShort ? visualMinHeight : null,
      child: Container(
        margin: const EdgeInsets.all(2),
        padding: padding,
        decoration: BoxDecoration(
          color: Colors.orangeAccent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            event.title,
            style: TextStyle(
              fontSize: fontSize,
              color: onPrimary,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) =>
      DateFormat('EEEE - MMMM d, y').format(date);

  String _formatTime(DateTime dateTime) => DateFormat('HH:mm').format(dateTime);

  HeaderStyle _buildHeaderStyle(Color onPrimary) => HeaderStyle(
        headerTextStyle: TextStyle(fontSize: 18, color: onPrimary),
        decoration: const BoxDecoration(color: Colors.orange),
        leftIconConfig: IconDataConfig(color: onPrimary),
        rightIconConfig: IconDataConfig(color: onPrimary),
      );

  Widget _buildTimeLine(BuildContext context, DateTime dateTime) => Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Text(
          _formatTime(dateTime),
          style: TextStyle(
            color: AppTheme.timeTextColor(context),
            fontSize: 14,
          ),
        ),
      );
}
