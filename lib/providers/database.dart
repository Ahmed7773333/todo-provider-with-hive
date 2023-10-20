import 'package:flutter/foundation.dart';
// ignore: depend_on_referenced_packages
import 'package:hive/hive.dart';

import '../task.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  void addTask(Task task) {
    _tasks.add(task);
    Hive.box('tasks').add(task);
    notifyListeners();
  }

  void loadTasks() {
    _tasks = Hive.box('tasks').values.cast<Task>().toList();
    notifyListeners();
  }

  void deleteTask(int index) {
    Hive.box('tasks').deleteAt(index);
    _tasks.removeAt(index);
    notifyListeners();
  }

  void updateTask(int index, Task updatedTask) {
    if (index >= 0 && index < _tasks.length) {
      // Update the task in Hive
      final taskBox = Hive.box('tasks');
      taskBox.putAt(index, updatedTask);

      // Update the task in your _tasks list
      _tasks[index] = updatedTask;

      // Notify listeners that the task has been updated
      notifyListeners();
    }
  }
}
