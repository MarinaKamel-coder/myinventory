// ignore_for_file: prefer_expression_function_bodies

import 'package:flutter/material.dart';
import 'package:supermoms/features/cartons/screens/carton_list_screen.dart';
import 'package:supermoms/features/cartons/screens/carton_detail_screen.dart';
import 'package:supermoms/features/home/screens/home_screen.dart';
import 'package:supermoms/features/users/screens/users_screen.dart';
import 'package:supermoms/src/models/carton.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  // Cette méthode permet à HomeScreen d'accéder aux fonctions de navigation
  static MainNavigationScreenState? of(BuildContext context) =>
      context.findAncestorStateOfType<MainNavigationScreenState>();

  @override
  State<MainNavigationScreen> createState() => MainNavigationScreenState();
}

// NOTE: La classe est publique (pas de _) pour être accessible par .of(context)
class MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  
  // Clé pour contrôler le Navigator interne de l'onglet Cartons
  final GlobalKey<NavigatorState> _cartonsNavKey = GlobalKey<NavigatorState>();

  /// Fonction pour naviguer vers un carton depuis n'importe où
  void navigateToCartonDetail(Carton box) {
    // 1. On bascule sur l'onglet "Cartons" (index 1)
    setState(() => _currentIndex = 1);
    
    // 2. On attend que l'onglet soit affiché pour pousser l'écran de détail
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_cartonsNavKey.currentState != null) {
        _cartonsNavKey.currentState!.push(
          MaterialPageRoute(
            builder: (context) => CartonDetailScreen(box: box),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Définition des pages ici pour que _cartonsNavKey soit bien lié
    final List<Widget> pages = [
      const HomeScreen(),
      Navigator(
        key: _cartonsNavKey,
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => const CartonListScreen(),
          );
        },
      ),
      const UsersScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          // Si on reclique sur l'onglet Cartons alors qu'on est déjà dedans,
          // on revient à la liste racine (popUntil).
          if (index == 1 && _currentIndex == 1) {
            _cartonsNavKey.currentState?.popUntil((route) => route.isFirst);
          }
          setState(() => _currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), label: 'Cartons'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profil'),
        ],
      ),
    );
  }
}