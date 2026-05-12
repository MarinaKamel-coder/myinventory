import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:supermoms/app/theme/app_colors.dart';
import 'package:supermoms/shared/utils/local_photo_storage.dart';
import 'package:supermoms/shared/utils/photo_image_provider.dart';
import 'package:supermoms/src/models/carton.dart';
import 'package:supermoms/src/models/carton_item.dart';
import 'package:supermoms/src/models/room.dart';
import 'package:supermoms/src/providers/carton_provider.dart';
import 'package:supermoms/src/providers/item_provider.dart';

class ItemAddGlobalScreen extends StatefulWidget {
  const ItemAddGlobalScreen({super.key});

  @override
  State<ItemAddGlobalScreen> createState() => _ItemAddGlobalScreenState();
}

class _ItemAddGlobalScreenState extends State<ItemAddGlobalScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Champs de l'objet
  final _itemNameController = TextEditingController();
  final _itemDescController = TextEditingController();
  final _itemQtyController = TextEditingController(text: '1'); 

  // Gestion du carton de destination
  Carton? _selectedCarton;
  bool _createNewCarton = false;

  // Champs pour le nouveau carton
  final _newCartonNameController = TextEditingController();
  Room _selectedRoom = Room.salon;
  
  final ImagePicker _picker = ImagePicker();
  String? _photoPath;

  @override
  void dispose() {
    _itemNameController.dispose();
    _itemDescController.dispose();
    _itemQtyController.dispose();
    _newCartonNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartons = context.watch<CartonProvider>().cartons;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        title: const Text('Ajouter un objet', 
          style: TextStyle(color: AppColors.textMain, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textMain),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("L'objet"),
                  _buildCard([
                    _buildTextField(
                      _itemNameController, 
                      "Nom de l'objet *", 
                      'Ex: Assiettes en porcelaine',
                      validator: (val) => val == null || val.isEmpty ? "Le nom est requis" : null,
                    ),
                    const SizedBox(height: 15),
                    _buildTextField(_itemDescController, 'Description (optionnel)', 'Ex: Fragile, carton bleu'),
                    const SizedBox(height: 15),
                    
                    // --- CHAMP QUANTITÉ (Visible ici) ---
                    _buildTextField(
                      _itemQtyController, 
                      'Quantité', 
                      '1',
                      keyboardType: TextInputType.number,
                    ),
                    
                    const SizedBox(height: 20),
                    _buildPhotoSelector(),
                  ]),

                  const SizedBox(height: 25),

                  _buildSectionTitle('Destination'),
                  _buildCard([
                    const Text('Où voulez-vous ranger cet objet ?', 
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    const SizedBox(height: 15),
                    
                    Row(
                      children: [
                        ChoiceChip(
                          label: const Text('Carton existant'),
                          selected: !_createNewCarton,
                          selectedColor: AppColors.headerMid.withOpacity(0.2),
                          onSelected: (val) => setState(() => _createNewCarton = !val),
                        ),
                        const SizedBox(width: 10),
                        ChoiceChip(
                          label: const Text('Nouveau carton'),
                          selected: _createNewCarton,
                          selectedColor: AppColors.headerMid.withOpacity(0.2),
                          onSelected: (val) => setState(() => _createNewCarton = val),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),

                    AnimatedCrossFade(
                      firstChild: _buildCartonDropdown(cartons),
                      secondChild: _buildNewCartonFields(),
                      crossFadeState: _createNewCarton ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                      duration: const Duration(milliseconds: 300),
                    ),
                  ]),

                  const SizedBox(height: 40),
                  _buildSubmitButton(context),
                ],
              ),
            ),
          ),
          if (_isLoading)
             Container(
              color: Colors.black26,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  // --- WIDGETS UI ---

  Widget _buildSectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(left: 5, bottom: 10),
    child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.headerMid)),
  );

  Widget _buildCard(List<Widget> children) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
  );

  // CORRECTION : Ajout explicite du paramètre keyboardType pour l'affichage
  Widget _buildTextField(
    TextEditingController controller, 
    String label, 
    String hint, 
    {String? Function(String?)? validator, 
    TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textMain)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType, // Indispensable pour la quantité
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildCartonDropdown(List<Carton> cartons) => DropdownButtonFormField<Carton>(
    value: _selectedCarton,
    hint: const Text('Choisir un carton'),
    isExpanded: true,
    validator: (val) => !_createNewCarton && val == null ? "Sélectionnez un carton" : null,
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    ),
    items: cartons.map((c) => DropdownMenuItem(value: c, child: Text('${c.name} (${c.room.label})'))).toList(),
    onChanged: (val) => setState(() => _selectedCarton = val),
  );

  Widget _buildNewCartonFields() => Column(
    children: [
      _buildTextField(
        _newCartonNameController, 
        'Nom du nouveau carton *', 
        'Ex: Cuisine - Vaisselle',
        validator: (val) => _createNewCarton && (val == null || val.isEmpty) ? "Le nom du carton est requis" : null,
      ),
      const SizedBox(height: 15),
      DropdownButtonFormField<Room>(
        value: _selectedRoom,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
        items: Room.values.map((r) => DropdownMenuItem(value: r, child: Text("${r.icon} ${r.label}"))).toList(),
        onChanged: (val) => setState(() => _selectedRoom = val!),
      ),
    ],
  );

  Widget _buildPhotoSelector() {
    final imageProvider = buildPhotoImageProvider(_photoPath);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Photo (optionnel)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textMain)),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: _pickPhoto,
          child: Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey.shade200, width: 2),
            ),
            child: imageProvider == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt_outlined, color: Colors.grey.shade400, size: 35),
                      const SizedBox(height: 5),
                      Text('Ajouter une photo', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                    ],
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image(image: imageProvider, fit: BoxFit.cover),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context) => GestureDetector(
    onTap: _isLoading ? null : () => _handleSubmit(),
    child: Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: AppColors.mainGradient,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: AppColors.headerMid.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6))],
      ),
      child: Center(
        child: Text(_isLoading ? "Enregistrement..." : "Confirmer l'objet", 
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
      ),
    ),
  );

  // --- LOGIQUE METIER ---

  Future<void> _pickPhoto() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (picked == null) return;
    final storedPath = await persistPickedPhoto(picked);
    if (!mounted || storedPath == null) return;
    setState(() => _photoPath = storedPath);
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final cartonProvider = context.read<CartonProvider>();
      final itemProvider = context.read<ItemProvider>();
      late String targetCartonId;

      if (_createNewCarton) {
        final newCarton = Carton(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: _newCartonNameController.text.trim(),
          room: _selectedRoom,
          fragile: false,
          items: [],
          createdAt: DateTime.now(),
        );
        await cartonProvider.addCarton(newCarton);
        targetCartonId = newCarton.id;
      } else {
        targetCartonId = _selectedCarton!.id;
      }

      final newItem = CartonItem(
        id: DateTime.now().toIso8601String(),
        cartonId: targetCartonId,
        name: _itemNameController.text.trim(),
        description: _itemDescController.text.trim(),
        quantity: int.tryParse(_itemQtyController.text) ?? 1,
        photo: _photoPath,
      );

      await itemProvider.addItem(newItem);

      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("L'objet '${newItem.name}' a été ajouté !"), 
          backgroundColor: AppColors.success
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur technique lors de l'ajout"), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}