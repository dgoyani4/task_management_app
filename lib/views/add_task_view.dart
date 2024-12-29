import 'package:intl/intl.dart';
import 'package:task_management_app/utilities/widget_reference.dart';

class AddTaskScreen extends ConsumerStatefulWidget {
  final TaskModel? task; // Nullable to handle new or edit mode

  const AddTaskScreen({Key? key, this.task}) : super(key: key);

  @override
  ConsumerState<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends ConsumerState<AddTaskScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      // Pre-fill fields for editing
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _selectedDate = widget.task!.dueDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? kEditTask : kAddTask),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: kTaskTitle,
                border: OutlineInputBorder(),
              ),
            ),
            AppSpacing.height(16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: kTaskDesctription,
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            AppSpacing.height(16),
            ListTile(
              title: Text(
                (_selectedDate == null)
                    ? kSelectDueDate
                    : '$kDueDate: ${DateFormat(kDefaultDateFormat).format(_selectedDate!)}',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _selectedDate = pickedDate;
                    });
                  }
                },
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                final title = _titleController.text.trim();
                final description = _descriptionController.text.trim();

                if (title.isEmpty ||
                    description.isEmpty ||
                    _selectedDate == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text(kAllFieldsAreRequired)),
                  );
                  return;
                }

                // Fetch the current highest ID from the database
                final currentTasks = ref.read(taskProvider);
                final nextId = currentTasks.isEmpty
                    ? 1
                    : currentTasks
                            .map((task) => task.id)
                            .reduce((a, b) => a > b ? a : b) +
                        1;

                final updatedTask = TaskModel(
                  id: widget.task?.id ?? nextId,
                  title: title,
                  description: description,
                  isCompleted: widget.task?.isCompleted ?? false,
                  dueDate: _selectedDate!,
                );

                if (isEditing) {
                  ref.read(taskProvider.notifier).updateTask(updatedTask);
                } else {
                  ref.read(taskProvider.notifier).addTask(updatedTask);
                }

                Navigator.pop(context);
              },
              child: Text(isEditing ? kSaveChanges : kAddTask),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _selectedDate = null;
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
