import 'package:flutter/material.dart';
import 'package:supermoms/app/theme/app_colors.dart';

class HomeEmptyState extends StatelessWidget {
  final VoidCallback onAddPressed;

  const HomeEmptyState({
    super.key,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 1. Une icône ou une image illustrative
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.bgMid,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.inventory_2_outlined,
                size: 80,
                color: AppColors.headerMid,
              ),
            ),
            const SizedBox(height: 32),

            // 2. Message clair (AC)
            Text(
              'Aucun carton pour le moment',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Text(
              'Commencez par ajouter votre premier carton pour organiser votre déménagement.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),

            // 3. CTA "Ajouter" (AC)
            ElevatedButton.icon(
              onPressed: onAddPressed,
              icon: const Icon(Icons.add),
              label: const Text('Ajouter un carton'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.fabMid,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
