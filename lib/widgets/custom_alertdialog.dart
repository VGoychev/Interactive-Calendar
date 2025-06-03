import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:interactive_calendar_app/models/calendar_event.dart';
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
    final CalendarEvent? realEvent = event.event as CalendarEvent?;

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
                TextButton(
                  onPressed: () => print("Happy"),
                  child: Text('Edit'),
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    textStyle: const TextStyle(fontSize: 14),
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
            "from ${DateFormat('HH:mm').format(realEvent?.startTime ?? event.startTime!)} "
            "to ${DateFormat('HH:mm').format(realEvent?.endTime ?? event.endTime!)}",
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
                "${event.description}",
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
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    builder: (sheetContext) {
                      final screenWidth = MediaQuery.of(context).size.width;

                      return SizedBox(
                        width: screenWidth,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Are you sure you want to delete this event?',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                      ),
                                      child: const Text('Delete'),
                                      onPressed: () async {
                                        Navigator.of(sheetContext).pop();
                                        await deleteCalendarEvent(
                                          event: event,
                                          controller: eventController,
                                          uid: uid,
                                        );
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: TextButton(
                                      child: const Text('Cancel'),
                                      onPressed: () =>
                                          Navigator.of(sheetContext).pop(),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
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
