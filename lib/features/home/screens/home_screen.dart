// ignore_for_file: deprecated_member_use, prefer_expression_function_bodies

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermoms/app/theme/app_colors.dart';
import 'package:supermoms/app/theme/app_text_styles.dart';
import 'package:supermoms/features/cartons/screens/carton_detail_screen.dart';
import 'package:supermoms/shared/widgets/gradient_header.dart';
import 'package:supermoms/src/providers/carton_provider.dart';

class HomeScreen extends  StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  @override
  void initState() {
    super.initState();

  // 🔥 Charger les cartons depuis SQLite
    Future.microtask(() {
      context.read<CartonProvider>().loadCartons();
  });
}



  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // On écoute le Provider pour avoir les données réelles (pas les mocks)
    final cartonProvider = context.watch<CartonProvider>();

    //final provider = context.watch<CartonProvider>();
    final cartons = cartonProvider.cartons; // Utilise le getter qui applique la recherche et les filtres

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              GradientHeader(
                height: 200, 
                child: Stack(
                  children: [
                    Positioned(
                      top: -30,
                      left: -40,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.05),
                        ),
                      ),
                    ),
                    
                    SafeArea(
                      child: Center( 
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // --- 1. LOGO  ---
                              Image.asset(
                                'assets/images/logo.png',
                                height: 80, // Un peu plus grand puisqu'il n'y a plus de bordure
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(height: 12), 

                              // --- 2. TITRE MyINVENTORY ---
                              Text(
                                'MyINVENTORY',
                                style: theme.textTheme.displayLarge?.copyWith(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.0,
                                  color: Colors.white,
                                ),
                              ),

                              const SizedBox(height: 4), 

                              // --- 3. SOUS-TITRE ---
                              Text(
                                'Votre déménagement organisé',
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          
              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  onChanged: (value) {
                    context.read<CartonProvider>().setSearchQuery(value);
                  },
                  decoration: const InputDecoration(
                    hintText: 'Rechercher un carton ou un objet...',
                    prefixIcon: Icon(
                      Icons.search,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // CARTES DE STATISTIQUES
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        '${cartons.length}',
                        'CARTONS',
                        AppColors.statsBlue,
                        Icons.inventory_2_outlined,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _buildStatCard(
                        '${cartons.where((b) => b.fragile).length}',
                        'FRAGILES',
                        AppColors.statsOrange,
                        Icons.warning_amber_rounded,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Derniers cartons', style: theme.textTheme.titleLarge),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Voir tout'),
                    ),
                  ],
                ),
              ),

              // LISTE DES CARTONS AVEC LOGIQUE DE RECHERCHE D'OBJETS
              ...cartons.map((box) {
                String? foundItem;
                if (cartonProvider.searchQuery.isNotEmpty) {
                  final match = box.items.where((item) => 
                    item.name.toLowerCase().contains(cartonProvider.searchQuery.toLowerCase())
                  );
                  if (match.isNotEmpty) {
                    foundItem = match.first.name;
                  }
                }

                return _buildCartonItem(
                  box.name,
                  box.room.label,
                  box.items.length,
                  box.fragile,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CartonDetailScreen(box: box)),
                    );
                  },
                  subtitleAddition: foundItem != null ? 'Contient : $foundItem' : null,
                );
              }),

              const SizedBox(height: 120),
            ],
          ),
        ),

        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // --- BOUTON SCAN AVEC ANIMATION ÉLASTIQUE ---
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 1000),
              curve: const Interval(0.2, 1.0, curve: Curves.elasticOut),
              builder: (context, value, child) => Transform.scale(
                scale: value,
                child: FloatingActionButton(
                  heroTag: 'scan_fab',
                  onPressed: () => Navigator.pushNamed(context, '/scanner'),
                  backgroundColor: AppColors.white,
                  child: const Icon(
                    Icons.qr_code_scanner,
                    color: AppColors.headerMid,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),

            // --- BOUTON + AVEC ANIMATION ÉLASTIQUE ---
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 800),
              curve: Curves.elasticOut,
              builder: (context, value, child) => Transform.scale(
                scale: value,
                child: FloatingActionButton.large(
                  heroTag: 'add_fab',
                  onPressed: () => Navigator.pushNamed(context, '/add_carton'),
                  child: const Icon(Icons.add, size: 40),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS DE CONSTRUCTION ---

  Widget _buildStatCard(
    String value,
    String label,
    Color color,
    IconData icon,
  ) {
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
          Text(
            label,
            style: const TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartonItem(
    String title, 
    String roomLabel, 
    int itemsCount, 
    bool isFragile, 
    VoidCallback onTap,
    {String? subtitleAddition}
  ) {
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
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(roomLabel),
            if (subtitleAddition != null)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  subtitleAddition,
                  style: const TextStyle(
                    color: AppColors.statsBlue, 
                    fontWeight: FontWeight.bold,
                    fontSize: 12
                  ),
                ),
              ),
          ],
        ),
        trailing: isFragile 
          ? const Icon(Icons.warning_amber_rounded, color: AppColors.statsOrange)
          : const Icon(Icons.chevron_right),
      ),
    );
  }
}