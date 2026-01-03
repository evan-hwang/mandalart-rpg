import 'package:flutter/material.dart';
import 'package:mandalart/features/mandalart/mandalart.dart';

class MandalartDetailScreen extends StatelessWidget {
  const MandalartDetailScreen({
    super.key,
    required this.mandalart,
  });

  final Mandalart mandalart;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(mandalart.title),
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
            itemCount: 81,
            itemBuilder: (context, index) {
              return Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  color: Colors.white,
                ),
                child: Text(
                  '${index + 1}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
