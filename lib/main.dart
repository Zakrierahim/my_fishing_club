import 'package:flutter/material.dart';

import 'app.dart';
import 'controllers/locale_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final localeController = await LocaleController.restore();
  runApp(FishingApp(localeController: localeController));
}
