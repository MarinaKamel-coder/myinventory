import 'package:flutter/material.dart';
import 'package:supermoms/app/theme/app_colors.dart';

class BoxCard extends StatelessWidget {
  const BoxCard({
    required this.title,
    required this.itemCount,
    required this.onTap,
    super.key,
  });

  final String title;
  final int itemCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Icon(
                Icons.inventory_2_outlined,
                color: AppColors.headerMid,
                size: 32,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      "Nombre d'objets : $itemCount",
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
