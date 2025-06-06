import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:interactive_calendar_app/models/calendar_event.dart';
import 'package:interactive_calendar_app/screens/add_event/add_event.dart';
import 'package:interactive_calendar_app/services/firestore_service.dart';

Future<void> deleteCalendarEvent({
  required CalendarEventData<Object?> event,
  required EventController<Object?> controller,
  required String uid,
}) async {
  final calendarEvent = event.event as CalendarEvent;

  await FirestoreService().deleteEvent(eventId: calendarEvent.id, uid: uid);

  final eventsToRemove = controller.allEvents
      .where((e) =>
          e.event is CalendarEvent &&
          (e.event as CalendarEvent).id == calendarEvent.id)
      .toList();

  for (final event in eventsToRemove) {
    controller.remove(event);
  }
}

void addEventToController({
  required CalendarEvent event,
  required EventController<CalendarEvent> controller,
  required BuildContext context,
}) {
  DateTime startTime = event.startTime;
  DateTime endTime = event.endTime;

  bool crossesMidnight = endTime.day != startTime.day;
  if (crossesMidnight) {
    DateTime firstEventEnd = DateTime(
      startTime.year,
      startTime.month,
      startTime.day,
      23,
      59,
      59,
    );

    DateTime firstEventDate =
        DateTime(startTime.year, startTime.month, startTime.day);

    final firstEvent = CalendarEventData<CalendarEvent>(
      date: firstEventDate,
      startTime: startTime,
      endTime: firstEventEnd,
      title: '${event.title} (Day 1)',
      description: event.description,
      color: event.color,
      event: event,
    );

    DateTime secondEventStart = DateTime(
      endTime.year,
      endTime.month,
      endTime.day,
      0,
      0,
      0,
    );

    DateTime secondEventDate =
        DateTime(endTime.year, endTime.month, endTime.day);

    final secondEvent = CalendarEventData<CalendarEvent>(
      date: secondEventDate,
      startTime: secondEventStart,
      endTime: endTime,
      title: '${event.title} (Day 2)',
      description: event.description,
      color: event.color,
      event: event,
    );

    controller.add(firstEvent);
    controller.add(secondEvent);
  } else {
    DateTime eventDate =
        DateTime(startTime.year, startTime.month, startTime.day);

    // Enforcing visual minimum height of 40 minutes to visualize the event normal
    const visualMinDuration = Duration(minutes: 40);
    final realDuration = endTime.difference(startTime);
    final adjustedEndTime = realDuration < visualMinDuration
        ? startTime.add(visualMinDuration)
        : endTime;

    final calendarEvent = CalendarEventData<CalendarEvent>(
      date: eventDate,
      startTime: startTime,
      endTime: adjustedEndTime,
      title: event.title,
      description: event.description,
      color: event.color,
      event: event,
    );

    controller.add(calendarEvent);
  }
}

void openEditEventScreen({
  required BuildContext context,
  required CalendarEventData<CalendarEvent> event,
  required EventController<CalendarEvent> eventController,
}) {
  Navigator.of(context).pop();

  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => AddEvent(
      onEventAdded: (updatedEvent) {
        eventController.removeWhere((e) =>
            e.event is CalendarEvent &&
            (e.event as CalendarEvent).id == (event.event as CalendarEvent).id);

        addEventToController(
          event: updatedEvent,
          controller: eventController,
          context: context,
        );
      },
      existingEvent: event.event,
      isEditing: true,
    ),
  ));
}
