import 'package:task_management_app/utilities/widget_reference.dart';

class TaskListView extends ConsumerWidget {
  final void Function(TaskModel task) onTaskTap;

  const TaskListView({Key? key, required this.onTaskTap}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskProvider);
    final preferences = ref.watch(preferencesProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    final filteredTasks = tasks.where((task) {
      final search = searchQuery.toLowerCase();
      return task.title.toLowerCase().contains(search) ||
          task.id.toString().contains(search);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(kTaskList),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsView()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddTaskScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (query) {
                ref.read(searchQueryProvider.notifier).state = query;
              },
              decoration: const InputDecoration(
                labelText: kSearchByIdOrTitle,
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: filteredTasks.isEmpty
                ? const Center(child: Text(kNoTaskAvailable))
                : ListView.builder(
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text("${task.id}"),
                        ),
                        title: Text(task.title),
                        subtitle: Text(task.description),
                        trailing: Checkbox(
                          value: task.isCompleted,
                          onChanged: (value) {
                            final updatedTask =
                                task.copyWith(isCompleted: value!);
                            ref
                                .read(taskProvider.notifier)
                                .updateTask(updatedTask);

                            // Apply sort order after updating the task
                            ref
                                .read(taskProvider.notifier)
                                .setSortOrder(preferences.defaultSortOrder);
                          },
                        ),
                        onTap: () => onTaskTap(task),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
