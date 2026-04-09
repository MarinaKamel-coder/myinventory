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
  // Le style pour les chiffres des statistiques (Ex: "12 cartons")
  static const TextStyle statsNumber = TextStyle(
    fontSize: 26.0,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  // Utilisé pour les labels secondaires
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12.0,
    color: AppColors.textSecondary,
  );

  // Titre de section "Derniers cartons"
  static const TextStyle cardTitle = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textMain,
  );

}
