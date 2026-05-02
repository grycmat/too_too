import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:neon/core/theme/colors.dart';

class TootContentWidget extends StatefulWidget {
  final String content;
  final String? imageUrl;
  final VoidCallback? onImageTap;
  final String? spoilerText;
  final bool sensitive;

  const TootContentWidget({
    super.key,
    required this.content,
    this.imageUrl,
    this.onImageTap,
    this.spoilerText,
    this.sensitive = false,
  });

  @override
  State<TootContentWidget> createState() => _TootContentWidgetState();
}

class _TootContentWidgetState extends State<TootContentWidget>
    with SingleTickerProviderStateMixin {
  bool _contentRevealed = false;
  bool _mediaRevealed = false;

  bool get _hasSpoiler =>
      widget.spoilerText != null && widget.spoilerText!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final showCwBar = _hasSpoiler;
    final hideContent = _hasSpoiler && !_contentRevealed;
    final hideMedia = widget.sensitive && !_mediaRevealed;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showCwBar) ...[
          _SpoilerBar(
            spoilerText: widget.spoilerText!,
            isRevealed: _contentRevealed,
            onToggle: () =>
                setState(() => _contentRevealed = !_contentRevealed),
          ),
          const SizedBox(height: 8),
        ],

        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: _HashtagRichText(text: widget.content),
          crossFadeState: hideContent
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 200),
        ),

        if (widget.imageUrl != null && !hideContent) ...[
          const SizedBox(height: 12),
          _buildMedia(hideMedia),
        ],
      ],
    );
  }

  Widget _buildMedia(bool blurred) {
    return GestureDetector(
      onTap: blurred
          ? () => setState(() => _mediaRevealed = true)
          : widget.onImageTap,
      child: Hero(
        tag: widget.imageUrl!,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              CachedNetworkImage(
                fit: BoxFit.cover,
                height: 180,
                width: double.infinity,
                imageUrl: widget.imageUrl!,
                placeholder: (_, _) => Container(
                  height: 180,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                ),
              ),

              if (blurred)
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                      child: Container(
                        color: AppColors.background.withValues(alpha: 0.5),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.visibility_off_rounded,
                              color: AppColors.warning,
                              size: 28,
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.warning.withValues(
                                  alpha: 0.15,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.warning.withValues(
                                    alpha: 0.3,
                                  ),
                                ),
                              ),
                              child: Text(
                                'SENSITIVE CONTENT — TAP TO REVEAL',
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      color: AppColors.warning,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.0,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SpoilerBar extends StatelessWidget {
  final String spoilerText;
  final bool isRevealed;
  final VoidCallback onToggle;

  const _SpoilerBar({
    required this.spoilerText,
    required this.isRevealed,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.warning.withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              spoilerText,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.warning,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onToggle,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isRevealed
                    ? AppColors.warning.withValues(alpha: 0.2)
                    : AppColors.warning.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: AppColors.warning.withValues(alpha: 0.4),
                ),
              ),
              child: Text(
                isRevealed ? 'HIDE' : 'SHOW',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.warning,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ],
      ),
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
