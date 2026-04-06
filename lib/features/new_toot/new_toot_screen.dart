import 'package:flutter/material.dart';
import 'package:too_too/core/di/service_locator.dart';
import 'package:too_too/core/theme/colors.dart';
import 'package:too_too/core/widgets/neon_card_widget.dart';
import 'package:too_too/core/widgets/status_chip_widget.dart';
import 'package:too_too/shared/service/auth_service.dart';
import 'package:too_too/shared/widgets/app_button.widget.dart';
import 'widgets/media_action_card_widget.dart';

class NewTootScreen extends StatefulWidget {
  const NewTootScreen({super.key});

  @override
  State<NewTootScreen> createState() => _NewTootScreenState();
}

class _NewTootScreenState extends State<NewTootScreen> {
  final _textController = TextEditingController();
  static const int _maxLength = 500;
  int _currentLength = 0;

  @override
  void initState() {
    super.initState();
    _textController.addListener(_updateLength);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _updateLength() {
    setState(() {
      _currentLength = _textController.text.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final authService = getIt<AuthService>();
    final instanceName = authService.instanceUrl ?? 'MASTODON';

    final textRatio = _currentLength / _maxLength;

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Instance Badge
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: colorScheme.secondary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: colorScheme.secondary.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: colorScheme.secondary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    instanceName.toUpperCase(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Compose Area
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: NeonCardWidget(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        controller: _textController,
                        maxLines: 5,
                        minLines: 3,
                        maxLength: _maxLength,
                        style: theme.textTheme.bodyMedium,
                        decoration: const InputDecoration(
                          hintText: 'Broadcast to the void...',
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
                            'STATUS: WRITING',
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
                                  text: '$_currentLength',
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                  ),
                                ),
                                TextSpan(text: '/$_maxLength'),
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
          ),

          const SizedBox(height: 24),

          // Media Grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.8,
            children: [
              MediaActionCardWidget(
                icon: Icons.camera_alt_rounded,
                label: 'Capture',
                onTap: () {},
              ),
              MediaActionCardWidget(
                icon: Icons.image_rounded,
                label: 'Gallery',
                onTap: () {},
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Bottom Chips
          Row(
            children: [
              StatusChipWidget(
                icon: Icons.public,
                label: 'PUBLIC',
                onTap: () {},
              ),
              const SizedBox(width: 12),
              StatusChipWidget(
                icon: Icons.warning_amber_rounded,
                iconColor: colorScheme.primary,
                label: 'WARNING',
                onTap: () {},
              ),
              const SizedBox(width: 12),
              StatusChipWidget(icon: Icons.language, label: 'EN', onTap: () {}),
            ],
          ),
          SizedBox(height: 24),
          AppButtonWidget(label: 'TOOT', onPressed: () {}),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}
