import 'package:flutter/material.dart';
import 'package:supermoms/app/theme/app_colors.dart';
import 'package:supermoms/shared/utils/photo_image_provider.dart';

class ItemTile extends StatelessWidget {
  const ItemTile({
    required this.title,
    super.key,
    this.subtitle,
    this.imageUrl,
    this.quantity,
  });

  final String title;
  final String? subtitle;
  final String? imageUrl;
  final int? quantity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final imageProvider = buildPhotoImageProvider(imageUrl);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF8FF), // Fond très clair comme sur l'image
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // ÉLÉMENT DE GAUCHE (Image ou Dégradé avec Nombre)
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
              // Dégradé si pas d'image
              gradient: imageProvider == null
                  ? const LinearGradient(
                      colors: [AppColors.fabStart, AppColors.fabEnd],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              image: imageProvider != null
                  ? DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: imageProvider == null && quantity != null
                ? Center(
                    child: Text(
                      '$quantity',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 16),
          
          // TEXTES (Titre et Sous-titre dans sa bulle)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontSize: 18,
                    color: const Color(0xFF262C35),
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      subtitle!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
