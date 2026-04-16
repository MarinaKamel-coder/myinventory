import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermoms/app/theme/app_colors.dart';
import 'package:supermoms/src/models/carton.dart';
import 'package:supermoms/src/models/carton_item.dart';
import 'package:supermoms/src/models/room.dart';
import 'package:supermoms/src/providers/carton_provider.dart';

class CartonFormScreen extends StatefulWidget {
  const CartonFormScreen({super.key});

  @override
  State<CartonFormScreen> createState() => _CartonFormScreenState();
}

class _CartonFormScreenState extends State<CartonFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isFragile = false;
  bool _showItemForm = false;

  final _cartonNameController = TextEditingController();
  final _itemNameController = TextEditingController();
  final _itemDescController = TextEditingController();
  
  late Room _selectedRoom;
  final List<CartonItem> _addedItems = [];

  @override
  void initState() {
    super.initState();
    _selectedRoom = Room.salon;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFFF8F9FE),
        appBar: AppBar(
          title: const Text('Nouveau Carton', style: TextStyle(color: AppColors.textMain, fontWeight: FontWeight.bold)),
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
                _buildCardSection([
                  _buildFieldLabel('Nom du carton *'),
                  _buildTextField(_cartonNameController, 'Ex: Vaisselle, Livres...'),
                  const SizedBox(height: 15),
                  _buildFieldLabel('Pièce de destination *'),
                  _buildRoomDropdown(),
                  const SizedBox(height: 20),
                  _buildFragileToggle(),
                ]),
                const SizedBox(height: 20),
                
                // Formulaire interne pour ajouter des objets localement
                if (!_showItemForm) 
                  _buildAddObjectButton() 
                else 
                  _buildItemFormSection(),
                
                if (_addedItems.isNotEmpty) _buildAddedItemsList(),
                
                const SizedBox(height: 30),
                _buildCreateCartonButton(context),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      );

  Widget _buildCardSection(List<Widget> children) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
      );

  Widget _buildFieldLabel(String label) => Padding(
        padding: const EdgeInsets.only(bottom: 8.0, left: 4),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textMain)),
      );

  Widget _buildTextField(TextEditingController controller, String hint) => TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.purple.shade100)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.headerMid, width: 2)),
        ),
      );

  Widget _buildRoomDropdown() => DropdownButtonFormField<Room>(
        initialValue: _selectedRoom,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.purple.shade100)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.headerMid)),
        ),
        items: Room.values.map((room) => DropdownMenuItem(value: room, child: Text(room.label))).toList(),
        onChanged: (val) => setState(() => _selectedRoom = val!),
      );

  Widget _buildFragileToggle() => GestureDetector(
        onTap: () => setState(() => _isFragile = !_isFragile),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _isFragile ? const Color(0xFFFFF3E0) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _isFragile ? AppColors.statsOrange : Colors.purple.shade100),
          ),
          child: Row(
            children: [
              Checkbox(value: _isFragile, activeColor: AppColors.statsOrange, onChanged: (val) => setState(() => _isFragile = val!)),
              const Icon(Icons.warning_amber_rounded, color: AppColors.statsOrange, size: 20),
              const SizedBox(width: 8),
              const Text('Contenu fragile', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textMain)),
            ],
          ),
        ),
      );

  Widget _buildAddObjectButton() => GestureDetector(
        onTap: () => setState(() => _showItemForm = true),
        child: Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF4A90E2), Color(0xFF9B51E0)]),
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_circle_outline, color: Colors.white),
              SizedBox(width: 10),
              Text('Ajouter un objet', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
        ),
      );

  Widget _buildItemFormSection() => _buildCardSection([
        _buildFieldLabel("Nom de l'objet *"),
        _buildTextField(_itemNameController, 'Ex: Cafetière'),
        const SizedBox(height: 15),
        _buildFieldLabel('Description (optionnel)'),
        _buildTextField(_itemDescController, 'Ex: Rouge, Nespresso'),
        const SizedBox(height: 15),
        _buildFieldLabel('Photo (optionnel)'),
        _buildPhotoPicker(),
        const SizedBox(height: 20),
        _buildAddThisItemButton(),
      ]);

  Widget _buildPhotoPicker() => Container(
        height: 80,
        decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
        child: const Center(child: Icon(Icons.camera_alt_outlined, color: Colors.grey)),
      );

  Widget _buildAddThisItemButton() => ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.headerMid,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: () {
          if (_itemNameController.text.isNotEmpty) {
            setState(() {
              _addedItems.add(CartonItem(id: DateTime.now().toString(), cartonId: '', name: _itemNameController.text, description: _itemDescController.text));
              _itemNameController.clear(); _itemDescController.clear(); _showItemForm = false;
            });
          }
        },
        child: const Text('Ajouter cet objet au carton', style: TextStyle(color: Colors.white)),
      );

  Widget _buildAddedItemsList() => Column(
        children: [
          const SizedBox(height: 15),
          ..._addedItems.map((item) => Card(
            child: ListTile(
              leading: const Icon(Icons.check_circle, color: Colors.green),
              title: Text(item.name),
              trailing: IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => setState(() => _addedItems.remove(item))),
            ),
          )),
        ],
      );

  Widget _buildCreateCartonButton(BuildContext context) => GestureDetector(
        onTap: () {
          if (_cartonNameController.text.isNotEmpty) {
            final newCarton = Carton(
              id: DateTime.now().toString(),
              name: _cartonNameController.text,
              room: _selectedRoom,
              fragile: _isFragile,
              items: List<CartonItem>.from(_addedItems),
              createdAt: DateTime.now(),
            );
            context.read<CartonProvider>().addCarton(newCarton);
            Navigator.pop(context);
          }
        },
        child: Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(color: const Color(0xFF81D4B6), borderRadius: BorderRadius.circular(15)),
          child: const Center(child: Text('CRÉER LE CARTON', style: TextStyle(color: Color(0xFF558B76), fontWeight: FontWeight.bold, fontSize: 18))),
        ),
      );
}
