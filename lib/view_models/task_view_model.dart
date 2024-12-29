import 'package:task_management_app/utilities/widget_reference.dart';

/// ViewModel for managing tasks, including add, update, delete, and sorting tasks.
class TaskViewModel extends StateNotifier<List<TaskModel>> {
  /// SQLiteService instance to interact with the SQLite database.
  final SQLiteService _db;

  /// Keeps track of the current sort order for tasks. Defaults to sorting by 'date'.
  String _currentSortOrder = 'date';

  /// Constructor initializes the ViewModel with an empty task list
  /// and triggers loading of tasks from the database.
  TaskViewModel(this._db) : super([]) {
    _loadTasks();
  }

  /// Loads tasks from the SQLite database, applies the current sort order,
  /// and updates the state.
  Future<void> _loadTasks() async {
    // Fetching task data from the database.
    final tasksData = await _db.getTasks();

    // Mapping the raw database data to TaskModel objects.
    final tasks = tasksData.map((e) => TaskModel.fromJson(e)).toList();

    // Scheduling notifications for tasks due in the next 2 days.
    for (var task in tasks) {
      if (NotificationService.isDueInNextTwoDays(task.dueDate) &&
          await NotificationService.shouldSendNotification(task.id)) {
        await NotificationService.showReminderNotification(task);
      }
    }

    // Applying the current sort order to the task list and updating the state.
    _applySortOrder(tasks);
  }

  /// Adds a new task to the database and reloads the task list.
  Future<void> addTask(TaskModel task) async {
    // Inserts the new task into the database.
    await _db.insertTask(task.toJson());

    // Reloads the task list after insertion.
    await _loadTasks();
  }

  /// Updates an existing task in the database and reloads the task list.
  Future<void> updateTask(TaskModel task) async {
    // Updates the task in the database.
    await _db.updateTask(task.toJson());

    // Reloads the task list after updating.
    await _loadTasks();
  }

  /// Deletes a task from the database by its ID and reloads the task list.
  Future<void> deleteTask(int id) async {
    // Deletes the task from the database by ID.
    await _db.deleteTask(id);

    // Reloads the task list after deletion.
    await _loadTasks();
  }

  /// Sets the current sort order and reloads the task list to reflect the new order.
  void setSortOrder(String sortOrder) {
    // Updates the current sort order.
    _currentSortOrder = sortOrder;

    // Reloads the tasks to apply the new sort order.
    _loadTasks();
  }

  /// Sorts the task list based on the current sort order.
  /// Supported sort orders: 'date' (due date) and 'id' (task ID).
  void _applySortOrder(List<TaskModel> tasks) {
    if (_currentSortOrder == 'date') {
      // Sorts tasks by due date in ascending order.
      tasks.sort(
          (a, b) => a.dueDate?.compareTo(b.dueDate ?? DateTime.now()) ?? 0);
    } else if (_currentSortOrder == 'id') {
      // Sorts tasks by ID in ascending order.
      tasks.sort((a, b) => a.id.compareTo(b.id));
    }

    // Updates the state with the sorted task list.
    state = tasks;
  }
}

/// Riverpod provider for the TaskViewModel, supplying the task list state.
final taskProvider = StateNotifierProvider<TaskViewModel, List<TaskModel>>(
  (ref) {
    // Returns a new TaskViewModel instance with an SQLiteService instance.
    return TaskViewModel(SQLiteService());
  },
);

/// Provider for managing the search query string in the task list.
final searchQueryProvider = StateProvider<String>((ref) => '');
