import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'controllers/locale_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final localeController = await LocaleController.restore();
  runApp(
    FishingApp(
      localeController: localeController,
      // Debug runs open with the fictional pond preview. Release stays empty.
      useDummyData: kDebugMode,
    ),
  );
}
