import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/task_item.dart';
import 'database_helper.dart';
import 'screens/add_task_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  Future<void> _toggleTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = value;
    });
    await prefs.setBool('isDarkMode', value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Notes Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      darkTheme: ThemeData.dark(),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: HomeScreen(onThemeChanged: _toggleTheme, isDarkMode: _isDarkMode),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final bool isDarkMode;

  const HomeScreen({super.key, required this.onThemeChanged, required this.isDarkMode});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<TaskItem> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = await DatabaseHelper().getAllTasks();
    setState(() {
      _tasks = tasks;
    });
  }

  Future<void> _deleteTask(int id) async {
    await DatabaseHelper().deleteTask(id);
    _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('My Tasks & Notes'),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'My Tasks & Notes',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SwitchListTile(
            title: const Text('Dark Theme'),
            value: widget.isDarkMode,
            onChanged: widget.onThemeChanged,
          ),
          Expanded(
            child: _tasks.isEmpty
                ? const Center(
                    child: Text('No tasks yet. Add one using the + button!'),
                  )
                : ListView.builder(
                    itemCount: _tasks.length,
                    itemBuilder: (context, index) {
                      final task = _tasks[index];
                      return ListTile(
                        leading: Icon(
                          task.isCompleted ? Icons.check_circle : Icons.task_alt,
                          color: task.priority == 'High'
                              ? Colors.red
                              : task.priority == 'Medium'
                                  ? Colors.orange
                                  : Colors.green,
                        ),
                        title: Text(task.title),
                        subtitle: Text('${task.priority} - ${task.description}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteTask(task.id!),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskScreen()),
          );
          if (result == true) {
            _loadTasks();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
