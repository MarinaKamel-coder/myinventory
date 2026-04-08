import 'package:flutter/material.dart';
import 'package:supermoms/app/theme/app_colors.dart';

class AppTextStyles {
  // Le gros titre du Header
  static const TextStyle headerTitle = TextStyle(
    fontSize: 45.0,
    fontWeight: FontWeight.w900,
    color: AppColors.white,
    letterSpacing: -1.0,
  );

  // Sous-titre du Header
  static const TextStyle headerSubtitle = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w500,
    color: Color(0xFFE0E7FF),
  );

  // Titre des Cartons
  static const TextStyle cartonTitle = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textMain,
  );
}
