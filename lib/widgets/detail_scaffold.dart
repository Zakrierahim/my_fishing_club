import 'package:flutter/material.dart';

import '../core/constants/app_constants.dart';
import '../core/theme/app_colors.dart';

/// Pushed screen with a back button and the shared content width.
class DetailScaffold extends StatelessWidget {
  const DetailScaffold({
    super.key,
    required this.title,
    required this.body,
    this.titleKey,
    this.actions,
  });

  final String title;
  final Key? titleKey;
  final Widget body;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          title,
          key: titleKey,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: actions,
      ),
      body: SafeArea(
        top: false,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppConstants.contentMaxWidth,
            ),
            child: body,
          ),
        ),
      ),
    );
  }
}
