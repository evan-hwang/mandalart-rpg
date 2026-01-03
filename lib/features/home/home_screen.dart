import 'package:flutter/material.dart';
import 'package:mandalart/features/mandalart/mandalart_store.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mandalarts = const MandalartStore().loadMandalarts();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mandalart'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: mandalarts.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final mandalart = mandalarts[index];

          return Card(
            child: ListTile(
              title: Text(mandalart.title),
              subtitle: Text(mandalart.dateRangeLabel),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}
