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
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Charger les items au démarrage
    Future.microtask(() => context.read<ItemProvider>().loadItems(widget.box.id));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
      if (mounted) Navigator.pop(context); // Retour à la liste
    }
  }

  Future<void> _exportEtiquettePdf(BuildContext context, Carton box) async {
    final navigator = Navigator.of(context);
    unawaited(
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => const PopScope(
          canPop: false,
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
    );
    try {
      final itemProvider = context.read<ItemProvider>();
      await itemProvider.loadItems(box.id);
      final itemCount = itemProvider.getItemsByCartonId(box.id).length;
      final bytes = await buildCartonLabelPdf(box, itemCount: itemCount);
      navigator.pop();
      try {
        await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => bytes);
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Impression / aperçu : $e')),
          );
        }
      }
    } catch (e) {
      navigator.pop();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Impossible de générer l\'étiquette : $e')),
        );
      }
    }
  }

  // --- WIDGETS DE CONSTRUCTION ---

  Widget _buildWinkAnimation({required Widget child, int delayMs = 0}) => TweenAnimationBuilder<double>(
    tween: Tween<double>(begin: 0.0, end: 1.0),
    duration: const Duration(milliseconds: 1000),
    curve: Curves.elasticOut,
    builder: (context, value, child) {
      final rotation = (1.0 - value) * -0.15;
      return Transform.rotate(
        angle: rotation,
        child: Transform.scale(scale: value, child: child),
      );
    },
    child: child,
  );

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
                          child: _buildActionButton(
                            'Étiquette PDF',
                            Icons.download,
                            const Color(0xFF27AE60),
                                () => _exportEtiquettePdf(context, currentBox),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _buildWinkAnimation(
                          delayMs: 150,
                          child: _buildActionButton(
                            'Modifier',
                            Icons.edit_note,
                            const Color(0xFF7F56D9),
                                () => _showEditCartonDialog(context, currentBox),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  _buildWinkAnimation(
                    delayMs: 300,
                    child: GestureDetector(
                      onTap: () => _handleDeleteCarton(context, currentBox.id),
                      child: _buildDeleteButton(),
                    ),
                  ),
                  const SizedBox(height: 25),
                  _buildQrCodeSection(currentBox),
                  const SizedBox(height: 25),
                  _buildInfoSection(currentBox, items.length),
                  const SizedBox(height: 25),
                  _buildContentSection(context, currentBox, items),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildWinkAnimation(
        delayMs: 500,
        child: FloatingActionButton.extended(
          onPressed: () => _showItemForm(context, cartonId: currentBox.id),
          label: const Text('Ajouter un objet'),
          icon: const Icon(Icons.add),
          backgroundColor: AppColors.headerMid,
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Carton box) => GradientHeader(
    height: 220,
    child: SafeArea(
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.inventory_2, color: Colors.white, size: 30),
              const SizedBox(width: 15),
              Flexible(
                child: Text(
                  box.name,
                  style: AppTextStyles.headerTitle.copyWith(color: Colors.white, fontSize: 24),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
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
                size: 200.0,
                errorCorrectionLevel: QrErrorCorrectLevel.H,
                backgroundColor: Colors.white,
                embeddedImage: const AssetImage('assets/images/logo.png'),
                embeddedImageStyle: const QrEmbeddedImageStyle(size: Size(50, 50)),
              ),
              const SizedBox(height: 10),
              const Text('Scannez ce code pour identifier le carton', style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _buildInfoSection(Carton box, int totalItems) => Container(
    decoration: _cardDecoration(),
    child: Column(
      children: [
        _buildSectionHeader('Informations', Icons.info_outline, const Color(0xFF4A90E2)),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildInfoRow('ID:', box.id.length > 8 ? '${box.id.substring(0, 8)}...' : box.id, isGrey: true),
              const Divider(),
              _buildInfoRow('Créé le:', DateFormat('dd/MM/yyyy').format(box.createdAt)),
              const Divider(),
              _buildInfoRow("Objets:", totalItems.toString(), isBoldValue: true, valueColor: Colors.green),
            ],
          ),
        )
      ],
    ),
  );

  Widget _buildContentSection(BuildContext context, Carton box, List<CartonItem> items) => Container(
    decoration: _cardDecoration(),
    child: Column(
      children: [
        _buildSectionHeader('Contenu (${items.length})', Icons.inventory, const Color(0xFFF06292)),
        if (items.isEmpty)
          const Padding(padding: EdgeInsets.all(30), child: Text('Aucun objet', style: TextStyle(color: Colors.grey)))
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = items[index];
              final photoProvider = buildPhotoImageProvider(item.photo);
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: photoProvider != null
                      ? Image(image: photoProvider, width: 50, height: 50, fit: BoxFit.cover)
                      : Container(
                    width: 50,
                    height: 50,
                    color: Colors.grey.shade100,
                    child: const Icon(Icons.image_outlined, color: Colors.grey),
                  ),
                ),
                title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(item.description ?? 'Aucune description'),
                onTap: () => _showItemForm(context, item: item, cartonId: box.id),
              );
            },
          ),
      ],
    ),
  );

  Widget _buildDialogPhotoSelector(String? path, {required VoidCallback onTap}) {
    final provider = buildPhotoImageProvider(path);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.shade300)),
        child: provider != null
            ? ClipRRect(borderRadius: BorderRadius.circular(15), child: Image(image: provider, fit: BoxFit.cover))
            : const Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.add_a_photo_outlined, color: Colors.grey, size: 40), Text('Ajouter une photo', style: TextStyle(color: Colors.grey))]),
      ),
    );
  }

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
    decoration: BoxDecoration(
      color: color,
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
        Text(value,
            style: TextStyle(
                fontWeight: isBoldValue ? FontWeight.bold : FontWeight.normal,
                color: valueColor ?? Colors.black87)),
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
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey.shade200)),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey.shade200)),
  );

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
                value: isFragile,
                activeColor: Colors.orange,
                onChanged: (val) => setModalState(() => isFragile = val),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('ANNULER')),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty) {
                  final updatedBox = box.copyWith(name: nameController.text, fragile: isFragile);
                  await context.read<CartonProvider>().updateCarton(updatedBox);
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
                  decoration: _dialogInputStyle('Description', Icons.notes),
                ),
              ],
            ),
          ),
          actions: [
            if (isEditing)
              TextButton(
                onPressed: () async {
                  await context.read<ItemProvider>().removeItem(item.id);
                  await context.read<CartonProvider>().loadCartons();
                  if (context.mounted) Navigator.pop(context);
                },
                child: const Text('SUPPRIMER', style: TextStyle(color: Colors.red)),
              ),
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('ANNULER')),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty) {
                  final newItem = CartonItem(
                    id: isEditing ? item.id : DateTime.now().toIso8601String(),
                    cartonId: cartonId,
                    name: nameController.text,
                    description: descController.text,
                    photo: photoPath,
                  );
                  if (isEditing) {
                    await context.read<ItemProvider>().updateItem(newItem);
                  } else {
                    await context.read<ItemProvider>().addItem(newItem);
                  }
                  await context.read<CartonProvider>().loadCartons();
                  if (context.mounted) Navigator.pop(context);
                }
              },
              child: Text(isEditing ? 'ENREGISTRER' : 'AJOUTER'),
            ),
          ],
        ),
      ),
    );
  }
}
