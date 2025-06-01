import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomMonthView extends StatelessWidget {
  final List<CalendarEventData<Object?>> events;
  final EventController<CalendarEventData<Object?>> eventController;
  const CustomMonthView(
      {super.key, this.events = const [], required this.eventController});
  @override
  Widget build(BuildContext context) {
    return MonthView<Object?>(
      controller: eventController,
      cellBuilder: (DateTime date, List<CalendarEventData<Object?>> events,
          bool isToday, bool isInMonth, bool isSelected) {
        return Container(
          alignment: Alignment.topRight,
          margin: const EdgeInsets.all(1),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: isToday
                ? Theme.of(context).colorScheme.secondary
                : isInMonth
                    ? Theme.of(context).colorScheme.surface
                    : Theme.of(context).colorScheme.surface.withOpacity(0.05),
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Text(
                  '${date.day}',
                  style: TextStyle(
                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                    color: isInMonth
                        ? Theme.of(context).colorScheme.onSurface
                        : Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.4),
                  ),
                ),
              ),
              if (events.isNotEmpty)
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.8),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${events.length} evt',
                      style: TextStyle(
                        fontSize: 10,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
      weekDayBuilder: (int weekday) {
        final weekdays = DateFormat.E().dateSymbols.SHORTWEEKDAYS;
        return Center(
          child: Text(
            weekdays[weekday % 7],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        );
      },
      borderSize: 0.1,
      headerStyle: HeaderStyle(
        headerTextStyle: TextStyle(
            fontSize: 18, color: Theme.of(context).colorScheme.onPrimary),
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
        leftIconConfig:
            IconDataConfig(color: Theme.of(context).colorScheme.onPrimary),
        rightIconConfig:
            IconDataConfig(color: Theme.of(context).colorScheme.onPrimary),
      ),
      headerStringBuilder: (DateTime date, {DateTime? secondaryDate}) {
        return DateFormat('MMMM, yyyy').format(date);
      },
    );
  }
}
