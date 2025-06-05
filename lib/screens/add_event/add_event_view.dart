import 'package:flutter/material.dart';
import 'package:interactive_calendar_app/screens/add_event/add_event.dart';
import 'package:interactive_calendar_app/widgets/custom_textfield.dart';

class AddEventView extends StatelessWidget {
  final AddEventState state;

  const AddEventView(this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(state.widget.isEditing ? 'Edit Event' : 'Add an Event'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 4),
              child: CustomTextfield(
                controller: state.titleCtrl,
                label: 'Title',
              ),
            ),
            InkWell(
              onTap: () => state.pickDate(context),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                margin: const EdgeInsets.fromLTRB(12, 10, 12, 4),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).colorScheme.onSurface),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.calendar_today),
                    const SizedBox(width: 8),
                    Text("Date: ${state.formatDate(state.selectedDate)}"),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => state.pickStartTime(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 12),
                      margin: const EdgeInsets.fromLTRB(12, 10, 12, 4),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).colorScheme.onSurface),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.access_time),
                          const SizedBox(width: 8),
                          Text("Start: ${state.startTime.format(context)}"),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => state.pickEndTime(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 12),
                      margin: const EdgeInsets.fromLTRB(12, 10, 12, 4),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).colorScheme.onSurface),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.access_time),
                          const SizedBox(width: 8),
                          Text("End: ${state.endTime.format(context)}"),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
              child: CustomTextfield(
                controller: state.descCtrl,
                label: 'Description',
                maxLines: 3,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Type of the event",
                      style: TextStyle(fontWeight: FontWeight.w400)),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildColorOption(
                          context,
                          Colors.orange.shade300,
                          'public',
                          state.selectedColor,
                          () => state.setColor(Colors.orange.shade300)),
                      _buildColorOption(
                          context,
                          Colors.blue,
                          'personal',
                          state.selectedColor,
                          () => state.setColor(Colors.blue)),
                      _buildColorOption(
                          context,
                          Colors.purple.shade300,
                          'work',
                          state.selectedColor,
                          () => state.setColor(Colors.purple.shade300)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Padding(
        padding:
            const EdgeInsets.only(left: 12, right: 12, top: 10, bottom: 36),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: state.isTitleValid
                ? (state.widget.isEditing
                    ? state.updateEvent
                    : state.createEvent)
                : null,
            child: Text(state.widget.isEditing ? 'Edit' : 'Add'),
          ),
        ),
      ),
    );
  }

  Widget _buildColorOption(
    BuildContext context,
    Color color,
    String type,
    Color selectedColor,
    VoidCallback onTap,
  ) {
    final isSelected = color == selectedColor;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(
                      color: Theme.of(context).colorScheme.onSurface,
                      width: 4,
                    )
                  : null,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          type,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.6),
          ),
        )
      ],
    );
  }
}
