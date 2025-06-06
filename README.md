# Interactive Calendar App

A modern and feature-rich calendar mobile app built with Flutter and Firebase, designed for intuitive and efficient event scheduling. Whether you're managing work, personal plans, or public events, this app provides a seamless and responsive experience.

## Features

- 🔐 **Authentication**

  - Email/password sign-up and login
  - Guest access to view public events
  - Secure user profiles powered by Firebase Authentication

- 📅 **Calendar Views**

  - Month, Week, and Day views for flexible planning
  - Responsive and intuitive UI using _calendar_view_

- ✨ **Event Management**

  - Create, edit, and delete events
  - Detailed event metadata: title, description, date & time
  - Color-coded events (e.g. Public, Personal, Work)
  - Real-time sync using Cloud Firestore

- 👤 **User Profile**
  - View user information
  - Access personal event history
  - Logout functionality

## Technologies Used

- **Flutter** – Cross-platform UI toolkit for building natively compiled applications
- **Dart** – Programming language used for Flutter development
- **Firebase Authentication** – User sign-up and login
- **Cloud Firestore** – Real-time NoSQL database for storing user and event data
- **Shared Preferences** – Local data storage for theme and session handling
- **Calendar View** – UI library for customizable calendar displays
- **Google Fonts** – Custom typography for a modern look

## Setup Instructions

### Prerequisites

- Flutter SDK (version 3.5.4 or higher)
- Dart SDK (latest stable)
- Firebase account
- Android Studio / VS Code with Flutter extensions
- Git

### Steps to Run

1. **Clone the repository:**

   ```bash
   git clone https://github.com/VGoychev/Interactive-Calendar.git
   ```

2. **Navigate to the project directory:**

   ```bash
   cd interactive_calendar_app
   ```

3. **Install dependencies**

   ```bash
   flutter pub get
   ```

4. **Firebase Setup**

   - Create a Firebase project at https://console.firebase.google.com
   - Enable Email/Password Authentication
   - Create a Cloud Firestore Database

5. **Run the app**
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── constants/      # Static values & app constants
├── models/         # Data models
├── screens/        # UI screens
├── services/       # Firebase & app services
├── theme/          # App theme settings
├── utils/          # Helpers & validations
├── widgets/        # Reusable components
└── main.dart       # App Entry point
```

## Dependencies

| Package              | Purpose                    |
| -------------------- | -------------------------- |
| `firebase_auth`      | Firebase Authentication    |
| `firebase_core`      | Firebase core services     |
| `cloud_firestore`    | Firestore database         |
| `calendar_view`      | Calendar UI components     |
| `shared_preferences` | Local storage for settings |
| `intl`               | Date/time formatting       |
| `google_fonts`       | Custom fonts support       |

## Data Structure

### User Model

```json
{
  "uid": "string",
  "email": "string",
  "name": "string",
  "createdAt": "timestamp"
}
```

### Event Model

```json
{
  "id": "string",
  "title": "string",
  "description": "string",
  "startTime": "timestamp",
  "endTime": "timestamp",
  "createdBy": "string",
  "color": "string",
  "createdAt": "timestamp",
  "updatedAt": "timestamp" // Added only if the event is updated
}
```

## Future Implementations

- 🔔 **Push Notifications**

  - Notify users about upcoming events and reminders using Firebase Cloud Messaging (FCM)

- ⏰ **Event Alerts**

  - Configurable alert times (e.g., 10 minutes, 1 hour, or 1 day before the event)
  - Local notifications even when the app is not running

- 🔁 **Recurring Events**

  - Support for creating events that repeat daily, weekly, or monthly

- 🌐 **Multi-language Support**

  - Localization and translations for multiple languages

- 📸 **Media Attachments**

  - Ability to attach images or documents to events

- 📱 **Responsive UI Enhancements**
  - Improved UI responsiveness and animations across devices

### Author

#### Vladimir Goychev
