import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:supermoms/app/theme/app_colors.dart';
import 'package:supermoms/app/theme/app_text_styles.dart';
import 'package:supermoms/shared/widgets/gradient_header.dart';
import 'package:supermoms/src/models/carton.dart';
import 'package:supermoms/src/models/carton_item.dart';
import 'package:supermoms/src/providers/carton_provider.dart';

class CartonDetailScreen extends StatelessWidget {
  const CartonDetailScreen({required this.box, super.key});

  final Carton box;

  @override
  Widget build(BuildContext context) {
    final currentBox = context.watch<CartonProvider>().cartons.firstWhere((c) => c.id == box.id, orElse: () => box);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context, currentBox),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildWinkAnimation(
                          child: _buildActionButton('Étiquette PDF', Icons.download, const Color(0xFF27AE60)),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _buildWinkAnimation(
                          delayMs: 150,
                          child: _buildActionButton('Modifier', Icons.edit_note, const Color(0xFF7F56D9)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  _buildWinkAnimation(
                    delayMs: 300,
                    child: _buildDeleteButton(),
                  ),
                  const SizedBox(height: 25),
                  _buildInfoSection(currentBox),
                  const SizedBox(height: 25),
                  _buildContentSection(context, currentBox),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildAnimatedFAB(context, currentBox.id),
    );
  }

  Widget _buildHeader(BuildContext context, Carton box) => GradientHeader(
        height: 200,
        child: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(Icons.inventory_2, color: Colors.white, size: 30),
                  ),
                  const SizedBox(width: 15),
                  Text(box.name, style: AppTextStyles.headerTitle.copyWith(color: Colors.white, fontSize: 28)),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(box.room.label, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(width: 10),
                  if (box.fragile)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(8)),
                      child: const Row(
                        children: [
                          Icon(Icons.warning, color: Colors.white, size: 12),
                          SizedBox(width: 4),
                          Text('Fragile', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                ],
              )
            ],
          ),
        ),
      );

  Widget _buildActionButton(String label, IconData icon, Color color) => Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      );

  Widget _buildDeleteButton() => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFFFF5F6D), Color(0xFFFFC371)]),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete_outline, color: Colors.white),
            SizedBox(width: 8),
            Text('Supprimer le carton', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      );

  Widget _buildInfoSection(Carton box) => Container(
        decoration: _cardDecoration(),
        child: Column(
          children: [
            _buildSectionHeader('Informations', Icons.info_outline, const Color(0xFF4A90E2)),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildInfoRow('ID:', '${box.id.substring(0, 8)}...', isGrey: true),
                  const Divider(),
                  _buildInfoRow('Créé le:', DateFormat('dd MMMM yyyy', 'fr_FR').format(box.createdAt)),
                  const Divider(),
                  _buildInfoRow("Nombre d'objets:", box.items.length.toString(), isBoldValue: true, valueColor: Colors.green),
                ],
              ),
            )
          ],
        ),
      );

  Widget _buildContentSection(BuildContext context, Carton box) => Container(
        decoration: _cardDecoration(),
        child: Column(
          children: [
            _buildSectionHeader('Contenu du carton (${box.items.length})', Icons.inventory, const Color(0xFFF06292)),
            if (box.items.isEmpty)
              const Padding(padding: EdgeInsets.all(30), child: Text('Aucun objet', style: TextStyle(color: Colors.grey)))
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: box.items.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = box.items[index];
                  return ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: 50, height: 50,
                        color: Colors.grey.shade100,
                        child: const Icon(Icons.image_outlined, color: Colors.grey),
                      ),
                    ),
                    title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(item.description ?? 'Aucune description'),
                  );
                },
              ),
          ],
        ),
      );

  Widget _buildSectionHeader(String title, IconData icon, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [color, color.withValues(alpha: 0.7)]),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      );

  Widget _buildInfoRow(String label, String value, {bool isGrey = false, bool isBoldValue = false, Color? valueColor}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: isGrey ? BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)) : null,
              child: Text(value, style: TextStyle(
                fontWeight: isBoldValue ? FontWeight.bold : FontWeight.normal,
                color: valueColor ?? Colors.black87,
                fontSize: isGrey ? 12 : 14,
              )),
            ),
          ],
        ),
      );

  BoxDecoration _cardDecoration() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
      );

  Widget _buildWinkAnimation({required Widget child, int delayMs = 0}) => TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 1000),
        curve: Curves.elasticOut,
        builder: (context, value, child) {
          // Rotation de -0.1 radians (environ -5 degrés) vers 0
          final rotation = (1.0 - value) * -0.2;
          return Transform.rotate(
            angle: rotation,
            child: Transform.scale(
              scale: value,
              child: child,
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.only(top: delayMs / 50), // Petit hack pour décaler l'apparition
          child: child,
        ),
      );

  Widget _buildAnimatedFAB(BuildContext context, String cartonId) => _buildWinkAnimation(
        delayMs: 500,
        child: FloatingActionButton.extended(
          onPressed: () => _showAddItemDialog(context, cartonId),
          label: const Text('Ajouter un objet'),
          icon: const Icon(Icons.add),
          backgroundColor: AppColors.headerMid,
        ),
      );

  void _showAddItemDialog(BuildContext context, String cartonId) {
    final nameController = TextEditingController();
    final descController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nouvel objet'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Nom'), autofocus: true),
            TextField(controller: descController, decoration: const InputDecoration(labelText: 'Description')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('ANNULER')),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                final newItem = CartonItem(id: DateTime.now().toString(), cartonId: cartonId, name: nameController.text, description: descController.text);
                context.read<CartonProvider>().addItemToCarton(cartonId, newItem);
                Navigator.pop(context);
              }
            },
            child: const Text('AJOUTER'),
          ),
        ],
      ),
    );
  }
}
