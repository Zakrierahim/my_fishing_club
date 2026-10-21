import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:my_fishing_club/controllers/angler_records_controller.dart';
import 'package:my_fishing_club/data/dummy/dummy_fishing_data.dart';
import 'package:my_fishing_club/data/repositories/angler_records_repository.dart';
import 'package:my_fishing_club/models/catch_record.dart';
import 'package:my_fishing_club/models/fishing_session.dart';
import 'package:my_fishing_club/models/trip_record.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  FishingSession sampleSession({
    String id = 'session-1',
    SessionStatus status = SessionStatus.active,
    DateTime? endedAt,
  }) {
    final started = DateTime.utc(2026, 10, 21, 6);
    return FishingSession(
      id: id,
      title: 'Dawn',
      tripId: 'trip-1',
      pondId: DummyFishingData.mvId,
      pondName: 'Kolam Pancing MV (Air Masin)',
      startedAt: started,
      endedAt: endedAt,
      status: status,
      notes: 'Incoming tide',
      createdAt: started,
      updatedAt: endedAt ?? started,
    );
  }

  Future<AnglerRecordsController> controller([
    AnglerRecordsRepository? repository,
  ]) async {
    final records = AnglerRecordsController(
      repository: repository ?? MemoryAnglerRecordsRepository(),
    );
    await Future<void>.value();
    return records;
  }

  test('session JSON keeps the pond snapshot and catch link', () {
    final session = sampleSession(
      status: SessionStatus.completed,
      endedAt: DateTime.utc(2026, 10, 21, 8),
    );
    final restored = FishingSession.fromJson(session.toJson());

    expect(restored, isNotNull);
    expect(restored!.pondName, 'Kolam Pancing MV (Air Masin)');
    expect(restored.status, SessionStatus.completed);
    expect(restored.endedAt, DateTime.utc(2026, 10, 21, 8));
    expect(
      restored.elapsedUntil(DateTime.utc(2026, 10, 21, 12)),
      const Duration(hours: 2),
    );

    final catchRecord = CatchRecord(
      id: 'catch-1',
      species: 'Siakap',
      caughtAt: DateTime.utc(2026, 10, 21, 7),
      sessionId: session.id,
    );
    expect(CatchRecord.fromJson(catchRecord.toJson())!.sessionId, session.id);
  });

  test('stored records without sessions still load', () {
    final decoded = AnglerRecords.decode(
      jsonEncode({
        'favoritePondIds': [DummyFishingData.mvId],
        'catches': [
          {
            'id': 'catch-old',
            'species': 'Siakap',
            'caughtAt': '2026-10-21T08:30:00.000Z',
          },
        ],
        'trips': [
          {
            'id': 'trip-old',
            'title': 'Saturday morning',
            'startsOn': '2026-10-25T00:00:00.000Z',
          },
        ],
      }),
    );

    expect(decoded.sessions, isEmpty);
    expect(decoded.favoritePondIds, {DummyFishingData.mvId});
    expect(decoded.catches.single.sessionId, isNull);
    expect(decoded.catches.single.species, 'Siakap');
    expect(decoded.trips.single.title, 'Saturday morning');
  });

  test('malformed sessions are dropped and the rest is kept', () {
    final decoded = AnglerRecords.decode(
      jsonEncode({
        'sessions': [
          'bad',
          {'id': ''},
          {'id': 'broken', 'startedAt': 'not-a-date', 'status': 'active'},
          {
            'id': 'unknown',
            'startedAt': '2026-10-21T06:00:00.000Z',
            'status': 'paused',
          },
          sampleSession().toJson(),
        ],
        'catches': [
          null,
          {'species': 'Siakap'},
        ],
      }),
    );

    expect(decoded.sessions.map((session) => session.id), ['session-1']);
    expect(decoded.catches, isEmpty);
    expect(decoded.trips, isEmpty);
  });

  test('a session and its catches survive another repository load', () async {
    SharedPreferences.setMockInitialValues({});
    const repository = SharedPreferencesAnglerRecordsRepository();
    final session = sampleSession();
    await repository.save(
      AnglerRecords(
        favoritePondIds: {DummyFishingData.mvId},
        catches: [
          CatchRecord(
            id: 'catch-1',
            species: 'Siakap',
            caughtAt: DateTime.utc(2026, 10, 21, 7),
            sessionId: session.id,
          ),
        ],
        trips: [
          TripRecord(
            id: 'trip-1',
            title: 'Saturday morning',
            startsOn: DateTime.utc(2026, 10, 25),
          ),
        ],
        sessions: [session],
      ),
    );

    final loaded = await const SharedPreferencesAnglerRecordsRepository()
        .load();

    expect(loaded.sessions.single.notes, 'Incoming tide');
    expect(loaded.catches.single.sessionId, 'session-1');
    expect(loaded.trips.single.title, 'Saturday morning');
    expect(loaded.favoritePondIds, {DummyFishingData.mvId});
  });

  test('starting, catching, and ending keep the other records', () async {
    final before = DummyFishingData.ponds.map((pond) => pond.id).toList();
    final records = await controller();
    await records.setFavorite(DummyFishingData.mvId, favorite: true);
    await records.saveTrip(
      TripRecord(
        id: 'trip-1',
        title: 'Saturday morning',
        startsOn: DateTime.utc(2026, 10, 25),
        pondId: DummyFishingData.mvId,
        pondName: 'Kolam Pancing MV (Air Masin)',
      ),
    );

    final started = await records.startSession(
      title: 'Dawn',
      tripId: 'trip-1',
      pondId: DummyFishingData.mvId,
      pondName: 'Kolam Pancing MV (Air Masin)',
      startedAt: DateTime.utc(2026, 10, 21, 6),
    );
    final again = await records.startSession(title: 'Second');

    expect(started.created, isTrue);
    expect(again.created, isFalse);
    expect(again.session!.id, started.session!.id);
    expect(records.sessions, hasLength(1));

    final independent = await records.startSession();
    expect(independent.created, isFalse);

    expect(
      await records.saveCatch(
        CatchRecord(
          id: 'catch-1',
          species: 'Siakap',
          caughtAt: DateTime.utc(2026, 10, 21, 7),
          sessionId: started.session!.id,
          pondId: DummyFishingData.mvId,
          pondName: 'Kolam Pancing MV (Air Masin)',
        ),
      ),
      isTrue,
    );

    final ended = await records.endSession(
      started.session!.id,
      endedAt: DateTime.utc(2026, 10, 21, 9, 30),
    );

    expect(ended, isTrue);
    expect(records.activeSession, isNull);
    expect(
      records.sessionById(started.session!.id)!.status,
      SessionStatus.completed,
    );
    expect(
      records
          .sessionById(started.session!.id)!
          .elapsedUntil(DateTime.utc(2026, 10, 22)),
      const Duration(hours: 3, minutes: 30),
    );
    expect(
      records.catchesForSession(started.session!.id).single.species,
      'Siakap',
    );
    expect(records.tripById('trip-1')!.status, TripStatus.planned);
    expect(records.isFavorite(DummyFishingData.mvId), isTrue);
    expect(DummyFishingData.ponds.map((pond) => pond.id), before);

    expect(
      await records.saveCatch(
        CatchRecord(
          id: 'catch-2',
          species: 'Kerapu',
          caughtAt: DateTime.utc(2026, 10, 21, 10),
          sessionId: started.session!.id,
        ),
      ),
      isFalse,
    );
    expect(records.catches, hasLength(1));

    expect(
      await records.saveCatch(
        records.catchById('catch-1')!.copyWith(notes: 'Released'),
      ),
      isTrue,
    );
    expect(records.catchById('catch-1')!.sessionId, started.session!.id);
    expect(records.catchById('catch-1')!.notes, 'Released');

    final next = await records.startSession(
      startedAt: DateTime.utc(2026, 10, 22, 6),
    );
    expect(next.created, isTrue);
    expect(records.sessions, hasLength(2));
    expect(records.catchesForSession(started.session!.id), hasLength(1));
  });

  test('a failed end leaves the active session in place', () async {
    final repository = MemoryAnglerRecordsRepository();
    final records = await controller(repository);
    final started = await records.startSession(
      startedAt: DateTime.utc(2026, 10, 21, 6),
    );
    repository.failNextSave = true;

    expect(await records.endSession(started.session!.id), isFalse);
    expect(records.saveFailed, isTrue);
    expect(records.activeSession!.id, started.session!.id);
    expect(records.activeSession!.endedAt, isNull);
  });

  test('an omitted start time uses the current clock', () async {
    final records = await controller();
    final before = DateTime.now();
    final started = await records.startSession(pondId: DummyFishingData.mvId);
    final after = DateTime.now();

    expect(started.created, isTrue);
    expect(started.session!.tripId, isNull);
    expect(started.session!.startedAt.isBefore(before), isFalse);
    expect(started.session!.startedAt.isAfter(after), isFalse);
  });
}
