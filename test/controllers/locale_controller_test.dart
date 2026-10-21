import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_fishing_club/controllers/locale_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('restores English when no language has been saved', () async {
    final controller = await LocaleController.restore();

    expect(controller.locale, LocaleController.english);
    controller.dispose();
  });

  test('saves a language change and restores it', () async {
    final controller = await LocaleController.restore();
    var notifications = 0;
    controller.addListener(() => notifications++);

    await controller.setLocale(const Locale('en'));
    expect(notifications, 0);

    await controller.setLocale(const Locale('fr'));
    expect(controller.locale.languageCode, 'en');
    expect(notifications, 0);

    await controller.setLocale(LocaleController.malay);
    expect(controller.locale, LocaleController.malay);
    expect(notifications, 1);

    final restored = await LocaleController.restore();
    expect(restored.locale.languageCode, 'ms');

    await restored.setLocale(LocaleController.english);
    final englishAgain = await LocaleController.restore();
    expect(englishAgain.locale.languageCode, 'en');

    controller.dispose();
    restored.dispose();
    englishAgain.dispose();
  });
}
