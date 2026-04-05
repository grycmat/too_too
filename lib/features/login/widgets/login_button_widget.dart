import 'package:flutter/material.dart';
import 'package:too_too/core/widgets/glow_wrapper.dart';

class LoginButtonWidget extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const LoginButtonWidget({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GlowWrapper(
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(onPressed: onPressed, child: Text(label)),
      ),
    );
  }
}
