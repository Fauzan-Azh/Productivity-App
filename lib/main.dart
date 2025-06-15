import 'package:flutter/material.dart';

void main() => runApp(const ProductivityApp());

class ProductivityApp extends StatelessWidget {
  const ProductivityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Productivity App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'MonaSans'),
      home: const ProductivityHomePage(),
    );
  }
}

class ProductivityHomePage extends StatefulWidget {
  const ProductivityHomePage({super.key});

  @override
  State<ProductivityHomePage> createState() => _ProductivityHomePageState();
}

class _ProductivityHomePageState extends State<ProductivityHomePage> {
  final List<Map<String, dynamic>> _tasks = [];
  final TextEditingController _taskInputController = TextEditingController();

  final List<Map<String, dynamic>> _themes = [
    {
      'name': 'Ocean',
      'bg': const Color(0xFFE0F7FA),
      'primary': const Color(0xFF00BCD4),
    },
    {
      'name': 'Sunset',
      'bg': const Color(0xFFFFF3E0),
      'primary': const Color(0xFFFF9800),
    },
    {
      'name': 'Rose',
      'bg': const Color(0xFFFCE4EC),
      'primary': const Color(0xFFE91E63),
    },
    {
      'name': 'Mint',
      'bg': const Color(0xFFE8F5E9),
      'primary': const Color(0xFF4CAF50),
    },
    {
      'name': 'Lavender',
      'bg': const Color(0xFFEDE7F6),
      'primary': const Color(0xFF673AB7),
    },
  ];

  Map<String, dynamic> _selectedTheme = {
    'name': 'Ocean',
    'bg': const Color(0xFFE0F7FA),
    'primary': const Color(0xFF00BCD4),
  };

  double get _progress {
    if (_tasks.isEmpty) return 0;
    int completed = _tasks.where((t) => t['done']).length;
    return completed / _tasks.length;
  }

  void _showAddTaskDialog() {
    _taskInputController.clear();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Tambahkan Tugas Baru'),
        content: TextField(
          controller: _taskInputController,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Contoh: Belajar Flutter'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: _selectedTheme['primary']),
            onPressed: () {
              String newTask = _taskInputController.text.trim();
              if (newTask.isNotEmpty &&
                  !_tasks.any((task) => task['title'] == newTask)) {
                setState(() {
                  _tasks.add({'title': newTask, 'done': false});
                });
              }
              Navigator.pop(context);
            },
            child: const Text('Tambah'),
          )
        ],
      ),
    );
  }

  void _toggleTask(int index) {
    setState(() {
      _tasks[index]['done'] = !_tasks[index]['done'];
    });
  }

  void _deleteTask(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Tugas?'),
        content: const Text('Yakin ingin menghapus tugas ini?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal')),
          TextButton(
            onPressed: () {
              setState(() {
                _tasks.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: const Text('Hapus'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final inProgress =
        _tasks.asMap().entries.where((e) => !e.value['done']).toList();
    final completed =
        _tasks.asMap().entries.where((e) => e.value['done']).toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: _selectedTheme['bg'],
        appBar: AppBar(
          backgroundColor: _selectedTheme['primary'],
          title: const Text(
            'PRODUCTIVITY APP',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(icon: Icon(Icons.pending_actions), text: 'In Progress'),
              Tab(icon: Icon(Icons.check_circle_outline), text: 'Completed'),
            ],
          ),
        ),
        body: Column(
          children: [
            const SizedBox(height: 16),
            _buildProgressBar(),
            const SizedBox(height: 16),
            Expanded(
              child: TabBarView(
                children: [
                  _buildTaskList(inProgress),
                  _buildTaskList(completed),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildThemePicker(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: ElevatedButton.icon(
                onPressed: _showAddTaskDialog,
                icon: const Icon(Icons.add),
                label: const Text("Add Task"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedTheme['primary'],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: _selectedTheme['primary'],
          onPressed: _showAddTaskDialog,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Container(
            height: 20,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            height: 20,
            width: MediaQuery.of(context).size.width * _progress * 0.9,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _selectedTheme['primary'].withOpacity(0.9),
                  _selectedTheme['primary']
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          Center(
            child: Text(
              '${(_progress * 100).toStringAsFixed(0)}%',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTaskList(List<MapEntry<int, Map<String, dynamic>>> tasks) {
    if (tasks.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.insert_drive_file_outlined,
                size: 64, color: Colors.grey),
            SizedBox(height: 8),
            Text(
              'No tasks found',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: tasks.length,
      itemBuilder: (_, i) {
        int index = tasks[i].key;
        var task = tasks[i].value;
        return GestureDetector(
          onLongPress: () => _deleteTask(index),
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      task['title'],
                      style: TextStyle(
                        decoration: task['done']
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                  ),
                  Checkbox(
                    value: task['done'],
                    activeColor: _selectedTheme['primary'],
                    onChanged: (_) => _toggleTask(index),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildThemePicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Pick Background Theme",
              style: TextStyle(fontSize: 12)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            children: _themes.map((theme) {
              return GestureDetector(
                onTap: () => setState(() => _selectedTheme = theme),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: theme['primary'],
                    shape: BoxShape.circle,
                    border: _selectedTheme['name'] == theme['name']
                        ? Border.all(width: 3, color: Colors.black)
                        : null,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
