class TaskItem {
  final int? id;
  final String title;
  final String priority;
  final String description;
  final bool isCompleted;

  TaskItem({
    this.id,
    required this.title,
    required this.priority,
    required this.description,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'priority': priority,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  factory TaskItem.fromJson(Map<String, dynamic> json) {
    return TaskItem(
      id: json['id'],
      title: json['title'],
      priority: json['priority'],
      description: json['description'],
      isCompleted: json['isCompleted'] == 1,
    );
  }
}