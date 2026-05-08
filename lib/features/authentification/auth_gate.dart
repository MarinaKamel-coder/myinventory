import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermoms/src/providers/auth_provider.dart';
import 'package:supermoms/features/authentification/login_screen.dart';
import 'package:supermoms/features/navigation/screens/main_navigation_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    // Si on est encore en train de vérifier la session initiale
    if (authProvider.isLoading && authProvider.currentUser == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Redirige selon l'état de l'authentification
    return authProvider.isAuthenticated
        ? const MainNavigationScreen()
        : const LoginScreen();
  }
}
