import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:interactive_calendar_app/screens/calendar/calendar.dart';
import 'package:interactive_calendar_app/widgets/custom_segmented_button.dart';


class CalendarView extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final String selectedView;
  final ValueChanged<String?> onViewChanged;
  final EventController<CalendarEventData<Object?>> eventController;
  final CalendarState state;

  const CalendarView(
    this.state, {
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.selectedView,
    required this.onViewChanged,
    required this.eventController,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = state.widget.themeMode == ThemeMode.dark;
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
        actions: [
          IconButton(
            onPressed: state.widget.onToggleTheme,
            icon: Icon(
              isDarkMode ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
              color: isDarkMode ? Colors.black : Colors.white,
              size: 36,
            ),
          ),
        ],
      ),
      body: getCalendarView(
          context: context,
          eventController: eventController,
          selectedView: selectedView),
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
      floatingActionButton: FloatingActionButton(onPressed: () {}, child: Icon(Icons.add),),
    );
  }
}
