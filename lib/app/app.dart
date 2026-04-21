import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // ← AJOUT
import 'package:supermoms/app/theme/app_theme.dart';
import 'package:supermoms/features/home/screens/home_screen.dart';
import 'package:supermoms/src/providers/carton_provider.dart'; // ← AJOUT
import 'package:supermoms/src/providers/item_provider.dart'; // ← AJOUT

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ItemProvider()), 
        ChangeNotifierProvider(create: (_) => CartonProvider()), 
      ],
      child: MaterialApp(
        title: 'MyInventory',
        theme: AppTheme.lightTheme,
        home: const HomeScreen(),
      ),
    );
  }
}
