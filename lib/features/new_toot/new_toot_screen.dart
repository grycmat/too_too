import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:image_picker/image_picker.dart';
import 'package:neon/core/di/service_locator.dart';
import 'package:neon/core/theme/colors.dart';
import 'package:neon/core/widgets/status_chip_widget.dart';
import 'package:neon/shared/service/auth_service.dart';
import 'package:neon/shared/service/toots_api_service.dart';
import 'package:neon/shared/widgets/app_button.widget.dart';

import 'widgets/compose_area_widget.dart';
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
  final _spoilerController = TextEditingController();
  static const int _maxLength = 500;
  static const int _spoilerMaxLength = 200;
  static const int _maxImages = 4;
  int _currentLength = 0;
  int _spoilerLength = 0;
  final List<File> _selectedImages = [];
  bool _isPosting = false;
  bool _showSpoiler = false;
  bool _isSensitive = false;

  @override
  void initState() {
    super.initState();
    _textController.addListener(_updateLength);
    _spoilerController.addListener(_updateSpoilerLength);
  }

  @override
  void dispose() {
    _textController.dispose();
    _spoilerController.dispose();
    super.dispose();
  }

  void _updateLength() {
    setState(() {
      _currentLength = _textController.text.length;
    });
  }

  void _updateSpoilerLength() {
    setState(() {
      _spoilerLength = _spoilerController.text.length;
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

      final List<String> mediaIds = [];
      for (final image in _selectedImages) {
        final id = await tootsApi.uploadMedia(image);
        print(id);
        mediaIds.add(id);
      }

      await tootsApi.postStatus(
        status: text,
        mediaIds: mediaIds.isNotEmpty ? mediaIds : null,
        spoilerText: _showSpoiler ? _spoilerController.text.trim() : null,
        sensitive: _isSensitive,
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

              AnimatedSize(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                alignment: Alignment.topCenter,
                child: _showSpoiler
                    ? Column(
                        children: [
                          ComposeAreaWidget(
                            controller: _spoilerController,
                            currentLength: _spoilerLength,
                            maxLength: _spoilerMaxLength,
                            enabled: !_isPosting,
                            hintText: 'Write a spoiler warning...',
                            statusLabel: 'SPOILER WARNING',
                            maxLines: 3,
                            minLines: 3,
                          ),
                          const SizedBox(height: 16),
                        ],
                      )
                    : const SizedBox.shrink(),
              ),

              ComposeAreaWidget(
                controller: _textController,
                currentLength: _currentLength,
                maxLength: _maxLength,
                enabled: !_isPosting,
              ),

              const SizedBox(height: 24),

              if (_selectedImages.isNotEmpty) ...[
                ImagePreviewGridWidget(
                  images: _selectedImages,
                  onRemove: _isPosting ? (_) {} : _removeImage,
                ),
                const SizedBox(height: 16),
              ],

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

              Row(
                children: [
                  StatusChipWidget(
                    icon: Icons.warning_amber_rounded,
                    isActive: _isSensitive,
                    label: 'SENSITIVE',
                    onTap: () {
                      setState(() => _isSensitive = !_isSensitive);
                    },
                  ),
                  const SizedBox(width: 12),
                  StatusChipWidget(
                    icon: Icons.visibility_off,
                    label: 'SPOILER',
                    isActive: _showSpoiler,
                    onTap: () {
                      setState(() => _showSpoiler = !_showSpoiler);
                    },
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
