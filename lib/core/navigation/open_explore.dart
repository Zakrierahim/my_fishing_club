import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/main_controller.dart';
import '../constants/app_tab.dart';
import 'fade_page_route.dart';

void pushAppPage(BuildContext context, Widget page, String routeName) {
  Navigator.of(context).push(fadePageRoute(page: page, routeName: routeName));
}

/// Selects Explore and returns to the main shell if a page is covering it.
void showExploreTab(BuildContext context) {
  context.read<MainController>().selectTab(AppTab.explore);
  Navigator.of(context).popUntil((route) => route.isFirst);
}
