import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:go_router/go_router.dart';
import 'package:neon/core/di/service_locator.dart';
import 'package:neon/core/widgets/app_text_field.dart';
import 'package:neon/core/widgets/glow_wrapper.dart';
import 'package:neon/shared/service/auth_service.dart';
import 'package:neon/shared/widgets/app_button.widget.dart';
import 'package:neon/shared/widgets/link_button.widget.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  @Preview(name: 'Login Screen')
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _instanceController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _instanceController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final instance = _instanceController.text.trim();
    if (instance.isEmpty) {
      setState(() => _error = 'Please enter an instance URL');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final authService = getIt<AuthService>();
      await authService.login(instance);

      if (mounted) {
        context.go('/');
      }
    } on Exception catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString().replaceAll('Exception: ', '');
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 16),

                GlowWrapper(
                  borderRadius: 50,
                  child: Icon(
                    Icons.hub_rounded,
                    size: 100,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),

                Text('NEON', style: theme.textTheme.headlineMedium),
                const SizedBox(height: 4),

                Text(
                  'DECENTRALIZED NETWORK',
                  style: theme.textTheme.labelSmall,
                ),

                const SizedBox(height: 48),

                AppTextField(
                  label: 'INSTANCE URL',
                  hintText: 'mastodon.social',
                  controller: _instanceController,
                  keyboardType: TextInputType.url,
                ),

                if (_error != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: colorScheme.error.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: colorScheme.error,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _error!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 32),

                _isLoading
                    ? Column(
                        children: [
                          SizedBox(
                            width: 32,
                            height: 32,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Waiting for authorization...',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () => setState(() => _isLoading = false),
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: colorScheme.error),
                            ),
                          ),
                        ],
                      )
                    : AppButtonWidget(label: 'LOGIN', onPressed: _handleLogin),

                const SizedBox(height: 24),

                LinkButtonWidget(
                  label: 'What is Mastodon?',
                  onPressed: () async {
                    final url = Uri.parse('https://joinmastodon.org/');
                    if (!await launchUrl(
                      url,
                      mode: LaunchMode.externalApplication,
                    )) {
                      debugPrint('Could not launch $url');
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
