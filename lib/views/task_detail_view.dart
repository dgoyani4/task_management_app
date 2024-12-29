import 'package:intl/intl.dart';
import 'package:task_management_app/utilities/widget_reference.dart';

class TaskDetailView extends ConsumerWidget {
  final TaskModel task;
  final VoidCallback? onTaskDeleted;

  const TaskDetailView({
    Key? key,
    required this.task,
    this.onTaskDeleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(kTaskDetail),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final updatedTask = await Navigator.push<TaskModel>(
                context,
                MaterialPageRoute(
                  builder: (context) => AddTaskScreen(
                    task: task,
                  ),
                ),
              );

              // If an updated task is returned, refresh the task details
              if (updatedTask != null) {
                ref.read(taskProvider.notifier).updateTask(updatedTask);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final confirmDelete = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text(kDeleteTask),
                  content: const Text(kAreYouSureDeleteTask),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text(kCancle),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text(kDelete),
                    ),
                  ],
                ),
              );

              if (confirmDelete ?? false) {
                ref.read(taskProvider.notifier).deleteTask(task.id);
                onTaskDeleted?.call();
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            AppSpacing.height(8),
            Text(task.description),
            AppSpacing.height(16),
            if (task.dueDate != null)
              Text(
                  '$kDueDate: ${DateFormat(kDefaultDateFormat).format(task.dueDate!)}'),
            AppSpacing.height(16),
            Text('$kStatus: ${task.isCompleted ? kCompleted : kPending}'),
          ],
        ),
      ),
    );
  }
}
