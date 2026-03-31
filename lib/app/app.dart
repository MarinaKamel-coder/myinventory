import 'package:flutter/material.dart';
import 'package:supermoms/app/theme/app_theme.dart';
import 'package:supermoms/features/home/screens/home_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'MyInventory',
        theme: AppTheme.lightTheme,
        home: const HomeScreen(),
      );
}
