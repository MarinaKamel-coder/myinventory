// ignore_for_file: deprecated_member_use, prefer_expression_function_bodies

import 'package:flutter/material.dart';
<<<<<<< Updated upstream
import 'package:supermoms/app/theme/app_colors.dart';
import 'package:supermoms/features/cartons/widgets/box_card.dart';
=======
import 'package:supermoms/shared/theme/app_colors.dart';
import 'package:supermoms/shared/theme/app_text_styles.dart';
import 'package:supermoms/shared/widgets/gradient_header.dart';
import 'package:supermoms/src/Data/data.dart';
>>>>>>> Stashed changes

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
<<<<<<< Updated upstream
    final theme = Theme.of(context);
    
    return Scaffold(
      // Pas de AppBar pour laisser le Header personnalisé
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header simulé avec un dégradé (pour tester vos couleurs)
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
                  // Carte de test pour valider CardTheme
                  Card(
                    child: const ListTile(
                      leading: Icon(Icons.inventory_2, color: AppColors.headerMid),
                      title: Text('Cuisine - Fragile'),
                      subtitle: Text('12 objets'),
                      trailing: Icon(Icons.chevron_right),
                    ),
                  ),
                ],
              ),
=======
    // Le GestureDetector permet de détecter les clics en dehors de la barre de recherche
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              // 1. EN-TÊTE DÉGRADÉ (Hauteur de 300px pour éviter l'overflow)
              GradientHeader(
                height: 300,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('MyInventory', style: AppTextStyles.titleHeader),
                        const Text(
                          'Votre déménagement organisé',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                        const SizedBox(height: 25),
                        _buildProgressSection(),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 2. BARRE DE RECHERCHE
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Rechercher un carton ou un objet...',
                    prefixIcon: const Icon(Icons.search, color: AppColors.textGrey),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
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
                        const Color(0xFF42A5F5),
                        Icons.inventory_2_outlined,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _buildStatCard(
                        '${MockData.boxes.where((b) => b.fragile).length}',
                        'FRAGILES',
                        const Color(0xFFFF5252),
                        Icons.warning_amber_rounded,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // 4. LISTE DES CARTONS (Dynamique via MockData)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Derniers cartons', style: AppTextStyles.cardTitle),
                    TextButton(onPressed: () {}, child: const Text('Voir tout')),
                  ],
                ),
              ),

              // On boucle sur les cartons définis dans data.dart
              ...MockData.boxes.map((box) => _buildCartonItem(
                  box.name,
                  box.room.label,
                  box.items.length,
                  box.fragile 
              )),

              const SizedBox(height: 120), // Espace pour les boutons flottants
            ],
          ),
        ),

        // 5. DOUBLE BOUTON FLOTTANT (SCAN AU-DESSUS DE AJOUT)
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: 'scan_fab',
              onPressed: () => Navigator.pushNamed(context, '/scanner'),
              backgroundColor: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: const Icon(Icons.qr_code_scanner, color: AppColors.primaryStart, size: 28),
            ),

            const SizedBox(height: 15),

            FloatingActionButton.large(
              heroTag: 'add_fab',
              onPressed: () => Navigator.pushNamed(context, '/add_carton'),
              backgroundColor: AppColors.primaryStart,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: const Icon(Icons.add, color: Colors.white, size: 40),
>>>>>>> Stashed changes
            ),
          ],
        ),
      ),
<<<<<<< Updated upstream
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
=======
>>>>>>> Stashed changes
    );
  }

  // --- WIDGETS INTERNES ---

  Widget _buildProgressSection() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Progression', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Text('${MockData.boxes.length} cartons', style: const TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: const LinearProgressIndicator(
              value: 0.3,
              backgroundColor: Colors.white24,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.greenAccent),
              minHeight: 8,
            ),
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
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 30),
          const SizedBox(height: 10),
          Text(value, style: AppTextStyles.statsNumber),
          Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildCartonItem(String title, String roomLabel, int itemsCount, bool isFragile) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: AppColors.mainGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.inventory_2, color: Colors.white),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.cardTitle),
                Row(
                  children: [
                    Text(roomLabel, style: AppTextStyles.bodySmall),
                    const SizedBox(width: 8),
                    if (isFragile)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(6)),
                        child: const Text('⚠️ FRAGILE', style: TextStyle(color: Colors.red, fontSize: 9, fontWeight: FontWeight.bold)),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}