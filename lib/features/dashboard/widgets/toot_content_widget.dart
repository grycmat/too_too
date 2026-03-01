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
        // ── Body text with highlighted hashtags ─────────────────
        _HashtagRichText(text: content),

        // ── Optional image ─────────────────────────────────────
        if (imageUrl != null) ...[
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl!,
              width: double.infinity,
              height: 180,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Container(
                  height: 180,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                    value: progress.expectedTotalBytes != null
                        ? progress.cumulativeBytesLoaded /
                              progress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
              errorBuilder: (context, error, stack) => Container(
                height: 180,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Icon(
                  Icons.broken_image_outlined,
                  color: AppColors.textHint,
                  size: 40,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// Renders text with `#hashtags` in [AppColors.textHashtag].
class _HashtagRichText extends StatelessWidget {
  final String text;
  const _HashtagRichText({required this.text});

  static final _hashtagRegex = RegExp(r'#\w+');

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyMedium!;
    final hashtagStyle = style.copyWith(
      color: AppColors.textHashtag,
      fontWeight: FontWeight.w600,
    );

    final spans = <TextSpan>[];
    int lastEnd = 0;

    for (final match in _hashtagRegex.allMatches(text)) {
      if (match.start > lastEnd) {
        spans.add(TextSpan(text: text.substring(lastEnd, match.start)));
      }
      spans.add(TextSpan(text: match.group(0), style: hashtagStyle));
      lastEnd = match.end;
    }

    if (lastEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastEnd)));
    }

    return RichText(
      text: TextSpan(style: style, children: spans),
    );
  }
}
