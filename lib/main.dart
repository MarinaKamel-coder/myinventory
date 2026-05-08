import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'package:supermoms/app/theme/app_theme.dart';
import 'package:supermoms/features/authentification/auth_gate.dart';
import 'package:supermoms/features/authentification/register_screen.dart';
import 'package:supermoms/features/cartons/screens/carton_form_screen.dart';
import 'package:supermoms/features/cartons/screens/carton_list_screen.dart';
import 'package:supermoms/features/items/screens/item_add_global_screen.dart';
import 'package:supermoms/features/navigation/screens/main_navigation_screen.dart';
import 'package:supermoms/features/scanner/screens/scan_carton_screen.dart';
import 'package:supermoms/src/providers/auth_provider.dart';
import 'package:supermoms/src/providers/carton_provider.dart';
import 'package:supermoms/src/providers/item_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartonProvider()),
        ChangeNotifierProvider(create: (_) => ItemProvider()),
      ],
      child: const MyInventoryApp(),
    ),
  );
}

class MyInventoryApp extends StatelessWidget {
  const MyInventoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyInventory',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const AuthGate(),
      routes: {
        '/home': (_) => const MainNavigationScreen(),
        '/register': (_) => const RegisterScreen(),
        '/add_carton': (_) => const CartonFormScreen(),
        '/add_item': (_) => const ItemAddGlobalScreen(),
        '/scanner': (_) => const ScanCartonScreen(),
        '/all_cartons': (_) => const CartonListScreen(),
      },
    );
  }
}
