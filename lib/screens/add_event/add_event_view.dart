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
        title: Text('Add an Event'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 12, right: 12, top: 10, bottom: 4),
              child: CustomTextfield(
                controller: state.titleCtrl,
                label: 'Title',
              ),
            ),
            InkWell(
              onTap: () => state.pickDate(context),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                margin:
                    EdgeInsets.only(left: 12, right: 12, top: 10, bottom: 4),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).colorScheme.onSurface),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_today),
                    SizedBox(width: 8),
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
                      padding:
                          EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                      margin: EdgeInsets.only(
                          left: 12, right: 12, top: 10, bottom: 4),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).colorScheme.onSurface),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.access_time),
                          SizedBox(width: 8),
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
                      padding:
                          EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                      margin: EdgeInsets.only(
                          right: 12, left: 12, top: 10, bottom: 4),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).colorScheme.onSurface),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          
                          Icon(Icons.access_time),
                          SizedBox(width: 8),
                          Text("End: ${state.endTime.format(context)}"),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 12, right: 12, top: 10, bottom: 4),
              child: CustomTextfield(
                controller: state.descCtrl,
                label: 'Description',
                maxLines: 3,
              ),
            ),
            Row(
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12, top: 10),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('Add'),
                  ),
                )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
