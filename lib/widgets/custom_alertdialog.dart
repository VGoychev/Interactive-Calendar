import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:interactive_calendar_app/models/calendar_event.dart';
import 'package:interactive_calendar_app/utils/events/event_helpers.dart';
import 'package:intl/intl.dart';

class CustomAlertDialog extends StatelessWidget {
  final EventController<CalendarEvent> eventController;
  final CalendarEventData<CalendarEvent> event;
  final String uid;

  const CustomAlertDialog({
    super.key,
    required this.event,
    required this.uid,
    required this.eventController,
  });

  @override
  Widget build(BuildContext context) {
    final CalendarEvent? realEvent = event.event;
    final String? description = event.description?.trim();
    final bool hasDescription = description != null && description.isNotEmpty;

    return AlertDialog(
      titlePadding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
      contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      title: _buildTitle(context),
      content: _buildContent(context, realEvent, hasDescription, description),
      actions: [_buildActions(context)],
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: uid != 'guest' && event.event?.createdBy == uid
                  ? const EdgeInsets.all(0)
                  : const EdgeInsets.only(
                      top: 12,
                      bottom: 14,
                    ),
              child:
                  const Text("Event Details", style: TextStyle(fontSize: 16)),
            ),
            if (uid != 'guest' && event.event?.createdBy == uid)
              TextButton(
                onPressed: () => openEditEventScreen(
                  context: context,
                  event: event,
                  eventController: eventController,
                ),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.primary,
                  textStyle: const TextStyle(fontSize: 14),
                ),
                child: const Text('Edit'),
              )
          ],
        ),
        const Divider(thickness: 0.5, height: 0.5),
      ],
    );
  }

  Widget _buildContent(BuildContext context, CalendarEvent? realEvent,
      bool hasDescription, String? description) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          event.title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          "${DateFormat('MMMM d, y').format(event.date)},",
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.6),
          ),
        ),
        Text(
          "from ${DateFormat('HH:mm').format(realEvent?.startTime ?? event.startTime!)} "
          "to ${DateFormat('HH:mm').format(realEvent?.endTime ?? event.endTime!)}",
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.6),
          ),
        ),
        if (hasDescription) const SizedBox(height: 6),
        if (hasDescription)
          Text(
            description!,
            style: Theme.of(context).textTheme.bodySmall,
          ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Stack(
      children: [
        if (uid != 'guest' && event.event?.createdBy == uid)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () => _showDeleteConfirmation(context),
              child: const Text("Delete Event",
                  style: TextStyle(color: Colors.red)),
            ),
          ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Close"),
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        onPressed: () async {
                          Navigator.of(sheetContext).pop();
                          await deleteCalendarEvent(
                            event: event,
                            controller: eventController,
                            uid: uid,
                          );
                          Navigator.of(context).pop();
                        },
                        child: const Text('Delete'),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () => Navigator.of(sheetContext).pop(),
                        child: const Text('Cancel',
                            style: TextStyle(fontWeight: FontWeight.bold)),
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
  }
}
