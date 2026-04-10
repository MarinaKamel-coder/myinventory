import 'package:flutter/material.dart';
import 'package:supermoms/features/items/widgets/item_tile.dart';

class CartonDetailScreen extends StatelessWidget {
  const CartonDetailScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Détails du carton'),
        ),
        body: ListView(
          children: const [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Objets dans ce carton :',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            // TEST 1: Avec Image et Sous-titre
            ItemTile(
              title: 'Assiettes blanches',
              subtitle: 'Service de table complet',
              imageUrl:
                  'https://images.unsplash.com/photo-1574169208507-84376144848b?q=80&w=200&auto=format&fit=crop',
            ),
            // TEST 2: Avec Quantité (Dégradé)
            ItemTile(
              title: 'Tasses à café',
              quantity: 3,
            ),
            // TEST 3: Avec Quantité et Sous-titre
            ItemTile(
              title: 'Couverts',
              subtitle: 'Service inox',
              quantity: 4,
            ),
          ],
        ),
      );
}
