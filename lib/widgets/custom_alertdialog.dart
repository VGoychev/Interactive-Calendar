import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:interactive_calendar_app/utils/events/event_helpers.dart';
import 'package:intl/intl.dart';

class CustomAlertDialog extends StatelessWidget {
  final EventController<Object?> eventController;
  final CalendarEventData<Object?> event;
  final String uid;
  const CustomAlertDialog(
      {super.key,
      required this.event,
      required this.uid,
      required this.eventController});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
      contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Text(
                  "Event Details",
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.start,
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.edit_calendar_outlined,
                    color: Colors.orange.shade500,
                  ),
                )
              ]),
          const Divider(
            thickness: 0.5,
            height: 0.5,
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Text(
              "${event.title}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            "${DateFormat('MMMM d, y').format(event.date)},",
            style: TextStyle(
                fontSize: 12,
                color:
                    Theme.of(context).colorScheme.onSecondary.withOpacity(0.6)),
          ),
          Text(
            "from ${DateFormat('HH:mm').format(event.startTime!)} to ${DateFormat('HH:mm').format(event.endTime!)}",
            style: TextStyle(
                fontSize: 12,
                color:
                    Theme.of(context).colorScheme.onSecondary.withOpacity(0.6)),
          ),
          if (event.description != null && event.description!.trim().isNotEmpty)
            SizedBox(
              height: 6,
            ),
          if (event.description != null && event.description!.trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                "Description: ${event.description}",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
        ],
      ),
      actions: [
        Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                child: const Text(
                  "Delete Event",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () async {
                  await deleteCalendarEvent(
                      event: event, controller: eventController, uid: uid);

                  Navigator.of(context).pop();
                },
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                child: const Text("Close"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
