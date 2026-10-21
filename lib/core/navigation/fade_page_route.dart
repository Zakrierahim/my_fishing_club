import 'package:flutter/material.dart';

/// Short fade used between the prototype's top-level screens.
PageRouteBuilder<void> fadePageRoute({
  required Widget page,
  required String routeName,
}) {
  return PageRouteBuilder<void>(
    settings: RouteSettings(name: routeName),
    transitionDuration: const Duration(milliseconds: 280),
    reverseTransitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}
