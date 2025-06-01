import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomMonthView extends StatelessWidget{
  final List<CalendarEventData<Object?>> events;
  final EventController<CalendarEventData<Object?>> eventController;
  const CustomMonthView({super.key, this.events = const [], required this.eventController});
  @override
  Widget build(BuildContext context) {
    
    return MonthView<Object?>(
        controller: eventController,
        cellBuilder: (DateTime date, List<CalendarEventData<Object?>> events,
            bool isToday, bool isInMonth, bool isSelected) {
          return Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isToday
                  ? Colors.orange.shade300
                  : isInMonth
                      ? Colors.orange.shade50
                      : Colors.transparent,
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Text(
              '${date.day}',
              style: TextStyle(
                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                color: isInMonth ? Colors.black : Colors.grey,
              ),
            ),
          );
        },
        borderSize: 0.1,
        headerStyle: HeaderStyle(
          headerTextStyle: TextStyle(
              fontSize: 24, color: Theme.of(context).colorScheme.onPrimary),
          decoration: BoxDecoration(color: Colors.orange),
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