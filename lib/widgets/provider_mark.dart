import 'package:flutter/material.dart';

import '../models/auth_provider_id.dart';

/// Compact provider mark. Decorative only; the button label carries the name.
class ProviderMark extends StatelessWidget {
  const ProviderMark({super.key, required this.provider, this.size = 28});

  final AuthProviderId provider;
  final double size;

  @override
  Widget build(BuildContext context) {
    final background = switch (provider) {
      AuthProviderId.google => const Color(0xFFFFFFFF),
      AuthProviderId.facebook => const Color(0xFF1877F2),
      AuthProviderId.tiktok => const Color(0xFF111111),
      AuthProviderId.whatsapp => const Color(0xFF25D366),
    };
    final foreground = switch (provider) {
      AuthProviderId.google => const Color(0xFF4285F4),
      AuthProviderId.facebook => const Color(0xFFFFFFFF),
      AuthProviderId.tiktok => const Color(0xFFFFFFFF),
      AuthProviderId.whatsapp => const Color(0xFFFFFFFF),
    };
    final child = switch (provider) {
      AuthProviderId.google => Text(
        'G',
        style: TextStyle(
          color: foreground,
          fontSize: size * 0.58,
          fontWeight: FontWeight.w700,
          height: 1,
        ),
      ),
      AuthProviderId.facebook => Text(
        'f',
        style: TextStyle(
          color: foreground,
          fontSize: size * 0.62,
          fontWeight: FontWeight.w700,
          height: 1,
        ),
      ),
      AuthProviderId.tiktok => Icon(
        Icons.music_note_rounded,
        color: foreground,
        size: size * 0.62,
      ),
      AuthProviderId.whatsapp => Icon(
        Icons.chat_rounded,
        color: foreground,
        size: size * 0.58,
      ),
    };

    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: background, shape: BoxShape.circle),
        child: child,
      ),
    );
  }
}
