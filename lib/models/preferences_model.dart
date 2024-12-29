class PreferencesModel {
  final bool isDarkMode;
  final String defaultSortOrder;

  PreferencesModel({
    required this.isDarkMode,
    required this.defaultSortOrder,
  });

  PreferencesModel copyWith({
    bool? isDarkMode,
    String? defaultSortOrder,
  }) {
    return PreferencesModel(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      defaultSortOrder: defaultSortOrder ?? this.defaultSortOrder,
    );
  }
}
