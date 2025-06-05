import 'package:flutter/material.dart';
import 'package:interactive_calendar_app/models/calendar_event.dart';
import 'package:interactive_calendar_app/screens/profile/profile.dart';
import 'package:intl/intl.dart';

class ProfileView extends StatelessWidget {
  final ProfileState state;
  const ProfileView(this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDarkMode = state.widget.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Icon(
                      Icons.account_circle,
                      size: 64,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      state.name ?? "Unknown",
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        const SizedBox(width: 24),
                        const Icon(Icons.email_outlined),
                        const SizedBox(width: 10),
                        Text(
                          state.email ?? "Unknown",
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context)
                                .colorScheme
                                .onSecondary
                                .withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const SizedBox(width: 24),
                        const Icon(Icons.account_box_outlined),
                        const SizedBox(width: 10),
                        Text(
                          state.createdAt != null
                              ? "User since: ${DateFormat('MMMM d, y').format(state.createdAt!)}"
                              : "User since: Unknown",
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context)
                                .colorScheme
                                .onSecondary
                                .withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 18, right: 18),
                      child: Divider(
                        height: 0.5,
                      ),
                    ),
                    if (state.eventsStream != null)
                      _buildUserEventsList(context),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: screenWidth,
            child: TextButton(
                onPressed: () => state.logout(context),
                child: const Text(
                  'Log out',
                  style: TextStyle(fontSize: 20, color: Colors.red),
                )),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: state.widget.selectedIndex,
        onTap: state.widget.onItemTapped,
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
    );
  }

  Widget _buildUserEventsList(BuildContext context) {
    if (state.eventsStream == null) return const SizedBox.shrink();

    return StreamBuilder<List<CalendarEvent>>(
      stream: state.eventsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return const Text('Error loading events');
        }

        final events = snapshot.data ?? [];

        if (events.isEmpty) {
          return const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text('You have no events.'),
          );
        }

        // Sorting events based on start time of the event
        events.sort((a, b) => a.startTime.compareTo(b.startTime));

        return Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "My Events",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.event),
                ],
              ),
              const SizedBox(height: 10),
              ...events.map((event) {
                final date = DateFormat('MMMM d, y').format(event.startTime);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.flag_circle_outlined),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        "$date - ${event.title}",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
