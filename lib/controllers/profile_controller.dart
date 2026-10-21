import 'package:flutter/foundation.dart';

/// Local display name only. Email and phone are never invented.
class ProfileController extends ChangeNotifier {
  String? _displayName;

  String? get displayName {
    final name = _displayName?.trim();
    if (name == null || name.isEmpty) {
      return null;
    }
    return name;
  }

  void setDisplayName(String value) {
    final next = value.trim();
    if (next == (displayName ?? '')) {
      return;
    }
    _displayName = next;
    notifyListeners();
  }
}
