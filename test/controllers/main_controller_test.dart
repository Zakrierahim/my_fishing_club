import 'package:flutter_test/flutter_test.dart';
import 'package:my_fishing_club/controllers/main_controller.dart';
import 'package:my_fishing_club/core/constants/app_tab.dart';

void main() {
  test('starts on Home and updates only when the tab changes', () {
    final controller = MainController();
    var notifications = 0;
    controller.addListener(() => notifications++);

    expect(controller.selectedIndex, AppTab.home.index);
    expect(controller.isSelected(AppTab.home), isTrue);

    controller.selectTab(AppTab.home);
    expect(notifications, 0);

    controller.selectTab(AppTab.notification);
    expect(controller.selectedIndex, AppTab.notification.index);
    expect(controller.isSelected(AppTab.notification), isTrue);
    expect(controller.isSelected(AppTab.home), isFalse);
    expect(notifications, 1);

    controller.dispose();
  });
}
