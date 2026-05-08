import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermoms/app/theme/app_theme.dart';
import 'package:supermoms/src/providers/auth_provider.dart';
import 'package:supermoms/src/providers/carton_provider.dart';
import 'package:supermoms/src/providers/item_provider.dart';
import 'package:supermoms/src/providers/user_provider.dart';

import 'package:supermoms/features/authentification/auth_gate.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ItemProvider()), 
        ChangeNotifierProvider(create: (_) => CartonProvider()), 
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: 'MyInventory',
        theme: AppTheme.lightTheme,
        home: const AuthGate(),
      ),
    );
  }
}
