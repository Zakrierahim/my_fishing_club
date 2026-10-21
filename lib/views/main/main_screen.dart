import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/main_controller.dart';
import '../../core/constants/app_tab.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/floating_bottom_nav.dart';
import '../explore/explore_screen.dart';
import '../home/home_screen.dart';
import '../notification/notification_screen.dart';
import '../settings/settings_screen.dart';

const List<Widget> _tabPages = <Widget>[
  HomeScreen(),
  ExploreScreen(),
  NotificationScreen(),
  SettingsScreen(),
];

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    assert(_tabPages.length == AppTab.values.length);
    final selectedIndex = context.watch<MainController>().selectedIndex;

    return PopScope(
      canPop: selectedIndex == AppTab.home.index,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          return;
        }
        context.read<MainController>().selectTab(AppTab.home);
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          fit: StackFit.expand,
          children: [
            IndexedStack(index: selectedIndex, children: _tabPages),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: FloatingBottomNav(selectedIndex: selectedIndex),
            ),
          ],
        ),
      ),
    );
  }
}
