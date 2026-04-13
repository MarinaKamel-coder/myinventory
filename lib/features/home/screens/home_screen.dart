// ignore_for_file: deprecated_member_use, prefer_expression_function_bodies

import 'package:flutter/material.dart';
import 'package:supermoms/app/theme/app_colors.dart';
import 'package:supermoms/app/theme/app_text_styles.dart';
import 'package:supermoms/features/cartons/screens/carton_detail_screen.dart';
import 'package:supermoms/shared/widgets/gradient_header.dart';
import 'package:supermoms/src/Data/data.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Utilisation du thème global pour les textes
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        // Utilise la couleur de fond définie dans AppTheme
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              // 1. EN-TÊTE AVEC TON NOUVEAU DÉGRADÉ (headerStart -> headerMid -> headerEnd)
              GradientHeader(
                height: 300,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('MyInventory', style: theme.textTheme.displayLarge),
                        Text(
                          'Votre déménagement organisé',
                          style: theme.textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 25),
                        _buildProgressSection(),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 2. BARRE DE RECHERCHE (Stylisée via InputDecorationTheme)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Rechercher un carton ou un objet...',
                    prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 3. CARTES DE STATISTIQUES
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        '${MockData.boxes.length}',
                        'CARTONS',
                        AppColors.statsBlue,
                        Icons.inventory_2_outlined,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _buildStatCard(
                        '${MockData.boxes.where((b) => b.fragile).length}',
                        'FRAGILES',
                        AppColors.statsOrange,
                        Icons.warning_amber_rounded,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // 4. LISTE DYNAMIQUE DES CARTONS
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Derniers cartons', style: theme.textTheme.titleLarge),
                    TextButton(onPressed: () {}, child: const Text('Voir tout')),
                  ],
                ),
              ),

              ...MockData.boxes.map((box) => _buildCartonItem(
                    box.name,
                    box.room.label,
                    box.items.length,
                    box.fragile,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (context) => CartonDetailScreen(box: box),
                        ),
                      );
                    },
                  )),

              const SizedBox(height: 120),
            ],
          ),
        ),

        // 5. BOUTONS FLOTTANTS
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: 'scan_fab',
              onPressed: () => Navigator.pushNamed(context, '/scanner'),
              backgroundColor: AppColors.white,
              child: const Icon(Icons.qr_code_scanner, color: AppColors.headerMid),
            ),
            const SizedBox(height: 15),
            FloatingActionButton.large(
              heroTag: 'add_fab',
              onPressed: () => Navigator.pushNamed(context, '/add_carton'),
              child: const Icon(Icons.add, size: 40),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS DE CONSTRUCTION ---

  Widget _buildProgressSection() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Progression', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
              Text('${MockData.boxes.length} cartons', style: const TextStyle(color: AppColors.white, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 10),
          const LinearProgressIndicator(
            value: 0.3,
            backgroundColor: Colors.white24,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.success),
            minHeight: 8,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.white, size: 30),
          const SizedBox(height: 10),
          Text(value, style: AppTextStyles.statsNumber),
          Text(label, style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildCartonItem(String title, String roomLabel, int itemsCount, bool isFragile, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: AppColors.mainGradient,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.inventory_2, color: AppColors.white),
        ),
        title: Text(title),
        subtitle: Text(roomLabel),
        trailing: isFragile 
          ? const Icon(Icons.warning_amber_rounded, color: AppColors.statsOrange)
          : const Icon(Icons.chevron_right),
      ),
    );
  }
}