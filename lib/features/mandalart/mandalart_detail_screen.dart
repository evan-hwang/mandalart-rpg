import 'package:flutter/material.dart';
import 'package:mandalart/features/mandalart/mandalart.dart';

enum GoalStatus { todo, doing, done }

class _GoalCell {
  _GoalCell({
    required this.text,
    required this.status,
  });

  String text;
  GoalStatus status;
}

class MandalartDetailScreen extends StatefulWidget {
  const MandalartDetailScreen({
    super.key,
    required this.mandalart,
  });

  final Mandalart mandalart;

  @override
  State<MandalartDetailScreen> createState() => _MandalartDetailScreenState();
}

class _MandalartDetailScreenState extends State<MandalartDetailScreen> {
  late final List<_GoalCell> _cells = List.generate(
    81,
    (_) => _GoalCell(text: '', status: GoalStatus.todo),
  );

  Future<void> _openCellEditor(int index) async {
    final cell = _cells[index];
    final textController = TextEditingController(text: cell.text);
    var selectedStatus = cell.status;

    final result = await showDialog<_GoalCell>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit goal'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: textController,
                decoration: const InputDecoration(labelText: 'Goal'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<GoalStatus>(
                value: selectedStatus,
                decoration: const InputDecoration(labelText: 'Status'),
                items: GoalStatus.values
                    .map(
                      (status) => DropdownMenuItem(
                        value: status,
                        child: Text(_statusLabel(status)),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    selectedStatus = value;
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  _GoalCell(
                    text: textController.text.trim(),
                    status: selectedStatus,
                  ),
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    textController.dispose();

    if (result == null) {
      return;
    }

    setState(() {
      _cells[index] = result;
    });
  }

  Color _statusColor(GoalStatus status) {
    switch (status) {
      case GoalStatus.todo:
        return Colors.grey.shade200;
      case GoalStatus.doing:
        return Colors.amber.shade100;
      case GoalStatus.done:
        return Colors.green.shade200;
    }
  }

  static String _statusLabel(GoalStatus status) {
    switch (status) {
      case GoalStatus.todo:
        return 'TODO';
      case GoalStatus.doing:
        return 'DOING';
      case GoalStatus.done:
        return 'DONE';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mandalart.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: AspectRatio(
          aspectRatio: 1,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 9,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
            ),
            itemCount: _cells.length,
            itemBuilder: (context, index) {
              final cell = _cells[index];
              return InkWell(
                onTap: () => _openCellEditor(index),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12),
                    color: _statusColor(cell.status),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    cell.text.isEmpty ? '${index + 1}' : cell.text,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
