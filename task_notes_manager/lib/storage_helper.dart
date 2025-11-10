import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'models/task_item.dart';

class StorageHelper {
  static final StorageHelper _instance = StorageHelper._internal();
  factory StorageHelper() => _instance;
  StorageHelper._internal();

  static const String _tasksKey = 'tasks';
  static int _nextId = 1;

  Future<int> insertTask(TaskItem task) async {
    final prefs = await SharedPreferences.getInstance();
    final tasks = await getAllTasks();
    
    final newTask = TaskItem(
      id: _nextId++,
      title: task.title,
      priority: task.priority,
      description: task.description,
      isCompleted: task.isCompleted,
    );
    
    tasks.add(newTask);
    await _saveTasks(tasks);
    return newTask.id!;
  }

  Future<List<TaskItem>> getAllTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = prefs.getStringList(_tasksKey) ?? [];
    return tasksJson.map((json) => TaskItem.fromJson(jsonDecode(json))).toList();
  }

  Future<int> deleteTask(int id) async {
    final tasks = await getAllTasks();
    tasks.removeWhere((task) => task.id == id);
    await _saveTasks(tasks);
    return 1;
  }

  Future<void> _saveTasks(List<TaskItem> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = tasks.map((task) => jsonEncode(task.toJson())).toList();
    await prefs.setStringList(_tasksKey, tasksJson);
  }
}