import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:interactive_calendar_app/widgets/custom_day_view.dart';
import 'package:interactive_calendar_app/widgets/custom_month_view.dart';
import 'package:interactive_calendar_app/widgets/custom_segmented_button.dart';
import 'package:interactive_calendar_app/widgets/custom_week_view.dart';
import 'package:intl/intl.dart';

class CalendarView extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final String selectedView;
  final ValueChanged<String?> onViewChanged;
  final EventController<CalendarEventData<Object?>> eventController;

  const CalendarView({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.selectedView,
    required this.onViewChanged,
    required this.eventController,
  });

  Widget _getView(BuildContext context) {
    return CalendarControllerProvider(
      controller: eventController,
      child: Builder(
        builder: (context) {
          switch (selectedView) {
            case 'Day':
              return CustomDayView(eventController: eventController);
            case 'Week':
              return CustomWeekView(eventController: eventController);
            case 'Month':
            default:
              return CustomMonthView(eventController: eventController);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomSegmentedButton(
          selected: {selectedView},
          onSelectionChanged: (newSelection) {
            onViewChanged(newSelection.first);
          },
          segments: const [
            ButtonSegment(value: 'Month', label: Text('Month')),
            ButtonSegment(value: 'Week', label: Text('Week')),
            ButtonSegment(value: 'Day', label: Text('Day')),
          ],
        ),
      ),
      body: _getView(context),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
