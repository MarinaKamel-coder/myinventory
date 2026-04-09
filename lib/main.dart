import 'package:flutter/material.dart';
import 'package:supermoms/app/theme/app_theme.dart';
import 'package:supermoms/features/home/screens/home_screen.dart'; // Assure-toi que ce fichier existe

void main() {
  // On s'assure que les services Flutter sont bien initialisés
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyInventoryApp());
}

class MyInventoryApp extends StatelessWidget {
  const MyInventoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyInventory',
      // On désactive la petite bannière "Debug" en haut à droite
      debugShowCheckedModeBanner: false,

      // On utilise ton thème personnalisé ici !
      theme: AppTheme.lightTheme,

      // L'écran qui s'affiche au lancement
      home: const HomeScreen(),

      // Si tu as déjà configuré tes routes dans app/routes.dart, 
      // tu pourras les ajouter ici plus tard.
    );
  }
}