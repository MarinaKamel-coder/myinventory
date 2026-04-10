import 'package:flutter/material.dart';

class AppColors {
  // Dégradé du Header (Indigo -> Purple -> Pink)
  static const Color headerStart = Color(0xFF565CF2); 
  static const Color headerMid   = Color(0xFF9249EB);
  static const Color headerEnd   = Color(0xFFE8179B);

  // Couleurs de fond (Très claires)
  static const Color bgStart = Color(0xFFDEE6FF); 
  static const Color bgMid   = Color(0xFFFAF0FF);
  static const Color bgEnd   = Color(0xFFFFD5EA); 

  // Boutons et FAB
  static const Color fabStart = Color(0xFF9249EB); 
  static const Color fabMid   = Color(0xFFE8179B); 
  static const Color fabEnd   = Color(0xFFF51D31); 

  // Stats et Feedback
  static const Color statsBlue   = Color(0xFF348FF9);
  static const Color statsOrange = Color(0xFFF3821D);
  static const Color success     = Color(0xFF11BC6D); 

  // Texte et Neutres
  static const Color textMain      = Color(0xFF262C35);
  static const Color textSecondary = Color(0xFF6E7581);
  static const Color surface       = Color(0xFFEBEFF5); 
  static const Color white         = Colors.white;

  // Dégradé principal réutilisable
  static const LinearGradient mainGradient = LinearGradient(
    colors: [headerStart, headerMid, headerEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
