import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/catch_record.dart';
import '../../models/fishing_session.dart';
import '../../models/trip_record.dart';

/// Favorites, catches, trips, and sessions stored together on the device.
class AnglerRecords {
  const AnglerRecords({
    this.favoritePondIds = const <String>{},
    this.catches = const <CatchRecord>[],
    this.trips = const <TripRecord>[],
    this.sessions = const <FishingSession>[],
  });

  static const empty = AnglerRecords();

  final Set<String> favoritePondIds;
  final List<CatchRecord> catches;
  final List<TripRecord> trips;
  final List<FishingSession> sessions;

  String encode() {
    return jsonEncode({
      'favoritePondIds': favoritePondIds.toList(),
      'catches': [for (final item in catches) item.toJson()],
      'trips': [for (final item in trips) item.toJson()],
      'sessions': [for (final item in sessions) item.toJson()],
    });
  }

  static AnglerRecords decode(String raw) {
    final decoded = jsonDecode(raw);
    if (decoded is! Map) {
      throw const FormatException('Saved records are not an object.');
    }
    final favorites = decoded['favoritePondIds'];
    final catches = decoded['catches'];
    final trips = decoded['trips'];
    final sessions = decoded['sessions'];
    return AnglerRecords(
      favoritePondIds: favorites is List
          ? {
              for (final id in favorites)
                if (id is String && id.isNotEmpty) id,
            }
          : const {},
      catches: catches is List
          ? [
              for (final item in catches)
                if (CatchRecord.fromJson(item) != null)
                  CatchRecord.fromJson(item)!,
            ]
          : const [],
      trips: trips is List
          ? [
              for (final item in trips)
                if (TripRecord.fromJson(item) != null)
                  TripRecord.fromJson(item)!,
            ]
          : const [],
      sessions: sessions is List
          ? [
              for (final item in sessions)
                if (FishingSession.fromJson(item) != null)
                  FishingSession.fromJson(item)!,
            ]
          : const [],
    );
  }
}

abstract class AnglerRecordsRepository {
  Future<AnglerRecords> load();

  Future<void> save(AnglerRecords records);
}

/// In-memory store used by tests and as a fallback when disk is unavailable.
class MemoryAnglerRecordsRepository implements AnglerRecordsRepository {
  MemoryAnglerRecordsRepository({AnglerRecords? initial})
    : _records = initial ?? AnglerRecords.empty;

  AnglerRecords _records;
  bool failNextSave = false;

  @override
  Future<AnglerRecords> load() async => _records;

  @override
  Future<void> save(AnglerRecords records) async {
    if (failNextSave) {
      failNextSave = false;
      throw StateError('save failed');
    }
    _records = records;
  }
}

/// One JSON document in shared preferences. Locale storage stays separate.
class SharedPreferencesAnglerRecordsRepository
    implements AnglerRecordsRepository {
  const SharedPreferencesAnglerRecordsRepository();

  /// Unchanged so favorites, catches, and trips saved earlier still load.
  /// Sessions are an optional field inside the same document.
  static const String preferenceKey = 'angler_records_v1';

  @override
  Future<AnglerRecords> load() async {
    final preferences = await SharedPreferences.getInstance();
    final raw = preferences.getString(preferenceKey);
    if (raw == null || raw.trim().isEmpty) {
      return AnglerRecords.empty;
    }
    return AnglerRecords.decode(raw);
  }

  @override
  Future<void> save(AnglerRecords records) async {
    final preferences = await SharedPreferences.getInstance();
    final saved = await preferences.setString(preferenceKey, records.encode());
    if (!saved) {
      throw StateError('records were not saved');
    }
  }
}
