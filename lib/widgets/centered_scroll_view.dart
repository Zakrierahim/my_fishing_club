import 'package:flutter/material.dart';

import '../core/constants/app_constants.dart';

/// Centers [child] on large screens and scrolls when height is tight.
class CenteredScrollView extends StatelessWidget {
  const CenteredScrollView({
    super.key,
    required this.child,
    this.maxWidth = AppConstants.formMaxWidth,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: padding,
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    child: child,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
