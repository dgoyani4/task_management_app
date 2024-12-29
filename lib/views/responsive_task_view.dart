import 'package:task_management_app/utilities/widget_reference.dart';

class ResponsiveTaskScreen extends ConsumerStatefulWidget {
  const ResponsiveTaskScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ResponsiveTaskScreen> createState() =>
      _ResponsiveTaskScreenState();
}

class _ResponsiveTaskScreenState extends ConsumerState<ResponsiveTaskScreen> {
  TaskModel? selectedTask;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Check if the screen width is greater than a tablet breakpoint (e.g., 600px)
        final isTablet = constraints.maxWidth >= 600;

        return Scaffold(
          body: isTablet ? _tabletLayout(context) : _mobileLayout(context),
        );
      },
    );
  }

  Widget _mobileLayout(BuildContext context) {
    return TaskListView(
      onTaskTap: (task) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskDetailView(
              task: task,
              onTaskDeleted: () {
                Navigator.pop(context);
              },
            ),
          ),
        );
      },
    );
  }

  Widget _tabletLayout(BuildContext context) {
    return Row(
      children: [
        // Task list view
        Flexible(
          flex: 4,
          child: TaskListView(
            onTaskTap: (task) {
              setState(() {
                selectedTask = task;
              });
            },
          ),
        ),
        Container(
          width: 1,
          color: Theme.of(context).dividerColor,
        ),
        // Task detail view or placeholder
        Flexible(
          flex: 6,
          child: selectedTask == null
              ? const Center(
                  child: Text(
                    kSelectTaskViewDetail,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : TaskDetailView(
                  task: selectedTask!,
                  onTaskDeleted: () {
                    setState(() {
                      selectedTask = null;
                    });
                  },
                ),
        ),
      ],
    );
  }
}
