import 'package:flutter_test/flutter_test.dart';
import 'package:my_fishing_club/controllers/membership_controller.dart';
import 'package:my_fishing_club/controllers/pond_catalog_controller.dart';
import 'package:my_fishing_club/models/pond.dart';
import 'package:my_fishing_club/models/pond_membership.dart';

void main() {
  const north = Pond(
    id: 'north',
    name: 'North Test Pond',
    species: ['Test Carp', 'Test Catfish'],
    pondType: 'Pay pond',
  );
  const south = Pond(
    id: 'south',
    name: 'South Test Pond',
    species: ['Test Catfish'],
    pondType: 'Public pond',
  );

  test('name sort keeps the supplied order until it is turned on', () {
    final catalog = PondCatalogController(ponds: const [south, north]);

    expect(catalog.visible.map((pond) => pond.id), ['south', 'north']);
    catalog.setSortByName(true);
    expect(catalog.visible.map((pond) => pond.id), ['north', 'south']);
    catalog.clearFilters();
    expect(catalog.sortByName, isFalse);
    expect(catalog.visible.map((pond) => pond.id), ['south', 'north']);
  });

  test('an empty catalog stays empty while searching', () {
    final catalog = PondCatalogController();

    catalog.setQuery('pond');
    catalog.setSpecies('Test Carp');

    expect(catalog.ponds, isEmpty);
    expect(catalog.visible, isEmpty);
    expect(catalog.speciesOptions, isEmpty);
    expect(catalog.pondTypeOptions, isEmpty);
  });

  test('search and filters use only the supplied ponds', () {
    final catalog = PondCatalogController(ponds: const [north, south]);

    expect(catalog.speciesOptions, ['Test Carp', 'Test Catfish']);
    expect(catalog.pondTypeOptions, ['Pay pond', 'Public pond']);

    catalog.setQuery('north');
    expect(catalog.visible.map((pond) => pond.id), ['north']);

    catalog.clearFilters();
    catalog.setSpecies('Test Carp');
    expect(catalog.visible.map((pond) => pond.id), ['north']);

    catalog.setSpecies(null);
    catalog.setPondType('Public pond');
    expect(catalog.visible.map((pond) => pond.id), ['south']);

    catalog.setQuery('north');
    expect(catalog.visible, isEmpty);

    catalog.clearFilters();
    expect(catalog.visible, [north, south]);
  });

  test('memberships stay separated by pond and demo is not verified', () {
    const demo = PondMembership(
      id: 'demo-1',
      pondId: 'north',
      pondName: 'North Test Pond',
      standing: MembershipStanding.demoPreview,
    );
    const other = PondMembership(
      id: 'demo-2',
      pondId: 'south',
      pondName: 'South Test Pond',
      standing: MembershipStanding.demoPreview,
    );
    final memberships = MembershipController(memberships: const [demo, other]);

    expect(memberships.forPond('north').map((item) => item.id), ['demo-1']);
    expect(memberships.forPond('missing'), isEmpty);
    expect(demo.isDemo, isTrue);
    expect(demo.isVerified, isFalse);
    expect(memberships.hasVerifiedMembership, isFalse);
  });
}
