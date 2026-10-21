import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_fishing_club/widgets/floating_bottom_nav.dart';

/// Taps [finder] on a point the floating bar is not covering.
Future<void> tapClearOfNav(WidgetTester tester, Finder finder) async {
  final scrollables = find.byType(Scrollable);
  if (scrollables.evaluate().isNotEmpty) {
    await tester.scrollUntilVisible(finder, 80, scrollable: scrollables.last);
    await tester.pumpAndSettle();
  }

  final nav = find.byType(FloatingBottomNav);
  if (nav.evaluate().isNotEmpty && scrollables.evaluate().isNotEmpty) {
    final navTop = tester.getTopLeft(nav).dy;
    final rect = tester.getRect(finder);
    if (rect.center.dy > navTop - 8) {
      await tester.drag(scrollables.last, Offset(0, navTop - rect.bottom - 24));
      await tester.pumpAndSettle();
    }
  }

  await tester.tap(finder);
  await tester.pumpAndSettle();
}
