import 'package:flutter/foundation.dart';

import '../core/auth/auth_gateway.dart';
import '../models/auth_outcome.dart';
import '../models/auth_provider_id.dart';

/// Coordinates provider sign-in. A session exists only when [AuthGateway]
/// reports one created by the application backend.
class AuthController extends ChangeNotifier {
  AuthController({required AuthGateway gateway}) : _gateway = gateway;

  final AuthGateway _gateway;

  AuthProviderId? _busyProvider;
  AuthFailureReason? _failure;
  String? _appUserId;

  AuthProviderId? get busyProvider => _busyProvider;

  bool get isBusy => _busyProvider != null;

  AuthFailureReason? get failure => _failure;

  /// Application user id from the session backend. Null when signed out.
  String? get appUserId => _appUserId;

  bool get whatsappOtpConfigured => _gateway.whatsappOtpConfigured;

  bool isBusyWith(AuthProviderId provider) => _busyProvider == provider;

  /// Starts provider sign-in. A second call while one is running is ignored.
  Future<AuthAttempt> signIn(AuthProviderId provider) {
    return _run(provider, () => _gateway.signIn(provider));
  }

  Future<AuthAttempt> startWhatsAppVerification(String phoneNumber) {
    final phone = phoneNumber.trim();
    if (phone.isEmpty) {
      return _rejectEmpty();
    }
    if (!_gateway.whatsappOtpConfigured) {
      return _rejectUnconfigured();
    }
    return _run(
      AuthProviderId.whatsapp,
      () => _gateway.startWhatsAppVerification(phone),
    );
  }

  Future<AuthAttempt> submitVerificationCode(String code) {
    final value = code.trim();
    if (value.isEmpty) {
      return _rejectEmpty();
    }
    if (!_gateway.whatsappOtpConfigured) {
      return _rejectUnconfigured();
    }
    return _run(
      AuthProviderId.whatsapp,
      () => _gateway.submitVerificationCode(value),
    );
  }

  Future<AuthAttempt> resendVerificationCode() {
    if (!_gateway.whatsappOtpConfigured) {
      return _rejectUnconfigured();
    }
    return _run(
      AuthProviderId.whatsapp,
      () => _gateway.resendVerificationCode(),
    );
  }

  void clearFailure() {
    if (_failure == null) {
      return;
    }
    _failure = null;
    notifyListeners();
  }

  void signOut() {
    if (_appUserId == null && _failure == null) {
      return;
    }
    _appUserId = null;
    _failure = null;
    notifyListeners();
  }

  Future<AuthAttempt> _rejectEmpty() async {
    _failure = AuthFailureReason.failed;
    notifyListeners();
    return AuthAttempt.finished(const AuthOutcome.failed());
  }

  Future<AuthAttempt> _rejectUnconfigured() async {
    _failure = AuthFailureReason.configurationRequired;
    notifyListeners();
    return AuthAttempt.finished(const AuthOutcome.configurationRequired());
  }

  Future<AuthAttempt> _run(
    AuthProviderId provider,
    Future<AuthOutcome> Function() action,
  ) async {
    if (_busyProvider != null) {
      return const AuthAttempt.ignored();
    }
    _busyProvider = provider;
    _failure = null;
    notifyListeners();

    AuthOutcome outcome;
    try {
      outcome = await action();
    } catch (_) {
      outcome = const AuthOutcome.failed();
    }

    if (outcome.hasSession) {
      _appUserId = outcome.appUserId!.trim();
      _failure = null;
    } else if (outcome.otpChallengeIssued && outcome.failure == null) {
      _failure = null;
    } else {
      _failure = outcome.failure ?? AuthFailureReason.failed;
    }

    _busyProvider = null;
    notifyListeners();
    return AuthAttempt.finished(outcome);
  }
}

class AuthAttempt {
  const AuthAttempt.ignored() : ignored = true, outcome = null;

  const AuthAttempt.finished(this.outcome) : ignored = false;

  final bool ignored;
  final AuthOutcome? outcome;
}
