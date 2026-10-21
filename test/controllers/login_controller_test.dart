import 'package:flutter_test/flutter_test.dart';
import 'package:my_fishing_club/controllers/login_controller.dart';

void main() {
  test('beginLogin proceeds once and ignores duplicate calls', () {
    final controller = LoginController();
    var notifications = 0;
    controller.addListener(() => notifications++);

    expect(controller.isSubmitting, isFalse);
    expect(controller.beginLogin(), isTrue);
    expect(controller.isSubmitting, isTrue);
    expect(controller.beginLogin(), isFalse);
    expect(notifications, 1);

    controller.dispose();
  });
}
