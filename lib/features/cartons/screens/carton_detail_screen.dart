import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermoms/features/items/widgets/item_tile.dart';
import 'package:supermoms/src/models/carton.dart';
import 'package:supermoms/src/models/carton_item.dart';
import 'package:supermoms/src/provider/carton_provider.dart';

class CartonDetailScreen extends StatelessWidget {
  const CartonDetailScreen({required this.box, super.key});

  final Carton box;

  @override
  Widget build(BuildContext context) {
    // 1. On écoute le Provider pour avoir la version à jour du carton (avec ses objets)
    final updatedBox = context.watch<CartonProvider>().cartons.firstWhere(
          (c) => c.id == box.id,
          orElse: () => box,
        );

    return Scaffold(
      appBar: AppBar(
        title: Text(updatedBox.name),
      ),
      // 2. Le bouton (+) pour ajouter un objet
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddItemDialog(context, updatedBox.id),
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: updatedBox.items.length,
        itemBuilder: (context, index) {
          final item = updatedBox.items[index];
          return ItemTile(
            title: item.name,
            subtitle: item.description,
            imageUrl: item.photo,
          );
        },
      ),
    );
  }

  // 3. Fenêtre pour saisir le nom de l'objet
  void _showAddItemDialog(BuildContext context, String cartonId) {
    final controller = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter un objet'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Nom de l'objet"),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                // APPEL DE TA MÉTHODE addItemToCarton DU PROVIDER
                context.read<CartonProvider>().addItemToCarton(
                      cartonId,
                      CartonItem(
                        id: DateTime.now().toString(),
                        cartonId: cartonId,
                        name: controller.text,
                      ),
                    );
                Navigator.pop(context);
              }
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }
}
