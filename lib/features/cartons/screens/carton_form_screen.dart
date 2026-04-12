import 'package:flutter/material.dart';
import 'package:supermoms/app/theme/app_colors.dart';
import 'package:supermoms/shared/widgets/gradient_header.dart';

class CartonFormScreen extends StatefulWidget {
  const CartonFormScreen({super.key});

  @override
  State<CartonFormScreen> createState() => _CartonFormScreenState();
}

class _CartonFormScreenState extends State<CartonFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _isFragile = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Réutilisation de ton beau Header Dégradé
            GradientHeader(
              height: 200,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Nouveau Carton',
                        style: theme.textTheme.displayLarge?.copyWith(fontSize: 28),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Informations du carton', style: theme.textTheme.titleLarge),
                    const SizedBox(height: 20),

                    // Champ Nom du Carton
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nom du carton',
                        hintText: 'Ex: Vaisselle Cuisine',
                        prefixIcon: Icon(Icons.inventory_2_outlined),
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Veuillez entrer un nom' : null,
                    ),

                    const SizedBox(height: 24),

                    // Sélecteur de Pièce (Simulé)
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Pièce de destination',
                        prefixIcon: Icon(Icons.room_outlined),
                      ),
                      items: ['Cuisine', 'Chambre 1', 'Salon', 'Garage']
                          .map((label) => DropdownMenuItem(
                                value: label,
                                child: Text(label),
                              ))
                          .toList(),
                      onChanged: (value) {},
                      hint: const Text('Choisir une pièce'),
                    ),

                    const SizedBox(height: 24),

                    // Option Fragile
                    SwitchListTile(
                      title: const Text('Carton Fragile ?'),
                      subtitle: const Text('Marquer comme fragile pour le transport'),
                      secondary: const Icon(Icons.warning_amber_rounded, color: AppColors.statsOrange),
                      value: _isFragile,
                      activeThumbColor: AppColors.headerMid,
                      onChanged: (bool value) => setState(() => _isFragile = value),
                    ),

                    const SizedBox(height: 40),

                    // Bouton Enregistrer avec ton dégradé
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: AppColors.mainGradient,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Carton enregistré !')),
                              );
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            'ENREGISTRER',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
