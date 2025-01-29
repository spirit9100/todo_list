import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Задачи',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _taskController = TextEditingController();
  List<TaskModel> tasks = [];

  void addTask() {
    setState(() {
      if (_taskController.text.isNotEmpty) {
        tasks.add(TaskModel(title: _taskController.text));
        _taskController
            .clear(); // Очищаем текстовое поле после добавления задачи
      }
    });
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  void toggleCompletion(int index) {
    setState(() {
      tasks[index].isCompleted = !tasks[index].isCompleted;
    });
  }

  void editTask(int index, String newTitle) {
    setState(() {
      tasks[index].title = newTitle;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Список задач'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration:
                        const InputDecoration(hintText: 'Введите задачу'),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => addTask(),
                  child: const Icon(Icons.add),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 16.0),
                  elevation: 6.0,
                  child: InkWell(
                    onTap: () {
                      toggleCompletion(index);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: task.isCompleted,
                            onChanged: (value) {
                              toggleCompletion(index);
                            },
                          ),
                          Expanded(child: Text(task.title)),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              deleteTask(index);
                            },
                          ),
                          const SizedBox(
                              width: 10), // Пространство между кнопками
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              showEditTaskDialog(context, index);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showEditTaskDialog(BuildContext context, int index) async {
    final taskController = TextEditingController(text: tasks[index].title);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Редактировать задачу'),
          content: TextField(
            controller: taskController,
            decoration:
                const InputDecoration(hintText: 'Измените текст задачи'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Закрываем диалог без изменений
              },
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                if (taskController.text.isNotEmpty) {
                  editTask(index, taskController.text);
                }
                Navigator.pop(context); // Закрываем диалог после изменения
              },
              child: const Text('Сохранить'),
            ),
          ],
        );
      },
    );
  }
}

// Модель задачи
class TaskModel {
  String title;
  bool isCompleted;

  TaskModel({
    required this.title,
    this.isCompleted = false,
  });
}
