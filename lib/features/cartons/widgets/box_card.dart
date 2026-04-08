import 'package:flutter/material.dart';

class BoxCard extends StatelessWidget {
  final String title;
  final int itemCount;
  final VoidCallback onTap;

  const BoxCard({
    super.key,
    required this.title,
    required this.itemCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20), // Pour arrondir l'effet de clic
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.titleLarge),
              const SizedBox(height: 8.0),
              Text(
                'Nombre d\'objets : $itemCount',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
