import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:supermoms/app/theme/app_colors.dart';
import 'package:supermoms/app/theme/app_text_styles.dart';
import 'package:supermoms/features/items/widgets/item_tile.dart';
import 'package:supermoms/shared/utils/local_photo_storage.dart';
import 'package:supermoms/shared/utils/photo_image_provider.dart';
import 'package:supermoms/shared/widgets/gradient_header.dart';
import 'package:supermoms/src/models/carton.dart';
import 'package:supermoms/src/models/carton_item.dart';
import 'package:supermoms/src/providers/carton_provider.dart';
import 'package:supermoms/src/providers/item_provider.dart';

class CartonDetailScreen extends StatefulWidget {
  const CartonDetailScreen({required this.box, super.key});

  final Carton box;

  @override
  State<CartonDetailScreen> createState() => _CartonDetailScreenState();
}

class _CartonDetailScreenState extends State<CartonDetailScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Helper pour le design des champs Input
  InputDecoration _dialogInputStyle(String label, IconData icon) => InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.headerMid.withOpacity(0.7)),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
      );

  // --- ACTIONS SUR LE CARTON ---

  void _showDeleteCartonConfirmation(BuildContext context, String cartonId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Supprimer ce carton ?'),
        content: const Text('Cela supprimera définitivement le carton et tout son contenu.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('ANNULER')),
          TextButton(
            onPressed: () {
              context.read<ItemProvider>().removeAllItemsOfCarton(cartonId);
              context.read<CartonProvider>().deleteCarton(cartonId);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('SUPPRIMER', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showEditCartonDialog(BuildContext context, Carton box) {
    final nameController = TextEditingController(text: box.name);
    bool isFragile = box.fragile;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Modifier le carton'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: _dialogInputStyle('Nom du carton', Icons.inventory_2),
              ),
              const SizedBox(height: 10),
              SwitchListTile(
                title: const Text('Marquer comme fragile'),
                secondary: const Icon(Icons.warning_amber_rounded, color: Colors.orange),
                value: isFragile,
                activeColor: Colors.orange,
                onChanged: (val) => setModalState(() => isFragile = val),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('ANNULER')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.headerMid,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  context.read<CartonProvider>().updateCarton(box.id, nameController.text, isFragile);
                  Navigator.pop(context);
                }
              },
              child: const Text('ENREGISTRER'),
            ),
          ],
        ),
      ),
    );
  }

  // --- ACTIONS SUR LES ITEMS (AJOUT & MODIFICATION) ---

  void _showItemForm(BuildContext context, {CartonItem? item, required String cartonId}) {
    final isEditing = item != null;
    final nameController = TextEditingController(text: item?.name ?? '');
    final descController = TextEditingController(text: item?.description ?? '');
    String? photoPath = item?.photo;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          title: Text(isEditing ? 'Modifier l\'objet' : 'Nouvel objet'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDialogPhotoSelector(
                  photoPath,
                  onTap: () async {
                    final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 85);
                    if (picked != null) {
                      final storedPath = await persistPickedPhoto(picked);
                      setModalState(() => photoPath = storedPath);
                    }
                  },
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: nameController,
                  decoration: _dialogInputStyle('Nom de l\'objet', Icons.tag),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: descController,
                  maxLines: 2,
                  decoration: _dialogInputStyle('Description (facultatif)', Icons.notes),
                ),
              ],
            ),
          ),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          actions: [
            if (isEditing)
              TextButton(
                onPressed: () {
                  context.read<ItemProvider>().removeItem(item.id);
                  Navigator.pop(context);
                },
                child: const Text('SUPPRIMER', style: TextStyle(color: Colors.red)),
              ),
            const Spacer(),
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('ANNULER')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.headerMid,
                foregroundColor: Colors.white, // Texte forcé en blanc
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                minimumSize: const Size(110, 45),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  final newItem = CartonItem(
                    id: isEditing ? item.id : DateTime.now().toIso8601String(),
                    cartonId: cartonId,
                    name: nameController.text,
                    description: descController.text,
                    photo: photoPath,
                  );
                  isEditing 
                    ? context.read<ItemProvider>().updateItem(newItem) 
                    : context.read<ItemProvider>().addItem(newItem);
                  Navigator.pop(context);
                }
              },
              child: Text(isEditing ? 'ENREGISTRER' : 'AJOUTER'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final itemProvider = context.watch<ItemProvider>();
    final cartonProvider = context.watch<CartonProvider>();
    
    final currentBox = cartonProvider.cartons.firstWhere(
      (c) => c.id == widget.box.id, 
      orElse: () => widget.box
    );
    
    final allItems = itemProvider.getItemsByCartonId(currentBox.id);
    final filteredItems = itemProvider.searchItemsByCartonIdAndName(
      cartonId: currentBox.id,
      query: _searchQuery,
    );

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
                  // Ligne des boutons d'actions avec animation Wink
                  Row(
                    children: [
                      Expanded(child: _buildWinkAnimation(child: _buildActionButton('Étiquette PDF', Icons.download, const Color(0xFF27AE60), () {}))),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _buildWinkAnimation(
                          delayMs: 150,
                          child: InkWell(
                            onTap: () => _showEditCartonDialog(context, currentBox),
                            child: _buildActionButton('Modifier', Icons.edit_note, const Color(0xFF7F56D9), null),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  _buildWinkAnimation(
                    delayMs: 300,
                    child: InkWell(
                      onTap: () => _showDeleteCartonConfirmation(context, currentBox.id),
                      child: _buildDeleteButton(),
                    ),
                  ),
                  const SizedBox(height: 25),
                  _buildInfoSection(currentBox, allItems.length),
                  const SizedBox(height: 25),
                  _buildContentSection(filteredItems, allItems.length, currentBox.id),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showItemForm(context, cartonId: currentBox.id),
        backgroundColor: AppColors.headerMid,
        icon: const Icon(Icons.add),
        label: const Text('Ajouter un objet'),
      ),
    );
  }

  // --- COMPOSANTS UI ---

  Widget _buildHeader(BuildContext context, Carton box) => GradientHeader(
        height: 200,
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(box.name, style: AppTextStyles.headerTitle.copyWith(color: Colors.white, fontSize: 28)),
                  if (box.fragile) ...[
                    const SizedBox(width: 10),
                    const Icon(Icons.warning_amber_rounded, color: Colors.orangeAccent),
                  ],
                ],
              ),
              Text(box.room.label, style: const TextStyle(color: Colors.white70, fontSize: 16)),
            ],
          ),
        ),
      );

  Widget _buildInfoSection(Carton box, int totalItems) => Container(
        decoration: _cardDecoration(),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildInfoRow('ID:', box.id.substring(0, 8), isGrey: true),
              const Divider(),
              _buildInfoRow('Créé le:', DateFormat('dd MMM yyyy').format(box.createdAt)),
              const Divider(),
              _buildInfoRow("Objets:", totalItems.toString(), isBoldValue: true),
            ],
          ),
        ),
      );

  Widget _buildContentSection(List<CartonItem> items, int total, String cartonId) => Container(
        decoration: _cardDecoration(),
        child: Column(
          children: [
            _buildSectionHeader('Contenu ($total)', Icons.inventory, const Color(0xFFF06292)),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _searchQuery = value),
                decoration: InputDecoration(
                  hintText: 'Rechercher un objet...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
            ),
            if (items.isEmpty)
              const Padding(padding: EdgeInsets.all(20), child: Text('Aucun objet trouvé'))
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return InkWell(
                    onTap: () => _showItemForm(context, item: item, cartonId: cartonId),
                    child: ItemTile(
                      title: item.name,
                      subtitle: item.description ?? '',
                      imageUrl: item.photo,
                    ),
                  );
                },
              ),
          ],
        ),
      );

  // --- HELPERS VISUELS ---

  Widget _buildDialogPhotoSelector(String? path, {required VoidCallback onTap}) {
    final img = buildPhotoImageProvider(path);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120, width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade300, width: 1.5),
        ),
        child: img == null 
          ? const Column(
              mainAxisAlignment: MainAxisAlignment.center, 
              children: [
                Icon(Icons.add_a_photo, size: 30, color: Colors.grey), 
                SizedBox(height: 8),
                Text('Ajouter une photo', style: TextStyle(color: Colors.grey))
              ])
          : ClipRRect(borderRadius: BorderRadius.circular(13), child: Image(image: img, fit: BoxFit.cover)),
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color, VoidCallback? onTap) => Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
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
        child: const Center(child: Text('Supprimer le carton', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
      );

  Widget _buildSectionHeader(String title, IconData icon, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(color: color, borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      );

  Widget _buildInfoRow(String label, String value, {bool isGrey = false, bool isBoldValue = false}) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600)),
          Text(value, style: TextStyle(fontWeight: isBoldValue ? FontWeight.bold : FontWeight.normal, color: isGrey ? Colors.grey : Colors.black)),
        ],
      );

  BoxDecoration _cardDecoration() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      );

  Widget _buildWinkAnimation({required Widget child, int delayMs = 0}) => TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 800),
        curve: Curves.elasticOut,
        builder: (context, value, child) => Transform.scale(scale: value, child: child),
        child: child,
      );
}