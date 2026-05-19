// ignore_for_file: prefer_expression_function_bodies
import 'dart:async' show unawaited;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermoms/app/theme/app_colors.dart';
import 'package:supermoms/app/theme/app_text_styles.dart';
import 'package:supermoms/features/navigation/screens/main_navigation_screen.dart'; // Import crucial pour la navigation
import 'package:supermoms/shared/widgets/gradient_header.dart';
import 'package:supermoms/src/models/room.dart';
import 'package:supermoms/src/models/carton.dart';
import 'package:supermoms/src/providers/auth_provider.dart';
import 'package:supermoms/src/providers/carton_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      unawaited(_loadInitialData());
    });
  }

  /// Chargement sécurisé des données depuis SQLite
  Future<void> _loadInitialData() async {
    try {
      await context.read<CartonProvider>().loadCartons();
    } catch (e) {
      debugPrint("Erreur lors du chargement SQLite : $e");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Calcule le total des objets (quantités cumulées) pour un carton donné
  int _getTotalItemsInBox(Carton box) {
    return box.items.fold(0, (sum, item) => sum + (item.quantity ?? 1));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.watch<CartonProvider>();
    final cartons = provider.cartons;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: RefreshIndicator(
          onRefresh: () => provider.loadCartons(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                _buildHeader(context, theme),
                const SizedBox(height: 20),

                // --- BARRE DE RECHERCHE ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextField(
                    onChanged: (value) => provider.setSearchQuery(value),
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

                // --- CARTES DE STATISTIQUES ---
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

                // --- SECTION DERNIERS CARTONS ---
                _buildRecentSection(context, theme, provider, cartons),

                const SizedBox(height: 120),
              ],
            ),
          ),
        ),
        floatingActionButton: _buildFABs(context),
      ),
    );
  }

  Widget _buildRecentSection(
    BuildContext context,
    ThemeData theme,
    CartonProvider provider,
    List<Carton> cartons,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Derniers cartons', style: theme.textTheme.titleLarge),
              TextButton(
                // Optionnel : Basculer vers l'onglet cartons (index 1) au lieu de pushNamed
                onPressed: () =>
                    MainNavigationScreen.of(context)?.setState(() {}),
                child: const Text('Voir tout'),
              ),
            ],
          ),
        ),
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.all(40.0),
            child: CircularProgressIndicator(),
          )
        else if (cartons.isEmpty)
          const Padding(
            padding: EdgeInsets.all(40.0),
            child: Text("Aucun carton trouvé"),
          )
        else
          ...cartons.take(5).map((Carton box) {
            String? foundItem;
            if (provider.searchQuery.isNotEmpty) {
              final match = box.items.where(
                (item) => item.name.toLowerCase().contains(
                  provider.searchQuery.toLowerCase(),
                ),
              );
              if (match.isNotEmpty) foundItem = match.first.name;
            }
            return _buildCartonItem(
              box.name,
              box.room,
              _getTotalItemsInBox(box),
              box.fragile,
              // CORRECTION ICI : Utilisation de la navigation globale pour garder la navbar
              () =>
                  MainNavigationScreen.of(context)?.navigateToCartonDetail(box),
              subtitleAddition: foundItem != null
                  ? 'Contient : $foundItem'
                  : null,
            );
          }),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme) {
    return GradientHeader(
      height: 250,
      child: Stack(
        children: [
          Positioned(
            top: 40,
            right: 10,
            child: IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () => _showLogoutDialog(context),
            ),
          ),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.inventory,
                              size: 40,
                              color: AppColors.headerMid,
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'MyINVENTORY',
                    style: theme.textTheme.displayLarge?.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Votre déménagement organisé',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFABs(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          heroTag: 'scan_fab',
          onPressed: () => Navigator.pushNamed(context, '/scanner'),
          backgroundColor: Colors.white,
          child: const Icon(Icons.qr_code_scanner, color: AppColors.headerMid),
        ),
        const SizedBox(height: 15),
        FloatingActionButton.large(
          heroTag: 'add_fab',
          onPressed: () => Navigator.pushNamed(context, '/add_carton'),
          child: const Icon(Icons.add, size: 40),
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Déconnexion"),
        content: const Text("Voulez-vous vraiment vous déconnecter ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          TextButton(
            onPressed: () async {
              await context.read<AuthProvider>().signOut();
              if (!mounted) return;
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/', (route) => false);
            },
            child: const Text(
              "Déconnexion",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

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
          Icon(icon, color: Colors.white, size: 30),
          const SizedBox(height: 10),
          Text(value, style: AppTextStyles.statsNumber),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
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
    Room room,
    int itemsCount,
    bool isFragile,
    VoidCallback onTap, {
    String? subtitleAddition,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: AppColors.mainGradient,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(room.icon, style: const TextStyle(fontSize: 24)),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${room.label} • $itemsCount ${itemsCount > 1 ? 'objets' : 'objet'}',
            ),
            if (subtitleAddition != null)
              Text(
                subtitleAddition,
                style: const TextStyle(
                  color: AppColors.statsBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
          ],
        ),
        trailing: isFragile
            ? const Icon(
                Icons.warning_amber_rounded,
                color: AppColors.statsOrange,
              )
            : const Icon(Icons.chevron_right),
      ),
    );
  }
}
