import 'package:flutter_test/flutter_test.dart';
import 'package:my_fishing_club/controllers/angler_records_controller.dart';
import 'package:my_fishing_club/data/dummy/dummy_fishing_data.dart';
import 'package:my_fishing_club/data/repositories/angler_records_repository.dart';
import 'package:my_fishing_club/models/catch_record.dart';
import 'package:my_fishing_club/models/pond.dart';
import 'package:my_fishing_club/models/trip_record.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  CatchRecord sampleCatch() {
    return CatchRecord(
      id: 'catch-1',
      species: 'Siakap',
      caughtAt: DateTime.utc(2026, 10, 21, 8, 30),
      weightKg: 1.2,
      pondId: DummyFishingData.mvId,
      pondName: 'Kolam Pancing MV (Air Masin)',
    );
  }

  TripRecord sampleTrip() {
    return TripRecord(
      id: 'trip-1',
      title: 'Saturday morning',
      startsOn: DateTime.utc(2026, 10, 25),
      pondId: DummyFishingData.mvId,
      pondName: 'Kolam Pancing MV (Air Masin)',
    );
  }

  test(
    'shared preferences round-trips catches, trips, and favorites',
    () async {
      SharedPreferences.setMockInitialValues({});
      const repository = SharedPreferencesAnglerRecordsRepository();
      await repository.save(
        AnglerRecords(
          favoritePondIds: {DummyFishingData.mvId},
          catches: [sampleCatch()],
          trips: [sampleTrip()],
        ),
      );

      final loaded = await repository.load();

      expect(loaded.favoritePondIds, {DummyFishingData.mvId});
      expect(loaded.catches.single.species, 'Siakap');
      expect(loaded.catches.single.weightKg, 1.2);
      expect(loaded.trips.single.title, 'Saturday morning');
      expect(loaded.trips.single.status, TripStatus.planned);
      expect(
        DummyFishingData.ponds
            .singleWhere((pond) => pond.id == DummyFishingData.mvId)
            .name,
        'Kolam Pancing MV (Air Masin)',
      );
    },
  );

  test('saving a catch or favorite does not change the pond catalog', () async {
    final before = DummyFishingData.ponds.map((pond) => pond.id).toList();
    final repository = MemoryAnglerRecordsRepository();
    final records = AnglerRecordsController(repository: repository);
    await Future<void>.value();

    expect(await records.saveCatch(sampleCatch()), isTrue);
    expect(
      await records.setFavorite(DummyFishingData.mvId, favorite: true),
      isTrue,
    );

    expect(DummyFishingData.ponds.map((pond) => pond.id), before);
    expect(records.catches.single.species, 'Siakap');
    expect(records.isFavorite(DummyFishingData.mvId), isTrue);
    final pond = DummyFishingData.ponds.first;
    expect(pond, isA<Pond>());
    expect(pond.isDemo, isTrue);
  });

  test('a failed save leaves the previous records in place', () async {
    final repository = MemoryAnglerRecordsRepository(
      initial: AnglerRecords(catches: [sampleCatch()]),
    );
    final records = AnglerRecordsController(repository: repository);
    await Future<void>.value();
    repository.failNextSave = true;

    final saved = await records.saveCatch(
      CatchRecord(
        id: 'catch-2',
        species: 'Kerapu',
        caughtAt: DateTime.utc(2026, 10, 22),
      ),
    );

    expect(saved, isFalse);
    expect(records.saveFailed, isTrue);
    expect(records.catches.map((item) => item.id), ['catch-1']);
  });

  test('catch and trip records can be edited and deleted', () async {
    final records = AnglerRecordsController(
      repository: MemoryAnglerRecordsRepository(),
    );
    await Future<void>.value();
    await records.saveCatch(sampleCatch());
    await records.saveTrip(sampleTrip());

    await records.saveCatch(sampleCatch().copyWith(notes: 'Released'));
    await records.saveTrip(sampleTrip().copyWith(status: TripStatus.completed));

    expect(records.catchById('catch-1')!.notes, 'Released');
    expect(records.tripById('trip-1')!.status, TripStatus.completed);

    expect(await records.deleteCatch('catch-1'), isTrue);
    expect(await records.deleteTrip('trip-1'), isTrue);
    expect(records.catches, isEmpty);
    expect(records.trips, isEmpty);
  });

  test(
    'a missing pond id stays on the record without inventing a pond',
    () async {
      final records = AnglerRecordsController(
        repository: MemoryAnglerRecordsRepository(),
      );
      await Future<void>.value();
      await records.saveTrip(
        TripRecord(
          id: 'trip-missing',
          title: 'Old spot',
          startsOn: DateTime.utc(2026, 1, 1),
          pondId: 'removed-pond',
          pondName: 'Former pond',
        ),
      );

      final trip = records.tripById('trip-missing')!;
      expect(trip.pondId, 'removed-pond');
      expect(trip.pondName, 'Former pond');
      expect(
        DummyFishingData.ponds.any((pond) => pond.id == 'removed-pond'),
        isFalse,
      );
    },
  );
}
