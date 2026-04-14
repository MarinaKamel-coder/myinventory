import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermoms/app/theme/app_colors.dart';
import 'package:supermoms/src/models/carton.dart';
import 'package:supermoms/src/models/carton_item.dart';
import 'package:supermoms/src/models/room.dart';
import 'package:supermoms/src/providers/carton_provider.dart';

class ItemAddGlobalScreen extends StatefulWidget {
  const ItemAddGlobalScreen({super.key});

  @override
  State<ItemAddGlobalScreen> createState() => _ItemAddGlobalScreenState();
}

class _ItemAddGlobalScreenState extends State<ItemAddGlobalScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Champs de l'objet
  final _itemNameController = TextEditingController();
  final _itemDescController = TextEditingController();

  // Gestion du carton de destination
  Carton? _selectedCarton;
  bool _createNewCarton = false;

  // Champs pour le nouveau carton (si nécessaire)
  final _newCartonNameController = TextEditingController();
  Room _selectedRoom = Room.salon;
  final bool _isFragile = false;

  @override
  Widget build(BuildContext context) {
    final cartons = context.watch<CartonProvider>().cartons;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        title: const Text('Ajouter un objet', style: TextStyle(color: AppColors.textMain, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textMain),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- SECTION 1 : L'OBJET ---
              _buildSectionTitle("L'objet"),
              _buildCard([
                _buildTextField(_itemNameController, "Nom de l'objet *", 'Ex: Cafetière'),
                const SizedBox(height: 15),
                _buildTextField(_itemDescController, 'Description', 'Ex: Rouge, Nespresso'),
                const SizedBox(height: 20),
                _buildPhotoSelector(),
              ]),

              const SizedBox(height: 25),

              // --- SECTION 2 : DESTINATION ---
              _buildSectionTitle('Destination'),
              _buildCard([
                const Text('Où voulez-vous ranger cet objet ?', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 15),
                
                // Switch : Existant vs Nouveau
                Row(
                  children: [
                    ChoiceChip(
                      label: const Text('Carton existant'),
                      selected: !_createNewCarton,
                      onSelected: (val) => setState(() => _createNewCarton = !val),
                    ),
                    const SizedBox(width: 10),
                    ChoiceChip(
                      label: const Text('Nouveau carton'),
                      selected: _createNewCarton,
                      onSelected: (val) => setState(() => _createNewCarton = val),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),

                if (!_createNewCarton)
                  _buildCartonDropdown(cartons)
                else
                  _buildNewCartonFields(),
              ]),

              const SizedBox(height: 40),

              // --- BOUTON DE SAUVEGARDE ---
              _buildSubmitButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(left: 5, bottom: 10),
    child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.headerMid)),
  );

  Widget _buildCard(List<Widget> children) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
  );

  Widget _buildTextField(TextEditingController controller, String label, String hint) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textMain)),
      const SizedBox(height: 8),
      TextFormField(
        controller: controller,
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

  Widget _buildCartonDropdown(List<Carton> cartons) => DropdownButtonFormField<Carton>(
    initialValue: _selectedCarton,
    hint: const Text('Choisir un carton'),
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
      _buildTextField(_newCartonNameController, 'Nom du nouveau carton *', 'Ex: Cuisine - Petit électro'),
      const SizedBox(height: 15),
      DropdownButtonFormField<Room>(
        initialValue: _selectedRoom,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
        items: Room.values.map((r) => DropdownMenuItem(value: r, child: Text(r.label))).toList(),
        onChanged: (val) => setState(() => _selectedRoom = val!),
      ),
    ],
  );

  Widget _buildSubmitButton(BuildContext context) => GestureDetector(
    onTap: () => _handleSubmit(context),
    child: Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: AppColors.mainGradient,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: AppColors.headerMid.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 6))],
      ),
      child: const Center(
        child: Text("Enregistrer l'objet", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
      ),
    ),
  );

  Widget _buildPhotoSelector() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text("Photo de l'objet (optionnel)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textMain)),
      const SizedBox(height: 10),
      GestureDetector(
        onTap: () {
          // Simulation de prise de photo pour le moment
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Ouverture de l'appareil photo...")));
        },
        child: Container(
          width: double.infinity,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.shade200, width: 2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.camera_alt_outlined, color: Colors.grey.shade400, size: 30),
              const SizedBox(height: 5),
              Text('Ajouter une photo', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
            ],
          ),
        ),
      ),
    ],
  );

  void _handleSubmit(BuildContext context) {
    if (_itemNameController.text.isEmpty) return;

    final provider = context.read<CartonProvider>();
    late String targetCartonId;

    if (_createNewCarton) {
      if (_newCartonNameController.text.isEmpty) return;
      // 1. Créer le nouveau carton
      final newCarton = Carton(
        id: DateTime.now().toString(),
        name: _newCartonNameController.text,
        room: _selectedRoom,
        fragile: _isFragile,
        items: [],
        createdAt: DateTime.now(),
      );
      provider.addCarton(newCarton);
      targetCartonId = newCarton.id;
    } else {
      if (_selectedCarton == null) return;
      targetCartonId = _selectedCarton!.id;
    }

    // 2. Ajouter l'objet
    final newItem = CartonItem(
      id: DateTime.now().toString(),
      cartonId: targetCartonId,
      name: _itemNameController.text,
      description: _itemDescController.text,
    );
    provider.addItemToCarton(targetCartonId, newItem);

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Objet '${newItem.name}' ajouté avec succès !"), backgroundColor: AppColors.success),
    );
  }
}
