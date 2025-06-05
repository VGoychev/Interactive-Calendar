import 'package:flutter/material.dart';
import 'package:interactive_calendar_app/models/calendar_event.dart';
import 'package:interactive_calendar_app/screens/add_event/add_event_view.dart';
import 'package:interactive_calendar_app/services/auth_service.dart';
import 'package:interactive_calendar_app/services/firestore_service.dart';

class AddEvent extends StatefulWidget {
  final Function(CalendarEvent) onEventAdded;
  final CalendarEvent? existingEvent;
  final bool isEditing;

  const AddEvent({
    super.key,
    required this.onEventAdded,
    this.existingEvent,
    this.isEditing = false,
  });
  @override
  State<StatefulWidget> createState() => AddEventState();
}

class AddEventState extends State<AddEvent> {
  late final TextEditingController titleCtrl, descCtrl;
  DateTime selectedDate = DateTime.now();
  TimeOfDay startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay endTime = const TimeOfDay(hour: 10, minute: 0);
  String uid = 'guest';
  bool isTitleValid = false;
  Color selectedColor = Colors.orange.shade300;

  @override
  void initState() {
    super.initState();
    _loadUid();
    _initializeControllers();
    _validateTitle();
  }

  void _validateTitle() {
    titleCtrl.addListener(() {
      final isValid = titleCtrl.text.trim().isNotEmpty;
      if (isValid != isTitleValid) {
        setState(() {
          isTitleValid = isValid;
        });
      }
    });

    isTitleValid = titleCtrl.text.trim().isNotEmpty;
  }

  void _initializeControllers() {
    final event = widget.existingEvent;

    titleCtrl = TextEditingController(text: event?.title ?? '');
    descCtrl = TextEditingController(text: event?.description ?? '');
    selectedDate = event?.date ?? DateTime.now();

    startTime = event != null
        ? TimeOfDay.fromDateTime(event.startTime)
        : const TimeOfDay(hour: 9, minute: 0);

    endTime = event != null
        ? TimeOfDay.fromDateTime(event.endTime)
        : const TimeOfDay(hour: 10, minute: 0);

    if (event != null) {
      selectedColor = event.color;
    }
  }

  Future<void> _loadUid() async {
    uid = await AuthService().getCurrentUserId();
  }

  String colorToHex(Color color) =>
      '#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}';

  void setColor(Color color) {
    setState(() {
      selectedColor = color;
    });
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
      endDateTime = endDateTime.add(const Duration(days: 1));
    }

    if (!endDateTime.isAfter(startDateTime)) {
      endDateTime = startDateTime.add(const Duration(minutes: 1));
    }

    String hexColor = colorToHex(selectedColor);

    try {
      final id = await FirestoreService().createEvent(
        uid: uid,
        title: titleCtrl.text,
        description: descCtrl.text,
        startTime: startDateTime,
        endTime: endDateTime,
        color: hexColor,
      );

      final event = CalendarEvent(
        id: id,
        title: titleCtrl.text,
        description: descCtrl.text,
        date: selectedDate,
        startTime: startDateTime,
        endTime: endDateTime,
        color: selectedColor,
      );

      widget.onEventAdded(event);

      Navigator.pop(context);
    } catch (e) {
      print("Failed to add event: $e");
    }
  }

  void updateEvent() async {
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

    if (endDateTime.isBefore(startDateTime)) {
      endDateTime = endDateTime.add(const Duration(days: 1));
    }

    if (!endDateTime.isAfter(startDateTime)) {
      endDateTime = startDateTime.add(const Duration(minutes: 1));
    }
    String hexColor = colorToHex(selectedColor);

    try {
      if (widget.existingEvent == null) return;

      await FirestoreService().updateEvent(
        eventId: widget.existingEvent!.id,
        uid: uid,
        title: titleCtrl.text,
        description: descCtrl.text,
        startTime: startDateTime,
        endTime: endDateTime,
        color: hexColor,
      );

      final updatedEvent = CalendarEvent(
        id: widget.existingEvent!.id,
        title: titleCtrl.text,
        description: descCtrl.text,
        date: selectedDate,
        startTime: startDateTime,
        endTime: endDateTime,
        color: selectedColor,
      );

      widget.onEventAdded(updatedEvent);
      Navigator.pop(context);
    } catch (e) {
      print("Failed to update event: $e");
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
