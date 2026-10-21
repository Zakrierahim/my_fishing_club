import 'package:flutter/foundation.dart';

/// Guards the prototype login action so a second tap cannot navigate twice.
class LoginController extends ChangeNotifier {
  bool _isSubmitting = false;

  bool get isSubmitting => _isSubmitting;

  /// Returns true only for the first successful login attempt.
  bool beginLogin() {
    if (_isSubmitting) {
      return false;
    }
    _isSubmitting = true;
    notifyListeners();
    return true;
  }
}
