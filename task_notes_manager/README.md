# Task Notes Manager

**Name:** Ssessanga Jim Edward
**Student Number:** 2300717752  
**Registration Number:** 23/U/17752/EVE

## Description

A Flutter application for managing tasks and notes with the following features:
- Add new tasks with title, priority (Low/Medium/High), and description
- View all tasks in a dynamic list
- Dark/Light theme toggle with persistent settings
- Local database storage using SQLite
- Delete tasks functionality

## Features

- **Task Management**: Create, view, and delete tasks
- **Priority System**: Assign Low, Medium, or High priority to tasks
- **Theme Switching**: Toggle between light and dark themes (persisted using SharedPreferences)
- **Local Storage**: Tasks are stored locally using SQLite database
- **Form Validation**: Input validation for task creation

## How to Run

1. Ensure Flutter is installed on your system
2. Clone this repository
3. Navigate to the project directory
4. Run the following commands:

```bash
flutter pub get
flutter run
```

## Dependencies

- `shared_preferences: ^2.2.2` - For storing theme preferences
- `sqflite: ^2.3.0` - For local SQLite database
- `path: ^1.8.3` - For database path management

## Project Structure

```
lib/
├── main.dart                 # Main app entry point with theme management
├── models/
│   └── task_item.dart       # TaskItem model with JSON serialization
├── screens/
│   └── add_task_screen.dart # Add task form screen
└── database_helper.dart     # SQLite database helper class
```