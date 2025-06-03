import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:interactive_calendar_app/models/calendar_event.dart';
import 'package:intl/intl.dart';

class CustomMonthView extends StatelessWidget {
  final EventController<CalendarEvent> eventController;
  final ValueChanged<DateTime> onDateSelected;

  const CustomMonthView({
    super.key,
    required this.eventController,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return MonthView(
      controller: eventController,
      onCellTap: (events, date) => onDateSelected(date),
      cellBuilder: (date, events, isToday, isInMonth, isSelected) =>
          _buildCell(context, date, events, isToday, isInMonth, isSelected),
      weekDayBuilder: (weekday) => _buildWeekDay(context, weekday),
      headerStringBuilder: _buildHeaderText,
      headerStyle: _buildHeaderStyle(context),
      borderSize: 0.1,
    );
  }

  Widget _buildCell(
    BuildContext context,
    DateTime date,
    List<CalendarEventData<Object?>> events,
    bool isToday,
    bool isInMonth,
    bool isSelected,
  ) {
    final theme = Theme.of(context).colorScheme;

    return Container(
      alignment: Alignment.topRight,
      margin: const EdgeInsets.all(1),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: isInMonth
            ? theme.surface
            : theme.surface.withOpacity(0.05),
        border: Border.all(
          color: isSelected
              ? theme.primary
              : theme.onSurface.withOpacity(0.1),
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: isToday
                ? _buildTodayCircle(context, date.day)
                : _buildDayText(context, date.day, isInMonth),
          ),
          if (events.isNotEmpty) _buildEventBadge(context, events.length),
        ],
      ),
    );
  }

  Widget _buildTodayCircle(BuildContext context, int day) {
    final theme = Theme.of(context).colorScheme;
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: theme.secondary,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        '$day',
        style: TextStyle(
          color: theme.onPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDayText(BuildContext context, int day, bool isInMonth) {
    final theme = Theme.of(context).colorScheme;
    return Text(
      '$day',
      style: TextStyle(
        fontWeight: FontWeight.normal,
        color: isInMonth
            ? theme.onSurface
            : theme.onSurface.withOpacity(0.4),
      ),
    );
  }

  Widget _buildEventBadge(BuildContext context, int count) {
    final theme = Theme.of(context).colorScheme;
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
        decoration: BoxDecoration(
          color: theme.secondary.withOpacity(0.8),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          '$count evt',
          style: TextStyle(
            fontSize: 10,
            color: theme.onPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildWeekDay(BuildContext context, int weekday) {
    final weekdays = DateFormat.E().dateSymbols.SHORTWEEKDAYS;
    final theme = Theme.of(context).colorScheme;

    return Center(
      child: Text(
        weekdays[weekday % 7],
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: theme.primary,
        ),
      ),
    );
  }

  String _buildHeaderText(DateTime date, {DateTime? secondaryDate}) {
    return DateFormat('MMMM, yyyy').format(date);
  }

  HeaderStyle _buildHeaderStyle(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return HeaderStyle(
      headerTextStyle: TextStyle(fontSize: 18, color: theme.onPrimary),
      decoration: BoxDecoration(color: theme.primary),
      leftIconConfig: IconDataConfig(color: theme.onPrimary),
      rightIconConfig: IconDataConfig(color: theme.onPrimary),
    );
  }
}
