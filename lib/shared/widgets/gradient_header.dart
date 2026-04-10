import 'package:flutter/material.dart';
import 'package:supermoms/app/theme/app_colors.dart';

class GradientHeader extends StatelessWidget {
  const GradientHeader({
    required this.child,
    this.height = 250.0,
    super.key,
  });

  final Widget child;
  final double height;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        height: height,
        decoration: const BoxDecoration(
          gradient: AppColors.mainGradient,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(40),
          ),
        ),
        child: child,
      );
}
