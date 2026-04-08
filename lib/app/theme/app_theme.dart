import 'package:flutter/material.dart';
import 'package:supermoms/app/theme/app_colors.dart';
import 'package:supermoms/app/theme/app_text_styles.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.headerMid,
          primary: AppColors.headerMid,
          secondary: AppColors.fabMid,
          surface: AppColors.white,
          error: Colors.red,
        ),
        scaffoldBackgroundColor: AppColors.bgMid,
        textTheme: const TextTheme(
          displayLarge: AppTextStyles.headerTitle,
          headlineMedium: AppTextStyles.headerSubtitle,
          titleLarge: AppTextStyles.cartonTitle,
          bodyLarge: TextStyle(color: AppColors.textMain),
          bodyMedium: TextStyle(color: AppColors.textSecondary),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.white),
        ),
        cardTheme: CardThemeData(
          color: AppColors.white,
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.fabMid,
          foregroundColor: AppColors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide.none,
          ),
        ),
      );
}
