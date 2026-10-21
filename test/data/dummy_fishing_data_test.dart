import 'package:flutter_test/flutter_test.dart';
import 'package:my_fishing_club/controllers/membership_controller.dart';
import 'package:my_fishing_club/controllers/pond_catalog_controller.dart';
import 'package:my_fishing_club/data/dummy/dummy_fishing_data.dart';
import 'package:my_fishing_club/data/dummy/models/fishing_pond.dart';
import 'package:my_fishing_club/data/dummy/providers/dummy_fishing_data_provider.dart';
import 'package:my_fishing_club/models/pond.dart';
import 'package:my_fishing_club/models/pond_membership.dart';

void main() {
  FishingPond pondById(String id) {
    return DummyFishingData.ponds.firstWhere((pond) => pond.id == id);
  }

  test('pond copyWith keeps the fields that were not replaced', () {
    const pond = FishingPond(
      id: DummyFishingData.mvId,
      name: 'Kolam Pancing MV (Air Masin)',
      species: ['Siakap'],
      pondType: 'Pay pond',
      waterType: PondWaterType.saltwater,
      latitude: 3.1,
      longitude: 101.8,
      priceLabel: 'RM 25',
    );

    final renamed = pond.copyWith(name: 'Kolam Pancing MV renamed');

    expect(renamed, isA<FishingPond>());
    expect(renamed.name, 'Kolam Pancing MV renamed');
    expect(renamed.id, pond.id);
    expect(renamed.species, pond.species);
    expect(renamed.latitude, 3.1);
    expect(renamed.longitude, 101.8);
    expect(renamed.priceLabel, 'RM 25');
    expect(renamed.isDemo, isTrue);
    expect(renamed.waterType, PondWaterType.saltwater);
  });

  test('a demo flag blocks a verified standing', () {
    const membership = PondMembership(
      id: 'claimed',
      pondId: DummyFishingData.mvId,
      pondName: 'Kolam Pancing MV (Air Masin)',
      standing: MembershipStanding.verified,
      isDemo: true,
    );

    expect(membership.isDemo, isTrue);
    expect(membership.isVerified, isFalse);
    expect(membership.demoIdentifier, isNull);
    expect(membership.copyWith(pondName: 'Renamed').isVerified, isFalse);

    const numbered = PondMembership(
      id: 'real',
      pondId: DummyFishingData.mvId,
      pondName: 'Kolam Pancing MV (Air Masin)',
      standing: MembershipStanding.verified,
      membershipNumber: DummyFishingData.demoMemberId,
    );
    expect(numbered.isVerified, isTrue);
    expect(numbered.demoIdentifier, isNull);
  });

  test(
    'venue names stay as published and the preview membership is not verified',
    () {
      expect(DummyFishingData.ponds.map((pond) => pond.name), [
        'Kolam Pancing MV (Air Masin)',
        'Kak Ngah Sport Fishing',
        'Ulu Bendul Fish Valley',
        'Tuan Tanah Fishing Centre',
        'Kolam Pancing Air Masin Aduro',
      ]);
      expect(
        DummyFishingData.ponds.any((pond) => pond.name.contains('Alpha')),
        isFalse,
      );
      expect(DummyFishingData.ponds.every((pond) => pond.isDemo), isTrue);
      expect(
        DummyFishingData.ponds.every(
          (pond) => pond.lastChecked == DummyFishingData.lastChecked,
        ),
        isTrue,
      );

      final membership = DummyFishingData.memberships.single;
      expect(membership.pondId, DummyFishingData.mvId);
      expect(membership.pondName, 'Kolam Pancing MV (Air Masin)');
      expect(membership.isDemo, isTrue);
      expect(membership.standing, MembershipStanding.demoPreview);
      expect(membership.isVerified, isFalse);
      expect(membership.membershipNumber, DummyFishingData.demoMemberId);
      expect(membership.demoIdentifier, DummyFishingData.demoMemberId);
      expect(
        DummyFishingData.memberships.every(
          (item) => item.pondId == DummyFishingData.mvId,
        ),
        isTrue,
      );
    },
  );

  test('coordinates stay null and map links name the venue', () {
    for (final pond in DummyFishingData.ponds) {
      expect(pond.latitude, isNull, reason: pond.name);
      expect(pond.longitude, isNull, reason: pond.name);
      expect(pond.hasCoordinates, isFalse, reason: pond.name);
      expect(pond.googleMapsUrl, contains('google.com/maps/search'));
      expect(pond.googleMapsUrl, isNot(contains('@')));
    }

    expect(
      pondById(DummyFishingData.mvId).googleMapsUrl,
      contains('Kolam+Pancing+MV+Air+Masin'),
    );
    expect(
      pondById(DummyFishingData.kakNgahId).googleMapsUrl,
      contains('Kak+Ngah+Sport+Fishing'),
    );
    expect(
      pondById(DummyFishingData.uluBendulId).googleMapsUrl,
      contains('Ulu+Bendul+Fish+Valley'),
    );
    expect(
      pondById(DummyFishingData.ttfcId).googleMapsUrl,
      contains('Tuan+Tanah+Fishing+Centre'),
    );
    expect(
      pondById(DummyFishingData.aduroId).googleMapsUrl,
      contains('Kolam+Pancing+Air+Masin+Aduro'),
    );

    const sourced = Pond(
      id: 'sourced-point',
      name: 'Sourced point',
      species: <String>[],
      pondType: '',
      latitude: 2.735651,
      longitude: 102.098268,
    );
    expect(sourced.hasCoordinates, isTrue);
    expect(sourced.copyWith().latitude, 2.735651);
    expect(sourced.copyWith().longitude, 102.098268);
  });

  test('unknown prices and hours are left empty', () {
    expect(pondById(DummyFishingData.mvId).priceLabel, isNull);
    expect(pondById(DummyFishingData.mvId).openingHoursLabel, isNull);
    expect(pondById(DummyFishingData.kakNgahId).priceLabel, isNull);
    expect(pondById(DummyFishingData.kakNgahId).openingHoursLabel, isNull);
    expect(pondById(DummyFishingData.ttfcId).priceLabel, isNull);
    expect(
      pondById(DummyFishingData.ttfcId).openingHoursLabel,
      'Every day, 10:00–00:00',
    );
    expect(pondById(DummyFishingData.aduroId).priceLabel, isNull);
    expect(pondById(DummyFishingData.aduroId).openingHoursLabel, isNull);
    expect(
      pondById(DummyFishingData.uluBendulId).priceLabel,
      contains('RM100'),
    );
    expect(
      pondById(DummyFishingData.uluBendulId).openingHoursLabel,
      contains('Khamis rehat'),
    );
    expect(pondById(DummyFishingData.uluBendulId).species, isEmpty);
    expect(DummyFishingData.ponds.first.imageAsset, isNull);
  });

  test(
    'saltwater filtering keeps mixed ponds and drops freshwater-only ponds',
    () {
      const freshwaterOnly = Pond(
        id: 'fresh-only',
        name: 'Freshwater Only Pond',
        species: ['Carp'],
        pondType: 'Pay pond',
        waterType: PondWaterType.freshwater,
      );
      final catalog = PondCatalogController(
        ponds: [...DummyFishingData.ponds, freshwaterOnly],
      );

      catalog.setWaterType(PondWaterType.saltwater);

      final visible = catalog.visible.map((pond) => pond.id);
      expect(visible, isNot(contains('fresh-only')));
      expect(visible, contains(DummyFishingData.mvId));
      expect(visible, contains(DummyFishingData.aduroId));
      expect(visible, contains(DummyFishingData.uluBendulId));
      expect(visible, contains(DummyFishingData.ttfcId));
      expect(
        catalog.visible.every(
          (pond) => pond.waterType != PondWaterType.freshwater,
        ),
        isTrue,
      );

      catalog.setQuery('Aduro');
      expect(catalog.visible.map((pond) => pond.id), [
        DummyFishingData.aduroId,
      ]);

      catalog.clearFilters();
      catalog.setQuery('Tanjung Ipoh');
      expect(catalog.visible.map((pond) => pond.id), [
        DummyFishingData.uluBendulId,
      ]);
    },
  );

  test('lookups stay inside the preview dataset', () {
    final provider = DummyFishingDataProvider(enabled: true);
    final memberships = MembershipController(
      memberships: DummyFishingData.memberships,
    );

    expect(
      provider.pondById(DummyFishingData.ttfcId)?.name,
      'Tuan Tanah Fishing Centre',
    );
    expect(provider.pondById('missing'), isNull);
    expect(
      provider.membershipsForPond(DummyFishingData.mvId).single.isVerified,
      isFalse,
    );
    expect(provider.membershipsForPond(DummyFishingData.aduroId), isEmpty);
    expect(provider.demoMembershipForPond(DummyFishingData.kakNgahId), isNull);
    expect(
      memberships.forPond(DummyFishingData.mvId).single.isVerified,
      isFalse,
    );
    expect(memberships.forPond(DummyFishingData.uluBendulId), isEmpty);
  });

  test('a disabled preview hides the venue records', () {
    final provider = DummyFishingDataProvider();
    final catalog = PondCatalogController();
    final memberships = MembershipController();
    var notifications = 0;
    provider.addListener(() => notifications++);

    expect(provider.ponds, isEmpty);
    expect(provider.memberships, isEmpty);
    expect(provider.pondById(DummyFishingData.mvId), isNull);

    provider.setPreviewEnabled(
      enabled: false,
      catalog: catalog,
      memberships: memberships,
    );
    expect(notifications, 0);

    provider.setPreviewEnabled(
      enabled: true,
      catalog: catalog,
      memberships: memberships,
    );
    expect(notifications, 1);
    expect(catalog.ponds, hasLength(DummyFishingData.ponds.length));
    expect(memberships.memberships, hasLength(1));
    expect(memberships.hasVerifiedMembership, isFalse);

    provider.setPreviewEnabled(
      enabled: false,
      catalog: catalog,
      memberships: memberships,
    );
    expect(catalog.ponds, isEmpty);
    expect(memberships.memberships, isEmpty);
  });
}
