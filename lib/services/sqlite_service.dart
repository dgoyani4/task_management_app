import 'package:task_management_app/utilities/widget_reference.dart';

/// Service class for managing SQLite database interactions.
/// Implements a Singleton pattern for efficient database access.
class SQLiteService {
  /// Private static instance for the Singleton pattern.
  static final SQLiteService _instance = SQLiteService._internal();

  /// Factory constructor that returns the single instance of SQLiteService.
  factory SQLiteService() => _instance;

  /// Private constructor to initialize the SQLiteService instance.
  SQLiteService._internal();

  /// Private variable to hold the database reference.
  Database? _database;

  /// Getter for the database, initializing it lazily if not already done.
  Future<Database> get database async {
    try {
      // Return the database instance if already initialized.
      if (_database != null) return _database!;

      // Initialize and open the database if not already initialized.
      _database = await _initDB();
      return _database!;
    } catch (e) {
      debugPrint("Error while fetching database: $e");
      throw Exception("Failed to fetch or initialize the database");
    }
  }

  /// Initializes the SQLite database and creates the 'tasks' table if it doesn't exist.
  Future<Database> _initDB() async {
    try {
      // Get the directory path for the SQLite database.
      final dbPath = await getDatabasesPath();

      // Open the database at the specified path and define its structure.
      return openDatabase(
        join(dbPath,
            'tasks.db'), // Combine the directory path with the database name.
        onCreate: (db, version) async {
          await db.execute('''
          CREATE TABLE tasks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            description TEXT,
            isCompleted INTEGER NOT NULL DEFAULT 0,
            dueDate TEXT
          )
          '''); // SQL query to create the 'tasks' table.
        },
        version: 1, // Database version for future upgrades.
      );
    } catch (e) {
      debugPrint("Error while initializing database: $e");
      throw Exception("Failed to initialize the database");
    }
  }

  /// Inserts a new task into the 'tasks' table.
  ///
  /// Returns the ID of the inserted task.
  Future<int> insertTask(Map<String, dynamic> task) async {
    try {
      final db = await database;
      return db.insert('tasks', task); // Inserts the task into the table.
    } catch (e) {
      debugPrint("Error while inserting task in database: $e");
      throw Exception("Failed to insert task");
    }
  }

  /// Retrieves all tasks from the 'tasks' table.
  ///
  /// Returns a list of tasks as maps.
  Future<List<Map<String, dynamic>>> getTasks() async {
    try {
      final db = await database;
      return db.query('tasks'); // Queries all rows from the 'tasks' table.
    } catch (e) {
      debugPrint("Error while fetching tasks from database: $e");
      return []; // Returns an empty list if an error occurs.
    }
  }

  /// Updates an existing task in the 'tasks' table.
  ///
  /// Returns the number of rows affected.
  Future<int> updateTask(Map<String, dynamic> task) async {
    try {
      final db = await database;
      return db.update(
        'tasks', // Table name.
        task, // Updated task data.
        where: 'id = ?', // Specifies the row to update using the task's ID.
        whereArgs: [task['id']], // Passes the task ID as an argument.
      );
    } catch (e) {
      debugPrint("Error while updating task in database: $e");
      throw Exception("Failed to update task");
    }
  }

  /// Deletes a task from the 'tasks' table using its ID.
  ///
  /// Returns the number of rows affected.
  Future<int> deleteTask(int id) async {
    try {
      final db = await database;
      return db.delete(
        'tasks', // Table name.
        where: 'id = ?', // Specifies the row to delete using the task's ID.
        whereArgs: [id], // Passes the task ID as an argument.
      );
    } catch (e) {
      debugPrint("Error while deleting task from database: $e");
      throw Exception("Failed to delete task");
    }
  }
}
