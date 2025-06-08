import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:interactive_calendar_app/models/calendar_event.dart';
import 'package:interactive_calendar_app/screens/calendar/calendar.dart';
import 'package:interactive_calendar_app/utils/ui/calendar_view_helper.dart';
import 'package:interactive_calendar_app/widgets/custom_segmented_button.dart';

class CalendarView extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final String selectedView;
  final ValueChanged<String?> onViewChanged;
  final EventController<CalendarEvent> eventController;
  final CalendarState state;
  final Function(DateTime) onDateSelected;
  final DateTime? selectedDate;
  final bool isDateSelectedFromMonth;
  final String uid;

  const CalendarView(
    this.state, {
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.selectedView,
    required this.onViewChanged,
    required this.eventController,
    required this.onDateSelected,
    this.selectedDate,
    this.isDateSelectedFromMonth = false,
    required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        automaticallyImplyLeading: false,
        flexibleSpace: SafeArea(child: Align(alignment: Alignment.center,
        child: CustomSegmentedButton(
          selected: {selectedView},
          onSelectionChanged: (newSelection) {
            onViewChanged(newSelection.first);
          },
          segments: const [
            ButtonSegment(value: 'Month', label: Text('Month')),
            ButtonSegment(value: 'Week', label: Text('Week')),
            ButtonSegment(value: 'Day', label: Text('Day')),
          ],
        ),)),
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
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
        child: KeyedSubtree(
          key: ValueKey(selectedView),
          child: getCalendarView(
            context: context,
            eventController: eventController,
            selectedView: selectedView,
            onDateSelected: onDateSelected,
            selectedDate: selectedDate,
            uid: uid,
          ),
        ),
      ),
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
      floatingActionButton: uid == 'guest'
          ? null
          : FloatingActionButton(
              onPressed: state.onAddEventClick,
              child: const Icon(Icons.add),
            ),
    );
  }
}
