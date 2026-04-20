import 'package:flutter/material.dart';
import 'package:supermoms/app/theme/app_colors.dart';

class GradientHeader extends StatelessWidget {
  const GradientHeader({
    required this.child,
    this.height = 200.0,
    super.key,
  });

  final Widget child;
  final double height;

  @override
  Widget build(BuildContext context) => Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration( 
        gradient: AppColors.mainGradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(50), 
          bottomRight: Radius.circular(50),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
    child: child,
  );
}