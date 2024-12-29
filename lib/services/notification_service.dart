import 'package:task_management_app/utilities/widget_reference.dart';

/// Service for handling local notifications, including initialization,
/// sending reminders, and managing notification logic.
class NotificationService {
  /// Instance of FlutterLocalNotificationsPlugin to manage notifications.
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Initializes the notification service for Android and iOS platforms.
  ///
  /// Requests permissions for notifications on iOS and sets up initialization settings.
  static Future<void> initializeNotifications() async {
    try {
      // Android-specific initialization settings.
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      // General initialization settings for both Android and iOS.
      final InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: DarwinInitializationSettings(),
      );

      // Initialize the FlutterLocalNotificationsPlugin.
      await flutterLocalNotificationsPlugin.initialize(initializationSettings);

      // Request notification permissions on iOS.
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } catch (e) {
      debugPrint("Error while initializing notifications: $e");
    }
  }

  /// Displays a reminder notification for the specified task.
  ///
  /// [task] is the task for which the notification should be sent.
  /// Also saves the notification's date in Hive.
  static Future<void> showReminderNotification(TaskModel task) async {
    try {
      // Android-specific notification details.
      const AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
        'task_reminder_channel_id', // Channel ID for task reminders.
        'Task Reminders', // Channel name.
        channelDescription: 'Reminders for upcoming tasks',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: false,
      );

      // General notification details.
      const NotificationDetails notificationDetails =
          NotificationDetails(android: androidNotificationDetails);

      // Show the notification with the task details.
      await flutterLocalNotificationsPlugin.show(
        task.id, // Unique notification ID (use task ID).
        'Task Reminder: ${task.title}', // Notification title.
        'Your task "${task.title}" is due soon!', // Notification body.
        notificationDetails,
        payload: task.id.toString(), // Payload for notification actions.
      );

      // Save the notification's sent date in Hive.
      await HiveService().saveNotificationDate(task.id, DateTime.now());
    } catch (e) {
      debugPrint("Error while sending notification: $e");
    }
  }

  /// Checks if a task's due date is within the next two days.
  ///
  /// [dueDate] is the due date of the task.
  /// Returns `true` if the task is due within the next two days, otherwise `false`.
  static bool isDueInNextTwoDays(DateTime? dueDate) {
    try {
      if (dueDate == null) return false; // If no due date, return false.
      final currentDate = DateTime.now();
      final difference = dueDate.difference(currentDate).inDays;
      return difference >= 0 && difference <= 2; // Due within the next 2 days.
    } catch (e) {
      debugPrint("Error while checking due date: $e");
      return false;
    }
  }

  /// Determines whether a notification should be sent for a task.
  ///
  /// [taskId] is the ID of the task.
  /// Returns `true` if a notification can be sent (not sent today), otherwise `false`.
  static Future<bool> shouldSendNotification(int taskId) async {
    try {
      final lastSentDate = HiveService().getNotificationDate(taskId);
      final today = DateTime.now();

      // Allow sending only if no notification has been sent today.
      if (lastSentDate == null ||
          lastSentDate.year != today.year ||
          lastSentDate.month != today.month ||
          lastSentDate.day != today.day) {
        return true;
      }

      return false;
    } catch (e) {
      debugPrint("Error while checking notification eligibility: $e");
      return false;
    }
  }
}
