import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermoms/app/theme/app_colors.dart';
import 'package:supermoms/features/cartons/screens/carton_detail_screen.dart';
import 'package:supermoms/src/models/room.dart';
import 'package:supermoms/src/providers/carton_provider.dart';

class CartonListScreen extends StatelessWidget {
  const CartonListScreen({
    super.key,
    this.showBackButton = true,
  });

  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CartonProvider>();
    final cartons = provider.cartons;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: showBackButton,
        title: const Text('Tous les cartons',
            style:
                TextStyle(color: AppColors.textMain, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.textMain),
                onPressed: () => Navigator.pop(context),
              )
            : null,
      ),
      body: cartons.isEmpty
          ? const Center(child: Text("Aucun carton trouvé"))
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: cartons.length,
              itemBuilder: (context, index) {
                final box = cartons[index];
                return _buildCartonItem(
                  context,
                  box.name,
                  box.room,
                  box.items.length,
                  box.fragile,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CartonDetailScreen(box: box)),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildCartonItem(BuildContext context, String title, Room room,
      int itemsCount, bool isFragile, VoidCallback onTap) {
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
        subtitle: Text("${room.label} • $itemsCount ${itemsCount > 1 ? "objets" : "objet"}"),
        trailing: isFragile
            ? const Icon(Icons.warning_amber_rounded, color: AppColors.statsOrange)
            : const Icon(Icons.chevron_right),
      ),
    );
  }
}
