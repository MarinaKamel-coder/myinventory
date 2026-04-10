import 'package:flutter/material.dart';
import 'package:supermoms/app/theme/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 80, bottom: 40, left: 24, right: 24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.headerStart, AppColors.headerEnd],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Bonjour !', style: theme.textTheme.displayLarge),
                  const SizedBox(height: 8),
                  Text('Prêt pour le déménagement ?', style: theme.textTheme.headlineMedium),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Mes Cartons récents', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 16),
                  const Card(
                    child: ListTile(
                      leading: Icon(Icons.inventory_2, color: AppColors.headerMid),
                      title: Text('Cuisine - Fragile'),
                      subtitle: Text('12 objets'),
                      trailing: Icon(Icons.chevron_right),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
