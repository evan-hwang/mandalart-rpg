import 'package:flutter/material.dart';
import 'package:mandalart/data/db/app_database.dart';
import 'package:mandalart/data/goal_repository.dart';
import 'package:mandalart/features/mandalart/mandalart.dart';

enum GoalStatus { todo, doing, done }

class _GoalCell {
  _GoalCell({
    required this.text,
    required this.status,
    required this.memo,
  });

  String text;
  GoalStatus status;
  String memo;
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
  final GoalRepository _repository = GoalRepository(appDatabase);

  Future<void> _openCellEditor({
    required int index,
    required _GoalCell cell,
  }) async {
    final textController = TextEditingController(text: cell.text);
    final memoController = TextEditingController(text: cell.memo);
    var selectedStatus = cell.status;

    final result = await showDialog<_GoalCell>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('목표 편집'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: textController,
                decoration: const InputDecoration(labelText: '목표'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<GoalStatus>(
                value: selectedStatus,
                decoration: const InputDecoration(labelText: '상태'),
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
              const SizedBox(height: 12),
              TextField(
                controller: memoController,
                decoration: const InputDecoration(labelText: '회고'),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  _GoalCell(
                    text: textController.text.trim(),
                    status: selectedStatus,
                    memo: memoController.text.trim(),
                  ),
                );
              },
              child: const Text('저장'),
            ),
          ],
        );
      },
    );

    textController.dispose();
    memoController.dispose();

    if (result == null) {
      return;
    }

    await _repository.saveGoal(
      mandalartId: widget.mandalart.id,
      gridIndex: index,
      text: result.text,
      status: result.status.index,
      memo: result.memo,
    );
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
      body: StreamBuilder<List<GoalEntity>>(
        stream: _repository.watchGoals(widget.mandalart.id),
        builder: (context, snapshot) {
          final rows = snapshot.data ?? [];
          final cells = List.generate(
            81,
            (_) => _GoalCell(text: '', status: GoalStatus.todo, memo: ''),
          );

          for (final row in rows) {
            if (row.gridIndex >= 0 && row.gridIndex < cells.length) {
              cells[row.gridIndex] = _GoalCell(
                text: row.goalText,
                status: GoalStatus.values[row.status],
                memo: row.memo ?? '',
              );
            }
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: AspectRatio(
              aspectRatio: 1,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 9,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                ),
                itemCount: cells.length,
                itemBuilder: (context, index) {
                  final cell = cells[index];
                  return InkWell(
                    onTap: () => _openCellEditor(index: index, cell: cell),
                    onLongPress: () {
                      final nextStatus = GoalStatus
                          .values[(cell.status.index + 1) % GoalStatus.values.length];
                      _repository.saveGoal(
                        mandalartId: widget.mandalart.id,
                        gridIndex: index,
                        text: cell.text,
                        status: nextStatus.index,
                        memo: cell.memo,
                      );
                    },
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
          );
        },
      ),
    );
  }
}
