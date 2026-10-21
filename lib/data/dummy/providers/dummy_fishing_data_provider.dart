import 'package:flutter/foundation.dart';

import '../../../controllers/membership_controller.dart';
import '../../../controllers/pond_catalog_controller.dart';
import '../dummy_fishing_data.dart';
import '../models/fishing_pond.dart';
import '../models/pond_membership.dart';

/// Holds the on/off switch for fictional pond preview data.
class DummyFishingDataProvider extends ChangeNotifier {
  DummyFishingDataProvider({bool enabled = false}) : _enabled = enabled;

  bool _enabled;

  bool get isEnabled => _enabled;

  List<FishingPond> get ponds =>
      _enabled ? DummyFishingData.ponds : const <FishingPond>[];

  List<DemoPondMembership> get memberships =>
      _enabled ? DummyFishingData.memberships : const <DemoPondMembership>[];

  FishingPond? pondById(String id) {
    if (!_enabled) {
      return null;
    }
    for (final pond in DummyFishingData.ponds) {
      if (pond.id == id) {
        return pond;
      }
    }
    return null;
  }

  List<DemoPondMembership> membershipsForPond(String pondId) {
    if (!_enabled) {
      return const <DemoPondMembership>[];
    }
    return [
      for (final membership in DummyFishingData.memberships)
        if (membership.pondId == pondId) membership,
    ];
  }

  DemoPondMembership? demoMembershipForPond(String pondId) {
    final matches = membershipsForPond(pondId);
    if (matches.isEmpty) {
      return null;
    }
    return matches.first;
  }

  /// Turns preview data on or off and updates the pond and membership lists.
  void setPreviewEnabled({
    required bool enabled,
    required PondCatalogController catalog,
    required MembershipController memberships,
  }) {
    if (_enabled == enabled) {
      return;
    }
    _enabled = enabled;
    catalog.replacePonds(enabled ? DummyFishingData.ponds : const []);
    memberships.replaceMemberships(
      enabled ? DummyFishingData.memberships : const [],
    );
    notifyListeners();
  }
}
