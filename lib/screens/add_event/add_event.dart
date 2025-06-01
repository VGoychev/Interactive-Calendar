import 'package:flutter/material.dart';
import 'package:interactive_calendar_app/screens/add_event/add_event_view.dart';

class AddEvent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AddEventState();
}

class AddEventState extends State<AddEvent> {
  final TextEditingController titleCtrl = TextEditingController();
  final TextEditingController descCtrl = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay startTime = TimeOfDay(hour: 9, minute: 0);
  TimeOfDay endTime = TimeOfDay(hour: 10, minute: 0);

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
