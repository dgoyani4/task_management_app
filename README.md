# Task Management App

A Flutter-based task management app that allows users to manage tasks, set reminders, and customize preferences like theme mode and task sorting order. The app uses local storage with SQLite for tasks and Hive for user preferences.

## Features
- **Task Management**: Create, update, and delete tasks.
- **Reminders**: Set notifications for tasks that are due soon.
- **Customizable Preferences**: Set the app's theme (light/dark) and choose a default sort order for tasks (by date or ID).
- **Local Storage**: SQLite for task storage and Hive for preferences and notification data.
- **Notifications**: Task reminders using `flutter_local_notifications`.

## Prerequisites

Ensure you have the following tools installed:

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (version 3.x or higher)
- [Android Studio](https://developer.android.com/studio) or [Visual Studio Code](https://code.visualstudio.com/) for IDE support
- A physical Android or iOS device or an emulator/simulator for testing

## Getting Started

First, clone the repository to your local machine:

```bash
git clone https://github.com/dgoyani4/task_management_app.git

cd task_management_app
flutter pub get
flutter run
