import 'package:flutter/material.dart';
import 'package:too_too/core/theme/colors.dart';

class GlowWrapper extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double blurRadius;
  final double spreadRadius;
  final Color? glowColor;

  const GlowWrapper({
    super.key,
    required this.child,
    this.borderRadius = 12,
    this.blurRadius = 16,
    this.spreadRadius = 1,
    this.glowColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = glowColor ?? AppColors.primaryGlow;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: blurRadius,
            spreadRadius: spreadRadius,
          ),
          BoxShadow(
            color: color.withAlpha(40),
            blurRadius: blurRadius * 2,
            spreadRadius: spreadRadius * 4,
          ),
        ],
      ),
      child: child,
    );
  }
}
