import 'package:flutter/material.dart';
import 'package:supermoms/app/theme/app_colors.dart';
import 'package:supermoms/shared/utils/photo_image_provider.dart';

class ItemTile extends StatelessWidget {
  const ItemTile({
    required this.title,
    super.key,
    this.subtitle,
    this.imageUrl,
    this.quantity = 1, // Valeur par défaut
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final String? imageUrl;
  final int? quantity;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final imageProvider = buildPhotoImageProvider(imageUrl);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: const Color(0xFFFDF8FF),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // IMAGE OU PLACEHOLDER AVEC BADGE QUANTITÉ
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: imageProvider == null
                        ? const LinearGradient(
                            colors: [AppColors.fabStart, AppColors.fabEnd],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    image: imageProvider != null
                        ? DecorationImage(image: imageProvider, fit: BoxFit.cover)
                        : null,
                  ),
                  child: imageProvider == null
                      ? const Icon(Icons.inventory_2_outlined, color: Colors.white, size: 28)
                      : null,
                ),
                // BADGE DE QUANTITÉ (Toujours visible en haut à droite de l'image)
                if (quantity != null && quantity! > 1)
                  Positioned(
                    right: -5,
                    top: -5,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Color(0xFF7F56D9), // Couleur violette pro
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$quantity',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            // TEXTES
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF262C35),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      subtitle?.isNotEmpty == true ? subtitle! : "Aucune description",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }
}