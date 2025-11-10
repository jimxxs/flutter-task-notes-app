import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models/task_item.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'tasks.db');
    print('Database path: $path');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    print('Creating database table');
    await db.execute('''
      CREATE TABLE tasks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        priority TEXT NOT NULL,
        description TEXT NOT NULL,
        isCompleted INTEGER NOT NULL
      )
    ''');
    print('Database table created');
  }

  Future<int> insertTask(TaskItem task) async {
    final db = await database;
    final json = task.toJson();
    print('Inserting task: $json');
    final id = await db.insert('tasks', json);
    print('Task inserted with ID: $id');
    return id;
  }

  Future<List<TaskItem>> getAllTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tasks');
    print('Database query returned ${maps.length} rows');
    for (var map in maps) {
      print('Row: $map');
    }
    return List.generate(maps.length, (i) {
      return TaskItem.fromJson(maps[i]);
    });
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}