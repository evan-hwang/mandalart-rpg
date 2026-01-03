import 'package:flutter/material.dart';
import 'package:mandalart/data/db/app_database.dart';
import 'package:mandalart/data/mandalart_repository.dart';
import 'package:mandalart/features/mandalart/mandalart.dart';
import 'package:mandalart/features/mandalart/mandalart_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MandalartRepository _repository = MandalartRepository(appDatabase);

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

    await _repository.saveMandalart(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mandalart'),
      ),
      body: StreamBuilder<List<Mandalart>>(
        stream: _repository.watchMandalarts(),
        builder: (context, snapshot) {
          final mandalarts = snapshot.data ?? [];
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (mandalarts.isEmpty) {
            return const Center(child: Text('No Mandalart yet.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: mandalarts.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final mandalart = mandalarts[index];

              return Dismissible(
                key: ValueKey(mandalart.id),
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  color: Colors.redAccent,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) {
                  _repository.deleteMandalart(mandalart.id);
                },
                child: Card(
                  child: ListTile(
                    title: Text(mandalart.title),
                    subtitle: Text(mandalart.dateRangeLabel),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              MandalartDetailScreen(mandalart: mandalart),
                        ),
                      );
                    },
                    onLongPress: () =>
                        _openMandalartEditor(existing: mandalart),
                  ),
                ),
              );
            },
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
