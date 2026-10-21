import 'package:flutter/material.dart';

import '../core/constants/app_constants.dart';
import '../core/theme/app_colors.dart';
import 'floating_bottom_nav.dart';

/// Shared page chrome for the four tab placeholders.
class AppPageScaffold extends StatelessWidget {
  const AppPageScaffold({
    super.key,
    required this.title,
    required this.headingId,
    this.body,
  });

  final String title;
  final String headingId;
  final Widget? body;

  @override
  Widget build(BuildContext context) {
    final clearance = floatingNavClearance(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth > AppConstants.contentMaxWidth
                ? AppConstants.contentMaxWidth
                : constraints.maxWidth;

            return Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: width,
                height: constraints.maxHeight,
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    AppConstants.pageHorizontalPadding,
                    16,
                    AppConstants.pageHorizontalPadding,
                    clearance,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        key: ValueKey<String>('page-heading-$headingId'),
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      if (body != null) ...[const SizedBox(height: 16), body!],
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
