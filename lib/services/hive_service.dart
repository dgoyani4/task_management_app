import 'package:task_management_app/utilities/widget_reference.dart';

/// Service class for managing local storage with Hive.
/// Handles preferences and notifications storage.
class HiveService {
  /// The name of the Hive box used for storing user preferences.
  static const String preferencesBoxName = 'preferences';

  /// The name of the Hive box used for storing notification-related data.
  static const String notificationBoxName = 'notifications';

  /// Initializes Hive by opening the necessary boxes.
  ///
  /// This should be called during app startup to ensure the boxes are available.
  Future<void> initHive() async {
    try {
      await Hive.openBox(preferencesBoxName);
      await Hive.openBox(notificationBoxName);
    } catch (e) {
      debugPrint("Error while opening the Hive database: $e");
    }
  }

  /// Saves user preferences to the Hive database.
  ///
  /// [preferences] is a map containing key-value pairs of user preferences.
  Future<void> savePreferences(Map<String, dynamic> preferences) async {
    try {
      final box = Hive.box(preferencesBoxName);
      await box.put('preferences', preferences);
    } catch (e) {
      debugPrint("Error while storing preferences to Hive database: $e");
    }
  }

  /// Retrieves the saved preferences from the Hive database.
  ///
  /// Returns a map of preferences or `null` if no preferences are found or an error occurs.
  Map<String, dynamic>? getPreferences() {
    try {
      final box = Hive.box(preferencesBoxName);
      final prefs = box.get('preferences');

      // Cast the preferences to a Map<String, dynamic> if they exist and are valid.
      if (prefs != null && prefs is Map) {
        return prefs.cast<String, dynamic>();
      }
      return null; // Return null if no valid preferences are found.
    } catch (e) {
      debugPrint("Error while fetching preferences from Hive database: $e");
      return null;
    }
  }

  /// Saves the notification date for a specific task to the Hive database.
  ///
  /// [taskId] is the ID of the task, and [date] is the notification date to store.
  Future<void> saveNotificationDate(int taskId, DateTime date) async {
    try {
      final box = Hive.box(notificationBoxName);
      await box.put(taskId, date.toIso8601String());
    } catch (e) {
      debugPrint("Error while storing notification date to Hive database: $e");
    }
  }

  /// Retrieves the saved notification date for a specific task from the Hive database.
  ///
  /// [taskId] is the ID of the task.
  /// Returns a `DateTime` object or `null` if no date is found or an error occurs.
  DateTime? getNotificationDate(int taskId) {
    try {
      final box = Hive.box(notificationBoxName);
      final dateString = box.get(taskId);

      // Parse the date string into a DateTime object if it exists.
      if (dateString != null) {
        return DateTime.tryParse(dateString);
      }
      return null; // Return null if no valid date is found.
    } catch (e) {
      debugPrint(
          "Error while fetching notification date from Hive database: $e");
      return null;
    }
  }
}
