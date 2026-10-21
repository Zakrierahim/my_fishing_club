import 'package:flutter/foundation.dart';

import '../models/pond_membership.dart';

/// Pond memberships for the angler. The shipped app starts with an empty list.
class MembershipController extends ChangeNotifier {
  MembershipController({
    Iterable<PondMembership> memberships = const <PondMembership>[],
  }) : _memberships = List<PondMembership>.unmodifiable(memberships);

  List<PondMembership> _memberships;

  List<PondMembership> get memberships => _memberships;

  bool get hasVerifiedMembership => _memberships.any((item) => item.isVerified);

  List<PondMembership> forPond(String pondId) {
    return [
      for (final membership in _memberships)
        if (membership.pondId == pondId) membership,
    ];
  }

  /// Replaces the membership list used by the preview screens.
  void replaceMemberships(Iterable<PondMembership> memberships) {
    final next = List<PondMembership>.unmodifiable(memberships);
    final sameIds =
        next.length == _memberships.length &&
        List<bool>.generate(
          next.length,
          (index) => next[index].id == _memberships[index].id,
        ).every((matches) => matches);
    if (sameIds) {
      return;
    }
    _memberships = next;
    notifyListeners();
  }
}
