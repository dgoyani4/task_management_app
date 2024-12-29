import 'package:task_management_app/utilities/widget_reference.dart';

/// ViewModel for managing user preferences such as theme mode and default sort order.
class PreferencesViewModel extends StateNotifier<PreferencesModel> {
  /// HiveService instance to interact with local storage (Hive).
  final HiveService _hiveService;

  /// Constructor initializes the ViewModel with a default state
  /// and triggers the loading of preferences from Hive.
  PreferencesViewModel(this._hiveService)
      : super(PreferencesModel(isDarkMode: false, defaultSortOrder: 'date')) {
    _loadPreferences();
  }

  /// Loads the preferences from Hive storage and updates the state.
  void _loadPreferences() {
    // Fetches stored preferences from Hive.
    final prefsData = _hiveService.getPreferences();

    // Updates the state with the stored values or defaults if not found.
    if (prefsData != null) {
      state = PreferencesModel(
        isDarkMode: prefsData['isDarkMode'] ?? false, // Default to false.
        defaultSortOrder:
            prefsData['defaultSortOrder'] ?? 'date', // Default to 'date'.
      );
    }
  }

  /// Updates the theme mode (dark or light), saves the change to Hive, and updates the state.
  void updateThemeMode(bool isDarkMode) {
    // Updates the current state with the new theme mode.
    state = state.copyWith(isDarkMode: isDarkMode);

    // Saves the updated preferences to Hive storage.
    _hiveService.savePreferences({
      'isDarkMode': state.isDarkMode,
      'defaultSortOrder': state.defaultSortOrder,
    });
  }

  /// Updates the default sort order, saves the change to Hive, and updates the state.
  void updateSortOrder(String sortOrder) {
    // Updates the current state with the new sort order.
    state = state.copyWith(defaultSortOrder: sortOrder);

    // Saves the updated preferences to Hive storage.
    _hiveService.savePreferences({
      'isDarkMode': state.isDarkMode,
      'defaultSortOrder': state.defaultSortOrder,
    });
  }
}

/// Riverpod provider for PreferencesViewModel, managing the PreferencesModel state.
final preferencesProvider =
    StateNotifierProvider<PreferencesViewModel, PreferencesModel>(
  (ref) {
    // Creates an instance of PreferencesViewModel with HiveService.
    return PreferencesViewModel(HiveService());
  },
);
