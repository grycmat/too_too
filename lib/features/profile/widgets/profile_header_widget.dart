import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:neon/core/theme/colors.dart';
import 'package:neon/features/dashboard/models/status.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final Account account;

  const ProfileHeaderWidget({super.key, required this.account});

  String _stripHtml(String htmlString) {
    RegExp exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(exp, '').trim();
  }

  List<TextSpan> _buildBioTextSpans(BuildContext context, String text) {
    final words = text.split(' ');
    final spans = <TextSpan>[];

    for (int i = 0; i < words.length; i++) {
      final word = words[i];
      if (word.startsWith('#')) {
        spans.add(
          TextSpan(
            text: '$word ',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.secondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      } else {
        spans.add(
          TextSpan(
            text: '$word ',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
        );
      }
    }
    return spans;
  }

  @override
  Widget build(BuildContext context) {
    final String cleanBio = _stripHtml(account.note);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (account.header.isNotEmpty &&
            !account.header.endsWith('missing.png'))
          Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: CachedNetworkImageProvider(account.header),
                fit: BoxFit.cover,
              ),
            ),
          )
        else
          Container(height: 140, width: double.infinity, color: AppColors.card),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: -36,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.glowBorder, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryGlow,
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(account.avatar),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              Container(
                height: 56,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(top: 8),
                child: FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.background,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 0,
                    ),
                  ),
                  child: const Text(
                    'EDIT PROFILE',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                account.displayName.isNotEmpty
                    ? account.displayName
                    : account.username,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontSize: 22,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '@${account.acct}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.primaryVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              if (cleanBio.isNotEmpty)
                RichText(
                  text: TextSpan(
                    children: _buildBioTextSpans(context, cleanBio),
                  ),
                ),
              const SizedBox(height: 24),

              Row(
                children: [
                  _buildStat(
                    context,
                    account.statusesCount.toString(),
                    'TOOTS',
                  ),
                  const SizedBox(width: 32),
                  _buildStat(
                    context,
                    account.followingCount.toString(),
                    'FOLLOWING',
                  ),
                  const SizedBox(width: 32),
                  _buildStat(
                    context,
                    account.followersCount.toString(),
                    'FOLLOWERS',
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStat(BuildContext context, String count, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          count,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.textHint,
            letterSpacing: 1.2,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
