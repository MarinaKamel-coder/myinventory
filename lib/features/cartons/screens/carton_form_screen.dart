// ignore_for_file: prefer_expression_function_bodies

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supermoms/app/theme/app_colors.dart';
import 'package:supermoms/src/models/carton.dart';
import 'package:supermoms/src/models/carton_item.dart';
import 'package:supermoms/src/models/room.dart';
import 'package:supermoms/src/providers/carton_provider.dart';
import 'package:supermoms/shared/utils/local_photo_storage.dart';
import 'package:supermoms/shared/utils/photo_image_provider.dart';

class CartonFormScreen extends StatefulWidget {
  const CartonFormScreen({super.key});

  @override
  State<CartonFormScreen> createState() => _CartonFormScreenState();
}

class _CartonFormScreenState extends State<CartonFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // États du Carton
  final _cartonNameController = TextEditingController();
  Room _selectedRoom = Room.salon;
  bool _isFragile = false;
  
  // États de l'objet en cours d'ajout
  bool _showItemForm = false;
  final _itemNameController = TextEditingController();
  final _itemDescController = TextEditingController();
  final _itemQuantityController = TextEditingController(text: '1'); // Initialisé à 1
  String? _photoPath;
  
  final List<CartonItem> _addedItems = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _cartonNameController.dispose();
    _itemNameController.dispose();
    _itemDescController.dispose();
    _itemQuantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        title: const Text('Nouveau Carton', 
          style: TextStyle(color: AppColors.textMain, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textMain),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // SECTION 1 : INFOS CARTON
              _buildCardSection([
                _buildFieldLabel('Nom du carton *'),
                _buildTextField(
                  _cartonNameController, 
                  'Ex: Vaisselle, Livres...',
                  validator: (val) => val == null || val.isEmpty ? "Le nom est requis" : null,
                ),
                const SizedBox(height: 15),
                _buildFieldLabel('Pièce de destination *'),
                _buildRoomDropdown(),
                const SizedBox(height: 20),
                _buildFragileToggle(),
              ]),
              
              const SizedBox(height: 20),
              
              // SECTION 2 : AJOUT D'OBJETS
              if (!_showItemForm) 
                _buildAddObjectButton() 
              else 
                _buildItemFormSection(),
              
              if (_addedItems.isNotEmpty) _buildAddedItemsList(),
              
              const SizedBox(height: 30),
              
              // BOUTON FINAL
              _buildCreateCartonButton(context),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGETS DE CONSTRUCTION ---

  Widget _buildCardSection(List<Widget> children) => Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
      );

  Widget _buildFieldLabel(String label) => Padding(
        padding: const EdgeInsets.only(bottom: 8.0, left: 4),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textMain)),
      );

  Widget _buildTextField(TextEditingController controller, String hint, {String? Function(String?)? validator}) => TextFormField(
        controller: controller,
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.purple.shade50)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.headerMid, width: 2)),
        ),
      );

  Widget _buildRoomDropdown() => DropdownButtonFormField<Room>(
        value: _selectedRoom,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
        items: Room.values.map((room) => DropdownMenuItem(
          value: room,
          child: Row(children: [Text(room.icon), const SizedBox(width: 10), Text(room.label)]),
        )).toList(),
        onChanged: (val) => setState(() => _selectedRoom = val!),
      );

  Widget _buildFragileToggle() => GestureDetector(
        onTap: () => setState(() => _isFragile = !_isFragile),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: _isFragile ? const Color(0xFFFFF3E0) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _isFragile ? AppColors.statsOrange : Colors.purple.shade100),
          ),
          child: Row(
            children: [
              Checkbox(
                value: _isFragile, 
                activeColor: AppColors.statsOrange, 
                onChanged: (val) => setState(() => _isFragile = val!)
              ),
              const Icon(Icons.warning_amber_rounded, color: AppColors.statsOrange, size: 20),
              const SizedBox(width: 8),
              const Text('Contenu fragile', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textMain)),
            ],
          ),
        ),
      );

  Widget _buildAddObjectButton() => OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 60),
          side: const BorderSide(color: AppColors.headerMid, width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        onPressed: () => setState(() => _showItemForm = true),
        icon: const Icon(Icons.add_circle_outline, color: AppColors.headerMid),
        label: const Text('Ajouter un objet au carton', 
          style: TextStyle(color: AppColors.headerMid, fontWeight: FontWeight.bold, fontSize: 16)),
      );

  Widget _buildItemFormSection() => _buildCardSection([
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Nouvel objet", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.headerMid)),
            IconButton(onPressed: () => setState(() => _showItemForm = false), icon: const Icon(Icons.close, size: 20)),
          ],
        ),
        const SizedBox(height: 10),
        _buildTextField(_itemNameController, 'Nom de l\'objet (ex: Assiettes)'),
        const SizedBox(height: 12),
        _buildTextField(_itemDescController, 'Description (optionnel)'),
        const SizedBox(height: 15),
        
        // --- CHAMP QUANTITÉ ---
        _buildFieldLabel('Quantité'),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.purple.shade50),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline, color: AppColors.headerMid),
                onPressed: () {
                  int val = int.tryParse(_itemQuantityController.text) ?? 1;
                  if (val > 1) setState(() => _itemQuantityController.text = (val - 1).toString());
                },
              ),
              SizedBox(
                width: 60,
                child: TextField(
                  controller: _itemQuantityController,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(border: InputBorder.none),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline, color: AppColors.headerMid),
                onPressed: () {
                  int val = int.tryParse(_itemQuantityController.text) ?? 1;
                  setState(() => _itemQuantityController.text = (val + 1).toString());
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        _buildPhotoPicker(),
        const SizedBox(height: 15),
        _buildAddThisItemButton(),
      ]);

  Widget _buildPhotoPicker() {
    final provider = buildPhotoImageProvider(_photoPath);
    return GestureDetector(
      onTap: () async {
        final picked = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
        if (picked == null) return;
        final storedPath = await persistPickedPhoto(picked);
        if (storedPath != null) setState(() => _photoPath = storedPath);
      },
      child: Container(
        height: 80,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: provider == null
            ? const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.camera_alt, color: Colors.grey), SizedBox(width: 10), Text("Photo", style: TextStyle(color: Colors.grey))])
            : ClipRRect(borderRadius: BorderRadius.circular(12), child: Image(image: provider, fit: BoxFit.cover)),
      ),
    );
  }

  Widget _buildAddThisItemButton() => ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.headerMid,
          minimumSize: const Size(double.infinity, 45),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: () {
          if (_itemNameController.text.isNotEmpty) {
            setState(() {
              _addedItems.add(CartonItem(
                id: DateTime.now().toIso8601String(),
                cartonId: '', 
                name: _itemNameController.text.trim(),
                description: _itemDescController.text.trim(),
                quantity: int.tryParse(_itemQuantityController.text) ?? 1, // Récupère la quantité
                photo: _photoPath,
              ));
              _itemNameController.clear();
              _itemDescController.clear();
              _itemQuantityController.text = '1'; // Reset la quantité pour le prochain objet
              _showItemForm = false;
              _photoPath = null;
            });
          }
        },
        child: const Text('Confirmer l\'objet', style: TextStyle(color: Colors.white)),
      );

  Widget _buildAddedItemsList() => Column(
        children: _addedItems.map((item) => Card(
          margin: const EdgeInsets.only(top: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: const Icon(Icons.check_circle, color: Colors.green),
            title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Quantité : ${item.quantity}'),
            trailing: IconButton(icon: const Icon(Icons.delete_outline, color: Colors.redAccent), 
              onPressed: () => setState(() => _addedItems.remove(item))),
          ),
        )).toList(),
      );

  Widget _buildCreateCartonButton(BuildContext context) => GestureDetector(
        onTap: () async {
          if (_formKey.currentState!.validate()) {
            final cartonId = DateTime.now().millisecondsSinceEpoch.toString();
            final newCarton = Carton(
              id: cartonId,
              name: _cartonNameController.text.trim(),
              room: _selectedRoom,
              fragile: _isFragile,
              items: _addedItems.map((item) => item.copyWith(cartonId: cartonId)).toList(),
              createdAt: DateTime.now(),
            );
            
            await context.read<CartonProvider>().addCarton(newCarton);
            if (mounted) Navigator.pop(context);
          }
        },
        child: Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            gradient: AppColors.mainGradient,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [BoxShadow(color: AppColors.headerMid.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
          ),
          child: const Center(
            child: Text('CRÉER LE CARTON', 
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
          ),
        ),
      );
}