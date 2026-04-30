import 'package:flutter/material.dart';
import 'package:neon/core/theme/colors.dart';
import 'package:neon/core/widgets/neon_card_widget.dart';

class ComposeAreaWidget extends StatelessWidget {
  final TextEditingController controller;
  final int currentLength;
  final int maxLength;
  final bool enabled;
  final String hintText;
  final String statusLabel;
  final int maxLines;
  final int minLines;

  const ComposeAreaWidget({
    super.key,
    required this.controller,
    required this.currentLength,
    this.maxLength = 500,
    this.enabled = true,
    this.hintText = 'Broadcast to the void...',
    this.statusLabel = 'STATUS: WRITING',
    this.maxLines = 7,
    this.minLines = 7,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textRatio = currentLength / maxLength;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: NeonCardWidget(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: controller,
                  maxLines: maxLines,
                  minLines: minLines,
                  maxLength: maxLength,
                  enabled: enabled,
                  style: theme.textTheme.bodyMedium,
                  decoration: InputDecoration(
                    hintText: hintText,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    counterText: '',
                    contentPadding: EdgeInsets.zero,
                    filled: false,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      statusLabel,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.primaryVariant,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: textRatio,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 16),
                    RichText(
                      text: TextSpan(
                        style: theme.textTheme.labelMedium,
                        children: [
                          TextSpan(
                            text: '$currentLength',
                            style: const TextStyle(color: AppColors.primary),
                          ),
                          TextSpan(text: '/$maxLength'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
