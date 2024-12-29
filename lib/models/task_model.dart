class TaskModel {
  final int id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime? dueDate;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    this.dueDate,
  });

  static TaskModel fromJson(Map<String, dynamic> data) {
    DateTime? dueDate;
    if (data["dueDate"] != null) {
      dueDate = DateTime.tryParse(data["dueDate"]);
    }

    return TaskModel(
      id: data["id"] ?? -1,
      title: data["title"] ?? "",
      description: data["description"] ?? "",
      dueDate: dueDate,
      isCompleted: data['isCompleted'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,
      'dueDate': dueDate?.toIso8601String(),
    };
  }

  TaskModel copyWith({
    int? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? dueDate,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      dueDate: dueDate ?? this.dueDate,
    );
  }
}
