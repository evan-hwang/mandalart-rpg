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

enum _CellRole {
  main,
  core,
  coreMirror,
  sub,
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
    required _CellRole role,
  }) async {
    final textController = TextEditingController(text: cell.text);
    final memoController = TextEditingController(text: cell.memo);
    var selectedStatus = cell.status;

    final result = await showDialog<_GoalCell>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(_editorTitle(role)),
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

    final pairedIndex = _pairedCoreIndex(index, role);
    if (pairedIndex != null) {
      await _repository.saveGoal(
        mandalartId: widget.mandalart.id,
        gridIndex: pairedIndex,
        text: result.text,
        status: result.status.index,
        memo: result.memo,
      );
    }
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
        return '할 일';
      case GoalStatus.doing:
        return '진행 중';
      case GoalStatus.done:
        return '완료';
    }
  }

  static String _editorTitle(_CellRole role) {
    switch (role) {
      case _CellRole.main:
        return '중앙 목표';
      case _CellRole.core:
      case _CellRole.coreMirror:
        return '핵심 목표';
      case _CellRole.sub:
        return '세부 목표';
    }
  }

  static _CellRole _roleForIndex(int index) {
    final row = index ~/ 9;
    final col = index % 9;
    final blockRow = row ~/ 3;
    final blockCol = col ~/ 3;
    final inCenterBlock = blockRow == 1 && blockCol == 1;
    final isBlockCenter = row % 3 == 1 && col % 3 == 1;

    if (inCenterBlock && row == 4 && col == 4) {
      return _CellRole.main;
    }
    if (inCenterBlock) {
      return _CellRole.core;
    }
    if (isBlockCenter) {
      return _CellRole.coreMirror;
    }
    return _CellRole.sub;
  }

  static int? _pairedCoreIndex(int index, _CellRole role) {
    if (role != _CellRole.core && role != _CellRole.coreMirror) {
      return null;
    }
    final row = index ~/ 9;
    final col = index % 9;
    final blockRow = row ~/ 3;
    final blockCol = col ~/ 3;

    if (role == _CellRole.core) {
      final targetRow = blockRow * 3 + 1;
      final targetCol = blockCol * 3 + 1;
      return targetRow * 9 + targetCol;
    }

    final targetRow = 3 + blockRow;
    final targetCol = 3 + blockCol;
    return targetRow * 9 + targetCol;
  }

  static _GoalCell _emptyCell() {
    return _GoalCell(text: '', status: GoalStatus.todo, memo: '');
  }

  static _GoalCell _mergeCoreCells(_GoalCell primary, _GoalCell secondary) {
    if (primary.text.isNotEmpty || primary.memo.isNotEmpty) {
      return primary;
    }
    return secondary;
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
          final cells = List.generate(81, (_) => _emptyCell());
          final cellsByIndex = <int, _GoalCell>{};

          for (final row in rows) {
            if (row.gridIndex >= 0 && row.gridIndex < cells.length) {
              final cell = _GoalCell(
                text: row.goalText,
                status: GoalStatus.values[row.status],
                memo: row.memo ?? '',
              );
              cells[row.gridIndex] = cell;
              cellsByIndex[row.gridIndex] = cell;
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
                  final role = _roleForIndex(index);
                  var cell = cells[index];
                  final pairedIndex = _pairedCoreIndex(index, role);
                  if (pairedIndex != null) {
                    cell = _mergeCoreCells(
                      cell,
                      cellsByIndex[pairedIndex] ?? _emptyCell(),
                    );
                  }

                  return InkWell(
                    onTap: () => _openCellEditor(
                      index: index,
                      cell: cell,
                      role: role,
                    ),
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
                      if (pairedIndex != null) {
                        _repository.saveGoal(
                          mandalartId: widget.mandalart.id,
                          gridIndex: pairedIndex,
                          text: cell.text,
                          status: nextStatus.index,
                          memo: cell.memo,
                        );
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black12,
                          width: _borderWidth(index),
                        ),
                        color: _cellBackground(role, cell.status),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Text(
                        cell.text.isEmpty ? '${index + 1}' : cell.text,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(fontWeight: _cellWeight(role)),
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

  double _borderWidth(int index) {
    final row = index ~/ 9;
    final col = index % 9;
    final thickRow = row == 2 || row == 5;
    final thickCol = col == 2 || col == 5;
    if (thickRow || thickCol) {
      return 1.8;
    }
    return 0.6;
  }

  Color _cellBackground(_CellRole role, GoalStatus status) {
    final base = _statusColor(status);
    switch (role) {
      case _CellRole.main:
        return Colors.blueGrey.shade100;
      case _CellRole.core:
      case _CellRole.coreMirror:
        return Colors.blueGrey.shade50.withAlpha(230);
      case _CellRole.sub:
        return base;
    }
  }

  FontWeight _cellWeight(_CellRole role) {
    switch (role) {
      case _CellRole.main:
        return FontWeight.w700;
      case _CellRole.core:
      case _CellRole.coreMirror:
        return FontWeight.w600;
      case _CellRole.sub:
        return FontWeight.w400;
    }
  }
}
