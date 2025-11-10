import 'lib/database_helper.dart';
import 'lib/models/task_item.dart';

void main() async {
  print('Testing database...');
  
  final db = DatabaseHelper();
  
  // Create a test task
  final task = TaskItem(
    title: 'Test Task',
    priority: 'High',
    description: 'This is a test task',
  );
  
  try {
    // Insert the task
    final id = await db.insertTask(task);
    print('Task inserted with ID: $id');
    
    // Get all tasks
    final tasks = await db.getAllTasks();
    print('Retrieved ${tasks.length} tasks');
    
    for (var t in tasks) {
      print('Task: ${t.title} - ${t.priority} - ${t.description}');
    }
  } catch (e) {
    print('Error: $e');
  }
}