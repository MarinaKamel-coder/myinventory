import 'package:flutter/material.dart';
import 'package:supermoms/features/items/widgets/item_tile.dart';
import 'package:supermoms/src/models/carton.dart';

class CartonDetailScreen extends StatelessWidget {
  const CartonDetailScreen({required this.box, super.key});

  final Carton box;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(box.name),
        ),
        body: ListView.builder(
          itemCount: box.items.length,
          itemBuilder: (context, index) {
            final item = box.items[index];
            return ItemTile(
              title: item.name,
              subtitle: item.description,
              imageUrl: item.photo,
            );
          },
        ),
      );
}
