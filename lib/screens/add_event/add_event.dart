import 'package:flutter/material.dart';
import 'package:interactive_calendar_app/models/calendar_event.dart';
import 'package:interactive_calendar_app/screens/add_event/add_event_view.dart';
import 'package:interactive_calendar_app/services/auth_service.dart';
import 'package:interactive_calendar_app/services/firestore_service.dart';

class AddEvent extends StatefulWidget {
  final Function(CalendarEvent) onEventAdded;

  const AddEvent({super.key, required this.onEventAdded});
  @override
  State<StatefulWidget> createState() => AddEventState();
}

class AddEventState extends State<AddEvent> {
  late final TextEditingController titleCtrl, descCtrl;
  DateTime selectedDate = DateTime.now();
  TimeOfDay startTime = TimeOfDay(hour: 9, minute: 0);
  TimeOfDay endTime = TimeOfDay(hour: 10, minute: 0);
  String uid = 'guest';

  @override
  void initState() {
    super.initState();
    _loadUid();
    titleCtrl = TextEditingController();
    descCtrl = TextEditingController();
  }

  Future<void> _loadUid() async {
    uid = await AuthService().getCurrentUserId();
  }

  void createEvent() async {
    DateTime startDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      startTime.hour,
      startTime.minute,
    );

    DateTime endDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      endTime.hour,
      endTime.minute,
    );

    // Fix cross-midnight events --- if end time is before, adding one day
    if (endDateTime.isBefore(startDateTime)) {
      endDateTime = endDateTime.add(Duration(days: 1));
    }

    try {
      final id = await FirestoreService().createEvent(
        uid: uid,
        title: titleCtrl.text,
        description: descCtrl.text,
        startTime: startDateTime,
        endTime: endDateTime,
      );

      final event = CalendarEvent(
        id: id,
        title: titleCtrl.text,
        description: descCtrl.text,
        date: selectedDate,
        startTime: startDateTime,
        endTime: endDateTime,
      );
      widget.onEventAdded(event);

      Navigator.pop(context);
    } catch (e) {
      print("Failed to add event: $e");
    }
  }

  void pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void pickStartTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: startTime,
    );
    if (picked != null) {
      setState(() {
        startTime = picked;
      });
    }
  }

  void pickEndTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: endTime,
    );
    if (picked != null) {
      setState(() {
        endTime = picked;
      });
    }
  }

  String formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return AddEventView(this);
  }
}
