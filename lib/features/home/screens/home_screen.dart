
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermoms/app/theme/app_colors.dart';
import 'package:supermoms/app/theme/app_text_styles.dart';
import 'package:supermoms/features/cartons/screens/carton_detail_screen.dart';
import 'package:supermoms/shared/widgets/gradient_header.dart';
import 'package:supermoms/src/models/room.dart';
import 'package:supermoms/src/providers/auth_provider.dart';
import 'package:supermoms/src/providers/carton_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    // 🔥 Chargement sécurisé des données SQLite
    Future.microtask(() async {
      try {
        await context.read<CartonProvider>().loadCartons();
      } catch (e) {
        debugPrint("Erreur lors du chargement SQLite : $e");
      }
    });
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              GradientHeader(
                height: 250,
                child: Stack(
                  children: [
                    Positioned(
                      top: 40,
                      right: 10,
                      child: IconButton(
                        icon: const Icon(Icons.logout, color: Colors.white),
                        onPressed: () async {
                          await context.read<AuthProvider>().signOut();
                          if (!mounted) return;
                          Navigator.of(context)
                              .pushNamedAndRemoveUntil('/', (route) => false);
                        },
                      ),
                    ),
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
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // --- LOGO AVEC SÉCURITÉ ---
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
                                        const Icon(Icons.inventory,
                                            size: 40, color: AppColors.headerMid),
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
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  onChanged: (value) => provider.setSearchQuery(value),
                  decoration: const InputDecoration(
                    hintText: 'Rechercher un carton ou un objet...',
                    prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
                  ),
                ),
              ),
              const SizedBox(height: 20),
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
                      onPressed: () => Navigator.pushNamed(context, '/all_cartons'),
                      child: const Text('Voir tout'),
                    ),
                  ],
                ),
              ),
              if (cartons.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(40.0),
                  child: Text("Aucun carton trouvé"),
                )
              else
                ...cartons.take(5).map((box) {
                  String? foundItem;
                  if (provider.searchQuery.isNotEmpty) {
                    final match = box.items.where((item) => item.name
                        .toLowerCase()
                        .contains(provider.searchQuery.toLowerCase()));
                    if (match.isNotEmpty) foundItem = match.first.name;
                  }
                  return _buildCartonItem(
                    box.name,
                    box.room,
                    box.items.length,
                    box.fragile,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CartonDetailScreen(box: box)),
                    ),
                    subtitleAddition:
                        foundItem != null ? 'Contient : $foundItem' : null,
                  );
                }),
              const SizedBox(height: 120),
            ],
          ),
        ),
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
          Text(label,
              style: const TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildCartonItem(
      String title, Room room, int itemsCount, bool isFragile, VoidCallback onTap,
      {String? subtitleAddition}) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              gradient: AppColors.mainGradient,
              borderRadius: BorderRadius.circular(12)),
          child: Text(room.icon, style: const TextStyle(fontSize: 24)),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${room.label} • $itemsCount ${itemsCount > 1 ? 'objets' : 'objet'}'),
            if (subtitleAddition != null)
              Text(subtitleAddition,
                  style: const TextStyle(
                      color: AppColors.statsBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 12)),
          ],
        ),
        trailing: isFragile
            ? const Icon(Icons.warning_amber_rounded, color: AppColors.statsOrange)
            : const Icon(Icons.chevron_right),
      ),
    );
  }
}
