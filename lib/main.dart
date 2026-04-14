import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:supermoms/app/theme/app_theme.dart';
import 'package:supermoms/features/cartons/screens/carton_form_screen.dart';
import 'package:supermoms/features/home/screens/home_screen.dart';
import 'package:supermoms/features/items/screens/item_add_global_screen.dart';
import 'package:supermoms/features/scanner/screens/scan_carton_screen.dart';
import 'package:supermoms/src/providers/carton_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR');
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
        home: const HomeScreen(),
        routes: {
          '/add_carton': (context) => const CartonFormScreen(),
          '/add_item': (context) => const ItemAddGlobalScreen(),
          '/scanner': (context) => const ScanCartonScreen(),
        },
      );
}
