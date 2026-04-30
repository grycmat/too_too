import 'package:flutter/material.dart';
import 'package:neon/core/theme/colors.dart';
import 'package:neon/features/profile/profile_screen.dart';

class AuthorWidget extends StatelessWidget {
  final String accountId;
  final String name;
  final String handle;
  final String? avatarUrl;
  final String timestamp;

  const AuthorWidget({
    super.key,
    required this.accountId,
    required this.name,
    required this.handle,
    this.avatarUrl,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(accountId: accountId),
          ),
        );
      },
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.glowBorder, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryGlow,
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 22,
              backgroundColor: AppColors.surface,
              backgroundImage: avatarUrl != null
                  ? NetworkImage(avatarUrl!)
                  : null,
              child: avatarUrl == null
                  ? Text(
                      name.isNotEmpty ? name[0].toUpperCase() : '?',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    )
                  : null,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: tt.titleMedium),
                const SizedBox(height: 2),
                Text(handle, style: tt.titleSmall),
              ],
            ),
          ),

          Text(timestamp, style: tt.bodySmall),
        ],
      ),
    );
  }
}
