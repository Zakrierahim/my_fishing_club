import 'package:flutter/foundation.dart';

import '../core/auth/auth_gateway.dart';
import '../models/auth_outcome.dart';
import '../models/auth_provider_id.dart';
import '../models/linked_account.dart';
import 'auth_controller.dart';

/// Loads and changes provider links for the signed-in application user.
///
/// Connected status is copied only from service-confirmed [LinkedAccount]s.
class LinkedAccountsController extends ChangeNotifier {
  LinkedAccountsController({
    required AuthGateway gateway,
    required AuthController auth,
  }) : _gateway = gateway,
       _auth = auth {
    _accounts = _noneConnected();
    _auth.addListener(_handleAuth);
    _handleAuth();
  }

  final AuthGateway _gateway;
  final AuthController _auth;

  late Map<AuthProviderId, LinkedAccount> _accounts;
  String? _observedUserId;
  AuthProviderId? _busyProvider;
  AuthFailureReason? _failure;
  int _requestGeneration = 0;

  AuthProviderId? get busyProvider => _busyProvider;

  AuthFailureReason? get failure => _failure;

  int get connectedCount =>
      _accounts.values.where((account) => account.connected).length;

  LinkedAccount account(AuthProviderId provider) => _accounts[provider]!;

  bool isBusyWith(AuthProviderId provider) => _busyProvider == provider;

  Future<void> load() async {
    final userId = _auth.appUserId;
    if (userId == null) {
      _resetDisconnected();
      notifyListeners();
      return;
    }

    final generation = ++_requestGeneration;
    List<LinkedAccount> reported;
    try {
      reported = await _gateway.loadLinkedAccounts(appUserId: userId);
    } catch (_) {
      if (_auth.appUserId != userId || generation != _requestGeneration) {
        return;
      }
      _failure = AuthFailureReason.failed;
      notifyListeners();
      return;
    }

    if (_auth.appUserId != userId || generation != _requestGeneration) {
      return;
    }
    _replaceFromService(reported);
    notifyListeners();
  }

  Future<void> link(AuthProviderId provider) async {
    if (_busyProvider != null) {
      return;
    }
    final userId = _auth.appUserId;
    if (userId == null) {
      _failure = AuthFailureReason.configurationRequired;
      notifyListeners();
      return;
    }

    final generation = ++_requestGeneration;
    _busyProvider = provider;
    _failure = null;
    notifyListeners();

    AuthOutcome outcome;
    try {
      outcome = await _gateway.link(provider: provider, appUserId: userId);
    } catch (_) {
      outcome = const AuthOutcome.failed();
    }

    if (_auth.appUserId != userId || generation != _requestGeneration) {
      _busyProvider = null;
      notifyListeners();
      return;
    }

    if (outcome.hasConfirmedLink) {
      _accounts[provider] = LinkedAccount(
        provider: provider,
        confirmedByService: true,
        providerSubject: outcome.providerSubject!.trim(),
      );
      _failure = null;
    } else {
      _failure = outcome.failure ?? AuthFailureReason.configurationRequired;
    }

    _busyProvider = null;
    notifyListeners();
  }

  /// Removes a confirmed link. [confirmed] must be true after the user accepts
  /// the dialog. The last remaining sign-in method is left in place.
  Future<void> unlink(
    AuthProviderId provider, {
    required bool confirmed,
  }) async {
    if (!confirmed || _busyProvider != null) {
      return;
    }
    final current = _accounts[provider];
    if (current == null || !current.connected) {
      return;
    }
    if (connectedCount <= 1) {
      _failure = AuthFailureReason.lastSignInMethod;
      notifyListeners();
      return;
    }

    final userId = _auth.appUserId;
    if (userId == null) {
      _failure = AuthFailureReason.configurationRequired;
      notifyListeners();
      return;
    }

    final generation = ++_requestGeneration;
    _busyProvider = provider;
    _failure = null;
    notifyListeners();

    AuthOutcome outcome;
    try {
      outcome = await _gateway.unlink(provider: provider, appUserId: userId);
    } catch (_) {
      outcome = const AuthOutcome.failed();
    }

    if (_auth.appUserId != userId || generation != _requestGeneration) {
      _busyProvider = null;
      notifyListeners();
      return;
    }

    if (outcome.unlinkConfirmed) {
      _accounts[provider] = LinkedAccount.disconnected(provider);
      _failure = null;
    } else {
      _failure = outcome.failure ?? AuthFailureReason.failed;
    }

    _busyProvider = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _auth.removeListener(_handleAuth);
    super.dispose();
  }

  void _handleAuth() {
    final userId = _auth.appUserId;
    if (userId == _observedUserId) {
      return;
    }
    _observedUserId = userId;
    if (userId == null) {
      _resetDisconnected();
      _failure = null;
      _busyProvider = null;
      notifyListeners();
      return;
    }
    load();
  }

  void _replaceFromService(List<LinkedAccount> reported) {
    final next = _noneConnected();
    for (final account in reported) {
      if (account.connected) {
        next[account.provider] = account;
      }
    }
    _accounts = next;
  }

  void _resetDisconnected() {
    _accounts = _noneConnected();
  }

  Map<AuthProviderId, LinkedAccount> _noneConnected() {
    return <AuthProviderId, LinkedAccount>{
      for (final provider in AuthProviderId.values)
        provider: LinkedAccount.disconnected(provider),
    };
  }
}
