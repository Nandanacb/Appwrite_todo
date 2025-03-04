import 'package:flutter/material.dart';
import 'package:todoappwrite/appwrite_service.dart';
import 'package:todoappwrite/todo.dart';

class Todoscreen extends StatefulWidget {
  @override
  State<Todoscreen> createState() => _TodoscreenState();
}

class _TodoscreenState extends State<Todoscreen> {
  late AppwriteService _appwriteService;
  late List<Task> _tasks;
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _appwriteService = AppwriteService();
    _tasks = [];
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    try {
      final tasks = await _appwriteService.getTasks();
      setState(() {
        _tasks = tasks.map((e) => Task.fromDocument(e)).toList();
      });
    } catch (e) {
      print("Error loading tasks :$e");
    }
  }

  Future<void> _addTask() async {
    final title = _controller.text;
    if (title.isNotEmpty) {
      try {
        await _appwriteService.addTask(title);
        _controller.clear();
        _loadTasks();
      } catch (e) {
        print("Error adding task:$e");
      }
    }
  }

  Future<void> _updateTaskStatus(Task task) async {
    try {
      final updatedTask =
          await _appwriteService.updateTaskStatus(task.id, !task.completed);
      setState(() {
        task.completed != updatedTask.data['completed'];
      });
    } catch (e) {
      print("Error updating task:$e");
    }
  }

  Future<void> _deleteTask(String taskId) async {
    try {
      await _appwriteService.deleteTask(taskId);
      _loadTasks();
    } catch (e) {
      print("Error deleting task:$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TODO APP"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: "New Task"),
            ),
          ),
          ElevatedButton(onPressed: _addTask, child: Text("Add")),
          Expanded(
              child: ListView.builder(
                  itemCount: _tasks.length,
                  itemBuilder: (context, index) {
                    final task = _tasks[index];
                    return ListTile(
                      title: Text(
                        task.title,
                        style: TextStyle(
                          decoration: task.completed
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.check),
                        onPressed: () => _updateTaskStatus(task),
                      ),
                      onLongPress: () => _deleteTask(task.id),
                    );
                  }))
        ],
      ),
    );
  }
}
