import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermoms/app/theme/app_theme.dart';
import 'package:supermoms/features/cartons/screens/carton_form_screen.dart';
import 'package:supermoms/features/home/screens/home_screen.dart';
import 'package:supermoms/features/scanner/screens/scan_carton_screen.dart';
import 'package:supermoms/src/provider/carton_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartonProvider(),
      child: const MyInventoryApp(),
    ),
  );
}

class MyInventoryApp extends StatelessWidget {
  const MyInventoryApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'MyInventory',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,

        // Route initiale
        home: const HomeScreen(),

        // Définition des routes pour la navigation
        routes: {
          '/add_carton': (context) => const CartonFormScreen(),
          '/scanner': (context) => const ScanCartonScreen(),
        },
      );
}
