import 'package:flutter/foundation.dart';

import '../core/constants/app_tab.dart';

/// Owns the selected bottom-navigation destination.
class MainController extends ChangeNotifier {
  int _selectedIndex = AppTab.home.index;

  int get selectedIndex => _selectedIndex;

  bool isSelected(AppTab tab) => tab.index == _selectedIndex;

  void selectTab(AppTab tab) {
    if (tab.index == _selectedIndex) {
      return;
    }
    _selectedIndex = tab.index;
    notifyListeners();
  }
}
