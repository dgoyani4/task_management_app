import 'package:task_management_app/utilities/widget_reference.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await HiveService().initHive();
  await NotificationService.initializeNotifications();

  // Check and request notification permissions
  await _checkAndRequestNotificationPermission();

  runApp(const ProviderScope(child: MyApp()));
}

Future<void> _checkAndRequestNotificationPermission() async {
  final status = await Permission.notification.status;

  if (status.isDenied || status.isPermanentlyDenied) {
    // Request permission
    final result = await Permission.notification.request();

    if (result.isDenied || result.isPermanentlyDenied) {
      // Show a dialog prompting the user to enable notifications
      _showEnableNotificationDialog();
    }
  }
}

void _showEnableNotificationDialog() {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) {
        return AlertDialog(
          title: const Text(kEnableNotifications),
          content: const Text(
            kNotificationsAreDisabled,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(kCancle),
            ),
            TextButton(
              onPressed: () {
                openAppSettings(); // Open app settings

                Navigator.of(context).pop();
              },
              child: const Text(kOpenSettings),
            ),
          ],
        );
      },
    );
  });
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferences = ref.watch(preferencesProvider);

    return MaterialApp(
      navigatorKey: navigatorKey,
      title: kAppTitle,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: preferences.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const ResponsiveTaskScreen(),
    );
  }
}
