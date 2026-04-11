import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:too_too/core/theme/colors.dart';

class TootContentWidget extends StatelessWidget {
  final String content;
  final String? imageUrl;

  const TootContentWidget({super.key, required this.content, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _HashtagRichText(text: content),

        if (imageUrl != null) ...[
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              height: 180,
              width: double.infinity,
              imageUrl: imageUrl!,
              placeholder: (_, _) => Container(
                height: 180,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _HashtagRichText extends StatelessWidget {
  final String text;
  const _HashtagRichText({required this.text});

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyMedium!;
    final hashtagStyle = style.copyWith(
      color: AppColors.textHashtag,
      fontWeight: FontWeight.w600,
    );
    final mentionStyle = style.copyWith(
      color: AppColors.secondary,
      fontWeight: FontWeight.w600,
    );

    final spans = <TextSpan>[];
    final splits = text.split(' ');

    for (final split in splits) {
      if (split.startsWith('@')) {
        spans.add(TextSpan(text: split, style: mentionStyle));
        spans.add(TextSpan(text: ' ', style: style));

        continue;
      }
      if (split.startsWith('#')) {
        spans.add(TextSpan(text: split, style: hashtagStyle));
        spans.add(TextSpan(text: ' ', style: style));

        continue;
      }
      spans.add(TextSpan(text: split, style: style));
      spans.add(TextSpan(text: ' ', style: style));
    }

    return RichText(
      text: TextSpan(style: style, children: spans),
    );
  }
}
