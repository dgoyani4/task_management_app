import 'package:task_management_app/utilities/widget_reference.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferences = ref.watch(preferencesProvider);
    final preferencesNotifier = ref.read(preferencesProvider.notifier);
    final taskNotifier = ref.read(taskProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text(kSettings),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              kTheme,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            RadioListTile<bool>(
              title: const Text(kLightMode),
              value: false,
              groupValue: preferences.isDarkMode,
              onChanged: (value) {
                preferencesNotifier.updateThemeMode(value!);
              },
            ),
            RadioListTile<bool>(
              title: const Text(kDarkMode),
              value: true,
              groupValue: preferences.isDarkMode,
              onChanged: (value) {
                preferencesNotifier.updateThemeMode(value!);
              },
            ),
            AppSpacing.height(16),
            const Text(
              kSortTasks,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            AppSpacing.height(8),
            RadioListTile<String>(
              title: const Text(kSortByDate),
              value: 'date',
              groupValue: preferences.defaultSortOrder,
              onChanged: (value) {
                ref.read(preferencesProvider.notifier).updateSortOrder(value!);
                taskNotifier.setSortOrder(value);
              },
            ),
            RadioListTile<String>(
              title: const Text(kSortByID),
              value: 'id',
              groupValue: preferences.defaultSortOrder,
              onChanged: (value) {
                ref.read(preferencesProvider.notifier).updateSortOrder(value!);
                taskNotifier.setSortOrder(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
