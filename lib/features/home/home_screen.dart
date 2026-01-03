import 'package:flutter/material.dart';
import 'package:mandalart/features/mandalart/mandalart.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Mandalart> _mandalarts = [
    const Mandalart(
      id: '2025',
      title: '2025 Mandalart',
      dateRangeLabel: '2025.01.01 - 2025.12.31',
    ),
    const Mandalart(
      id: '2024',
      title: '2024 Mandalart',
      dateRangeLabel: '2024.01.01 - 2024.12.31',
    ),
  ];

  Future<void> _openMandalartEditor({Mandalart? existing}) async {
    final titleController = TextEditingController(text: existing?.title ?? '');
    final rangeController = TextEditingController(
      text: existing?.dateRangeLabel ?? '',
    );

    final result = await showDialog<Mandalart>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(existing == null ? 'New Mandalart' : 'Edit Mandalart'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: rangeController,
                decoration: const InputDecoration(labelText: 'Date range'),
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
                final title = titleController.text.trim();
                final range = rangeController.text.trim();
                if (title.isEmpty) {
                  return;
                }
                Navigator.pop(
                  context,
                  Mandalart(
                    id: existing?.id ??
                        DateTime.now().millisecondsSinceEpoch.toString(),
                    title: title,
                    dateRangeLabel: range.isEmpty ? 'No date range' : range,
                  ),
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    titleController.dispose();
    rangeController.dispose();

    if (result == null) {
      return;
    }

    setState(() {
      final index = _mandalarts.indexWhere((item) => item.id == result.id);
      if (index >= 0) {
        _mandalarts[index] = result;
      } else {
        _mandalarts.insert(0, result);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mandalart'),
      ),
      body: _mandalarts.isEmpty
          ? const Center(child: Text('No Mandalart yet.'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _mandalarts.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final mandalart = _mandalarts[index];

                return Dismissible(
                  key: ValueKey(mandalart.id),
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.redAccent,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) {
                    setState(() {
                      _mandalarts.removeAt(index);
                    });
                  },
                  child: Card(
                    child: ListTile(
                      title: Text(mandalart.title),
                      subtitle: Text(mandalart.dateRangeLabel),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _openMandalartEditor(existing: mandalart),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openMandalartEditor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
