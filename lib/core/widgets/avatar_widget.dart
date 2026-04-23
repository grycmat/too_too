import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:neon/core/theme/colors.dart';

class AvatarWidget extends StatelessWidget {
  final String? imageUrl;
  final String fallbackText;
  final double radius;
  final Widget? badge;
  final VoidCallback? onTap;

  const AvatarWidget({
    super.key,
    this.imageUrl,
    this.fallbackText = '',
    this.radius = 22,
    this.badge,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double size = radius * 2;

    final Widget avatar = Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.surface,
        border: Border.fromBorderSide(
          BorderSide(color: AppColors.glowBorder, width: 1.5),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGlow,
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ClipOval(child: _buildInner()),
    );

    Widget result = avatar;

    if (badge != null) {
      result = SizedBox(
        width: size + 10,
        height: size + 10,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            avatar,
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.glowBorder,
                    width: 1.2,
                  ),
                ),
                child: badge,
              ),
            ),
          ],
        ),
      );
    }

    if (onTap != null) {
      result = GestureDetector(onTap: onTap, child: result);
    }

    return result;
  }

  Widget _buildInner() {
    final bool hasImage = imageUrl != null && imageUrl!.isNotEmpty;
    if (hasImage) {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        fit: BoxFit.cover,
        placeholder: (_, _) => const ColoredBox(color: AppColors.surface),
        errorWidget: (_, _, _) => _buildFallback(),
      );
    }
    return _buildFallback();
  }

  Widget _buildFallback() {
    if (fallbackText.isEmpty) {
      return const ColoredBox(
        color: AppColors.surface,
        child: Icon(Icons.person, color: AppColors.primary),
      );
    }
    return Container(
      color: AppColors.surface,
      alignment: Alignment.center,
      child: Text(
        fallbackText.substring(0, 1).toUpperCase(),
        style: TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w700,
          fontSize: radius * 0.8,
        ),
      ),
    );
  }
}
