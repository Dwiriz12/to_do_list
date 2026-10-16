import 'package:flutter/material.dart';

void main() {
  runApp(const TodoApp());
}

const Color kBg = Color(0xFFEFF4F7);
const Color kBlue = Color(0xFF7FA9E8);
const Color kBlueActive = Color(0xFF4A8ADF);
const Color kChipInactive = Color(0xFFDDE4EF);
const Color kChipText = Color(0xFF3F4552);
const Color kHeader = Color(0xFF17171F);
const Color kTaskText = Color(0xFF1B1C26);
const Color kCircleGrey = Color(0xFFB7BCC5);
const Color kFlagGrey = Color(0xFFC3C7CF);
const Color kLink = Color(0xFF9AA0A8);
const Color kNavGrey = Color(0xFF9BA1A9);

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To Do List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: kBg,
      ),
      home: const TodoHomePage(),
    );
  }
}

class Task {
  Task(this.title);

  final String title;
  bool done = false;
}

class TodoHomePage extends StatefulWidget {
  const TodoHomePage({super.key});

  @override
  State<TodoHomePage> createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
  final List<Task> _tasks = [];
  bool _todayCollapsed = false;
  bool _completedCollapsed = false;

  List<Task> get _active => _tasks.where((t) => !t.done).toList();
  List<Task> get _completed => _tasks.where((t) => t.done).toList();

  Future<void> _addTask() async {
    final title = await showDialog<String>(
      context: context,
      builder: (ctx) => const _AddTaskDialog(),
    );
    if (title != null && title.trim().isNotEmpty) {
      setState(() => _tasks.add(Task(title.trim())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final active = _active;
    final completed = _completed;

    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildChips(),
            if (active.isNotEmpty) ...[
              _sectionHeader(
                'Today (${active.length})',
                _todayCollapsed,
                () => setState(() => _todayCollapsed = !_todayCollapsed),
              ),
              if (!_todayCollapsed)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [for (final task in active) _taskCard(task)],
                  ),
                ),
            ],
            _sectionHeader(
              'Completed Today (${completed.length})',
              _completedCollapsed,
              () => setState(() => _completedCollapsed = !_completedCollapsed),
            ),
            if (!_completedCollapsed && completed.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [for (final task in completed) _taskCard(task)],
                ),
              ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 6, bottom: 4),
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Check all completed tasks',
                    style: TextStyle(
                      color: kLink,
                      fontSize: 15,
                      decoration: TextDecoration.underline,
                      decorationColor: kLink,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: active.isEmpty
                  ? Center(
                      child: Image.asset(
                        'assets/ilustrasi_kosong.png',
                        width: 230,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        backgroundColor: kBlue,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }

  Widget _buildChips() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 6, 4),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _chip('All', active: true),
                  const SizedBox(width: 10),
                  _chip('Work'),
                  const SizedBox(width: 10),
                  _chip('Personal'),
                  const SizedBox(width: 10),
                  _chip('Wishlist'),
                ],
              ),
            ),
          ),
          const Icon(Icons.more_vert, color: kChipText, size: 24),
        ],
      ),
    );
  }

  Widget _chip(String label, {bool active = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: active ? kBlue : kChipInactive,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: active ? Colors.white : kChipText,
          fontSize: 15,
          fontWeight: active ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, bool collapsed, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 8),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Row(
          children: [
            Flexible(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: kHeader,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              collapsed
                  ? Icons.keyboard_arrow_down
                  : Icons.keyboard_arrow_up,
              size: 26,
              color: kHeader,
            ),
          ],
        ),
      ),
    );
  }

  Widget _taskCard(Task task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => setState(() => task.done = !task.done),
            child: Icon(
              task.done ? Icons.check_circle : Icons.radio_button_unchecked,
              size: 26,
              color: task.done ? kBlue : kCircleGrey,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              task.title,
              style: TextStyle(
                fontSize: 18,
                color: task.done ? kLink : kTaskText,
                decoration:
                    task.done ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
          const Icon(Icons.flag_outlined, size: 22, color: kFlagGrey),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Color(0x14000000), blurRadius: 6, offset: Offset(0, -2)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 58,
          child: Row(
            children: [
              _navItem(icon: Icons.menu, badge: true),
              _navItem(
                icon: Icons.notes,
                label: 'Tasks',
                active: true,
              ),
              _navItem(
                icon: Icons.calendar_month_outlined,
                label: 'Calendar',
              ),
              _navItem(icon: Icons.person_outline, label: 'Mine'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem({
    required IconData icon,
    String? label,
    bool active = false,
    bool badge = false,
  }) {
    final color = active ? kBlueActive : kNavGrey;
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(icon, size: 24, color: color),
              if (badge)
                Positioned(
                  top: -2,
                  right: -4,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF44336),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          if (label != null) ...[
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: active ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AddTaskDialog extends StatefulWidget {
  const _AddTaskDialog();

  @override
  State<_AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<_AddTaskDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    Navigator.pop(context, _controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tugas Baru'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        textCapitalization: TextCapitalization.sentences,
        decoration: const InputDecoration(
          hintText: 'Contoh: Modul PPB 1',
          border: OutlineInputBorder(),
        ),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: _submit,
          child: const Text('Tambah'),
        ),
      ],
    );
  }
}
