import 'dart:async' show unawaited;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:supermoms/app/theme/app_colors.dart';
import 'package:supermoms/app/theme/app_text_styles.dart';
import 'package:supermoms/features/items/widgets/item_tile.dart'; 
import 'package:supermoms/shared/utils/carton_label_pdf.dart';
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
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<ItemProvider>().loadItems(widget.box.id),
    );
  }

  // --- ACTIONS ---

  Future<void> _handleDeleteCarton(BuildContext context, String cartonId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Supprimer ce carton ?'),
        content: const Text('Cela supprimera définitivement le carton et tout son contenu.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('ANNULER')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('SUPPRIMER', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await context.read<CartonProvider>().deleteCarton(cartonId);
      if (mounted) Navigator.of(context).pop(); 
    }
  }

  Future<void> _exportEtiquettePdf(BuildContext context, Carton box) async {
    final navigator = Navigator.of(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CircularProgressIndicator()),
    );
    
    try {
      final itemProvider = context.read<ItemProvider>();
      await itemProvider.loadItems(box.id);
      final items = itemProvider.getItemsByCartonId(box.id);
      final totalQty = items.fold<int>(0, (sum, item) => sum + item.quantity);
      
      final bytes = await buildCartonLabelPdf(box, itemCount: totalQty);
      navigator.pop(); // Fermer le loader
      
      await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => bytes);
    } catch (e) {
      navigator.pop();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur PDF : $e')));
      }
    }
  }

  // --- WIDGETS ---

  @override
  Widget build(BuildContext context) {
    final cartonProvider = context.watch<CartonProvider>();
    final itemProvider = context.watch<ItemProvider>();

    final currentBox = cartonProvider.cartons.firstWhere(
      (c) => c.id == widget.box.id,
      orElse: () => widget.box,
    );

    final items = itemProvider.getItemsByCartonId(currentBox.id);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      body: Column(
        children: [
          _buildHeader(context, currentBox),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildActionButton('Étiquette PDF', Icons.download, const Color(0xFF27AE60), 
                          () => _exportEtiquettePdf(context, currentBox)),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: _buildActionButton('Modifier', Icons.edit_note, const Color(0xFF7F56D9), 
                          () => _showEditCartonDialog(context, currentBox)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    _buildDeleteButton(() => _handleDeleteCarton(context, currentBox.id)),
                    const SizedBox(height: 25),
                    _buildQrCodeSection(currentBox),
                    const SizedBox(height: 25),
                    _buildInfoSection(currentBox, items),
                    const SizedBox(height: 25),
                    _buildContentSection(context, currentBox, items),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showItemForm(context, cartonId: currentBox.id),
        label: const Text('Ajouter un objet'),
        icon: const Icon(Icons.add),
        backgroundColor: AppColors.headerMid,
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Carton box) => GradientHeader(
    height: 200,
    child: SafeArea(
      child: Stack(
        children: [
          Positioned(
            left: 5,
            top: 5,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(box.room.icon, style: const TextStyle(fontSize: 32)),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        box.name,
                        style: AppTextStyles.headerTitle.copyWith(color: Colors.white, fontSize: 24),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(box.room.label, style: const TextStyle(color: Colors.white70, fontSize: 16)),
                    if (box.fragile) ...[
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(5)),
                        child: const Text('FRAGILE', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  Widget _buildDeleteButton(VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Container(
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
    ),
  );

  Widget _buildQrCodeSection(Carton box) => Container(
    decoration: _cardDecoration(),
    child: Column(
      children: [
        _buildSectionHeader('Code QR', Icons.qr_code_2, const Color(0xFF4A90E2)),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              QrImageView(
                data: box.id,
                version: QrVersions.auto,
                size: 180.0,
                errorCorrectionLevel: QrErrorCorrectLevel.H,
                backgroundColor: Colors.white,
              ),
              const SizedBox(height: 10),
              const Text('Scannez pour identifier ce carton', style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _buildInfoSection(Carton box, List<CartonItem> items) {
    final totalQty = items.fold<int>(0, (sum, item) => sum + item.quantity);
    final categoriesCount = items.map((e) => e.name.trim().toLowerCase()).toSet().length;

    return Container(
      decoration: _cardDecoration(),
      child: Column(
        children: [
          _buildSectionHeader('Logistique', Icons.analytics_outlined, const Color(0xFF4A90E2)),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildInfoRow('Référence ID', box.id.substring(0, 8).toUpperCase()),
                const Divider(),
                _buildInfoRow('Date de création', DateFormat('dd/MM/yyyy').format(box.createdAt)),
                const Divider(),
                _buildInfoRow('Objets au total', '$totalQty', isBoldValue: true, valueColor: Colors.green),
                const Divider(),
                _buildInfoRow('Types d\'objets', '$categoriesCount', isBoldValue: true, valueColor: Colors.blue),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection(BuildContext context, Carton box, List<CartonItem> items) => Container(
    decoration: _cardDecoration(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Contenu détaillé', Icons.inventory_2_outlined, const Color(0xFFF06292)),
        if (items.isEmpty)
          const Center(child: Padding(padding: EdgeInsets.all(40), child: Text('Ce carton est vide', style: TextStyle(color: Colors.grey))))
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ItemTile(
                title: item.name,
                subtitle: item.description,
                imageUrl: item.photo,
                quantity: item.quantity,
                onTap: () => _showItemForm(context, item: item, cartonId: box.id),
              );
            },
          ),
      ],
    ),
  );

  // --- HELPERS STYLE ---

  Widget _buildActionButton(String label, IconData icon, Color color, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Container(
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
    ),
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

  Widget _buildInfoRow(String label, String value, {bool isBoldValue = false, Color? valueColor}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
        Text(value, style: TextStyle(fontWeight: isBoldValue ? FontWeight.bold : FontWeight.normal, color: valueColor ?? Colors.black87)),
      ],
    ),
  );

  BoxDecoration _cardDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
  );

  InputDecoration _dialogInputStyle(String label, IconData icon) => InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon, color: AppColors.headerMid.withOpacity(0.7)),
    filled: true,
    fillColor: Colors.grey.shade50,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
  );

  // --- DIALOGS ---

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
              TextField(controller: nameController, decoration: _dialogInputStyle('Nom', Icons.inventory_2)),
              const SizedBox(height: 10),
              SwitchListTile(
                title: const Text('Fragile'),
                value: isFragile,
                onChanged: (val) => setModalState(() => isFragile = val),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('ANNULER')),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty) {
                  await context.read<CartonProvider>().updateCarton(box.copyWith(name: nameController.text, fragile: isFragile));
                  if (context.mounted) Navigator.pop(context);
                }
              },
              child: const Text('ENREGISTRER'),
            ),
          ],
        ),
      ),
    );
  }

  void _showItemForm(BuildContext context, {CartonItem? item, required String cartonId}) {
    final isEditing = item != null;
    final nameController = TextEditingController(text: item?.name ?? '');
    final descController = TextEditingController(text: item?.description ?? '');
    final qtyController = TextEditingController(text: item?.quantity.toString() ?? '1');
    String? photoPath = item?.photo;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (stCtx, setModalState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          title: Text(isEditing ? 'Modifier l\'objet' : 'Nouvel objet'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDialogPhotoSelector(photoPath, onTap: () async {
                  final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 70);
                  if (picked != null) {
                    final stored = await persistPickedPhoto(picked);
                    setModalState(() => photoPath = stored);
                  }
                }),
                const SizedBox(height: 15),
                TextField(controller: nameController, decoration: _dialogInputStyle('Nom', Icons.tag)),
                const SizedBox(height: 10),
                TextField(controller: qtyController, keyboardType: TextInputType.number, decoration: _dialogInputStyle('Quantité', Icons.numbers)),
                const SizedBox(height: 10),
                TextField(controller: descController, maxLines: 2, decoration: _dialogInputStyle('Description', Icons.notes)),
              ],
            ),
          ),
          actions: [
            if (isEditing) 
              TextButton(
                onPressed: () async {
                  await context.read<ItemProvider>().removeItem(item.id);
                  await context.read<CartonProvider>().loadCartons();
                  if (ctx.mounted) Navigator.pop(ctx);
                },
                child: const Text('SUPPRIMER', style: TextStyle(color: Colors.red)),
              ),
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('ANNULER')),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty) {
                  final qty = int.tryParse(qtyController.text) ?? 1;
                  final newItem = CartonItem(
                    id: isEditing ? item.id : DateTime.now().toIso8601String(),
                    cartonId: cartonId,
                    name: nameController.text,
                    description: descController.text,
                    photo: photoPath,
                    quantity: qty,
                  );
                  isEditing ? await context.read<ItemProvider>().updateItem(newItem) : await context.read<ItemProvider>().addItem(newItem);
                  await context.read<CartonProvider>().loadCartons();
                  if (ctx.mounted) Navigator.pop(ctx);
                }
              },
              child: Text(isEditing ? 'SAUVER' : 'AJOUTER'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogPhotoSelector(String? path, {required VoidCallback onTap}) {
    final provider = buildPhotoImageProvider(path);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100, width: double.infinity,
        decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.shade300)),
        child: provider != null 
          ? ClipRRect(borderRadius: BorderRadius.circular(15), child: Image(image: provider, fit: BoxFit.cover))
          : const Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.camera_alt_outlined, color: Colors.grey), Text('Photo', style: TextStyle(color: Colors.grey))]),
      ),
    );
  }
}