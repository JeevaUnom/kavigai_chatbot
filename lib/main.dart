// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Task {
  final String name;
  final DateTime startDate;
  final DateTime endDate;

  Task({
    required this.name,
    required this.startDate,
    required this.endDate,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Timeline',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TaskScreen(),
    );
  }
}

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  List<Task> tasks = [];

  void addTask(String name, DateTime startDate, DateTime endDate) {
    setState(() {
      tasks.add(Task(name: name, startDate: startDate, endDate: endDate));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To Do'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: tasks.map((task) {
            return TaskItem(task: task);
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return AddTaskBottomSheet(
                addTask: addTask,
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TaskItem extends StatefulWidget {
  final Task task;

  const TaskItem({super.key, required this.task});

  @override
  _TaskItemState createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  late double _startValue;
  late double _endValue;

  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    _startDate = widget.task.startDate;
    _endDate = widget.task.endDate;

    // Convert DateTime to double for RangeSlider
    _startValue = _startDate.millisecondsSinceEpoch.toDouble();
    _endValue = _endDate.millisecondsSinceEpoch.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(widget.task.name),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Start Date: ${_startDate.toString().split(' ')[0]}'),
              IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () {
                  _selectStartDate(context);
                },
              ),
              IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () {
                  _selectEndDate(context);
                },
              ),
              Text('End Date: ${_endDate.toString().split(' ')[0]}'),
            ],
          ),
        ),
        RangeSlider(
          values: RangeValues(_startValue, _endValue),
          min: DateTime(2024).millisecondsSinceEpoch.toDouble(),
          max: DateTime(2025).millisecondsSinceEpoch.toDouble(),
          onChanged: (values) {
            setState(() {
              _startValue = values.start;
              _endValue = values.end;

              // Convert double to DateTime
              _startDate =
                  DateTime.fromMillisecondsSinceEpoch(_startValue.toInt());
              _endDate = DateTime.fromMillisecondsSinceEpoch(_endValue.toInt());
            });
          },
          labels: RangeLabels(
            _startDate.toString().split(' ')[0],
            _endDate.toString().split(' ')[0],
          ),
        ),
      ],
    );
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        _startValue = _startDate.millisecondsSinceEpoch.toDouble();
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
        _endValue = _endDate.millisecondsSinceEpoch.toDouble();
      });
    }
  }
}

class AddTaskBottomSheet extends StatefulWidget {
  final Function(String name, DateTime startDate, DateTime endDate) addTask;

  const AddTaskBottomSheet({super.key, required this.addTask});

  @override
  _AddTaskBottomSheetState createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  late TextEditingController _nameController;
  late DateTime _startDate;
  late DateTime _endDate;
  bool _isSliderEnabled = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _startDate = DateTime.now();
    _endDate = DateTime.now().add(const Duration(days: 7));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Task Name',
            ),
            onChanged: (value) {
              setState(() {
                _isSliderEnabled = value.isNotEmpty;
              });
            },
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Start Date: ${_startDate.toString().split(' ')[0]}'),
              IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () {
                  _selectStartDate(context);
                },
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('End Date: ${_endDate.toString().split(' ')[0]}'),
              IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () {
                  _selectEndDate(context);
                },
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: _isSliderEnabled
                ? () {
                    String name = _nameController.text.trim();
                    if (name.isNotEmpty) {
                      widget.addTask(name, _startDate, _endDate);
                      Navigator.of(context).pop();
                    } else {
                      // Show error message or handle empty task name
                    }
                  }
                : null,
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: _startDate,
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
