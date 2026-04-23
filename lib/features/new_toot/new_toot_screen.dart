import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:image_picker/image_picker.dart';
import 'package:neon/core/di/service_locator.dart';
import 'package:neon/core/theme/colors.dart';
import 'package:neon/core/widgets/neon_card_widget.dart';
import 'package:neon/core/widgets/status_chip_widget.dart';
import 'package:neon/shared/service/auth_service.dart';
import 'package:neon/shared/service/toots_api_service.dart';
import 'package:neon/shared/widgets/app_button.widget.dart';

import 'widgets/image_preview_grid_widget.dart';
import 'widgets/media_action_card_widget.dart';

class NewTootScreen extends StatefulWidget {
  @Preview(name: 'New Toot Screen')
  const NewTootScreen({super.key});

  @override
  State<NewTootScreen> createState() => _NewTootScreenState();
}

class _NewTootScreenState extends State<NewTootScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  final _textController = TextEditingController();
  static const int _maxLength = 500;
  static const int _maxImages = 4;
  int _currentLength = 0;
  final List<File> _selectedImages = [];
  bool _isPosting = false;

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

  Future<void> _pickImage() async {
    if (_selectedImages.length >= _maxImages) return;

    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      setState(() {
        _selectedImages.add(File(image.path));
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _postToot() async {
    final text = _textController.text.trim();
    if (text.isEmpty && _selectedImages.isEmpty) {
      _showError('Write something or add an image to post.');
      return;
    }

    setState(() => _isPosting = true);

    try {
      final tootsApi = getIt<TootsApiService>();

      // Upload media attachments first
      final List<String> mediaIds = [];
      for (final image in _selectedImages) {
        final id = await tootsApi.uploadMedia(image);
        print(id);
        mediaIds.add(id);
      }

      // Post the status
      await tootsApi.postStatus(
        status: text,
        mediaIds: mediaIds.isNotEmpty ? mediaIds : null,
      );

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Toot posted successfully!'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data?['error'] as String? ?? 'Failed to post toot.';
      _showError(errorMessage);
      print(e.toString());
    } catch (e) {
      _showError('An unexpected error occurred.');
      print(e.toString());
    } finally {
      if (mounted) {
        setState(() => _isPosting = false);
      }
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final authService = getIt<AuthService>();
    final instanceName = authService.instanceUrl ?? 'MASTODON';

    final textRatio = _currentLength / _maxLength;

    return Stack(
      children: [
        SingleChildScrollView(
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
                alignment: Alignment.topLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
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
                            maxLines: 7,
                            minLines: 7,
                            maxLength: _maxLength,
                            enabled: !_isPosting,
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

              // Image Preview Grid
              if (_selectedImages.isNotEmpty) ...[
                ImagePreviewGridWidget(
                  images: _selectedImages,
                  onRemove: _isPosting ? (_) {} : _removeImage,
                ),
                const SizedBox(height: 16),
              ],

              // Media Grid
              if (_selectedImages.length < _maxImages && !_isPosting)
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.8,
                  children: [
                    MediaActionCardWidget(
                      icon: Icons.image_rounded,
                      label: 'Gallery',
                      onTap: _pickImage,
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
                  StatusChipWidget(
                    icon: Icons.language,
                    label: 'EN',
                    onTap: () {},
                  ),
                ],
              ),
              SizedBox(height: 24),
              AppButtonWidget(
                label: 'TOOT',
                onPressed: _isPosting ? null : _postToot,
              ),
              SizedBox(height: 24),
            ],
          ),
        ),

        // Loading overlay
        if (_isPosting)
          Positioned.fill(
            child: Container(
              color: AppColors.background.withValues(alpha: 0.7),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 48,
                      height: 48,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'BROADCASTING...',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: AppColors.primary,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
