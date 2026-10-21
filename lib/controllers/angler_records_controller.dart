import 'package:flutter/foundation.dart';

import '../data/repositories/angler_records_repository.dart';
import '../models/catch_record.dart';
import '../models/fishing_session.dart';
import '../models/trip_record.dart';

/// Result of trying to start a fishing session.
class SessionStartOutcome {
  const SessionStartOutcome.started(this.session)
    : created = true,
      failed = false;

  const SessionStartOutcome.alreadyActive(this.session)
    : created = false,
      failed = false;

  const SessionStartOutcome.failed()
    : session = null,
      created = false,
      failed = true;

  final FishingSession? session;
  final bool created;
  final bool failed;
}

/// Local favorites, catches, trips, and sessions. Saving never edits the pond catalog.
class AnglerRecordsController extends ChangeNotifier {
  AnglerRecordsController({AnglerRecordsRepository? repository})
    : _repository =
          repository ?? const SharedPreferencesAnglerRecordsRepository() {
    _load();
  }

  final AnglerRecordsRepository _repository;
  AnglerRecords _records = AnglerRecords.empty;
  var _loading = true;
  var _loadFailed = false;
  var _saveFailed = false;

  bool get loading => _loading;

  bool get loadFailed => _loadFailed;

  bool get saveFailed => _saveFailed;

  Set<String> get favoritePondIds => _records.favoritePondIds;

  List<CatchRecord> get catches {
    final items = List<CatchRecord>.of(_records.catches);
    items.sort((a, b) => b.caughtAt.compareTo(a.caughtAt));
    return items;
  }

  List<TripRecord> get trips {
    final items = List<TripRecord>.of(_records.trips);
    items.sort((a, b) => b.startsOn.compareTo(a.startsOn));
    return items;
  }

  List<FishingSession> get sessions {
    final items = List<FishingSession>.of(_records.sessions);
    items.sort((a, b) => b.startedAt.compareTo(a.startedAt));
    return items;
  }

  /// The newest active session, if one is already stored.
  FishingSession? get activeSession {
    for (final session in sessions) {
      if (session.isActive) {
        return session;
      }
    }
    return null;
  }

  bool isFavorite(String pondId) => _records.favoritePondIds.contains(pondId);

  CatchRecord? catchById(String id) {
    for (final item in _records.catches) {
      if (item.id == id) {
        return item;
      }
    }
    return null;
  }

  TripRecord? tripById(String id) {
    for (final item in _records.trips) {
      if (item.id == id) {
        return item;
      }
    }
    return null;
  }

  FishingSession? sessionById(String id) {
    for (final item in _records.sessions) {
      if (item.id == id) {
        return item;
      }
    }
    return null;
  }

  List<CatchRecord> catchesForSession(String sessionId) {
    return [
      for (final item in catches)
        if (item.sessionId == sessionId) item,
    ];
  }

  Future<bool> setFavorite(String pondId, {required bool favorite}) {
    final next = Set<String>.of(_records.favoritePondIds);
    if (favorite) {
      next.add(pondId);
    } else {
      next.remove(pondId);
    }
    return _commit(_records.copyWith(favoritePondIds: next));
  }

  Future<bool> saveCatch(CatchRecord record) {
    if (!_canAttachNewCatch(record)) {
      _saveFailed = true;
      notifyListeners();
      return Future<bool>.value(false);
    }
    final next = [
      for (final item in _records.catches)
        if (item.id != record.id) item,
      record,
    ];
    return _commit(_records.copyWith(catches: next));
  }

  /// A new catch can join only an active session. Edits keep their link.
  bool _canAttachNewCatch(CatchRecord record) {
    final isNew = catchById(record.id) == null;
    if (!isNew || record.sessionId == null) {
      return true;
    }
    final session = sessionById(record.sessionId!);
    return session != null && session.isActive;
  }

  Future<bool> deleteCatch(String id) {
    return _commit(
      _records.copyWith(
        catches: [
          for (final item in _records.catches)
            if (item.id != id) item,
        ],
      ),
    );
  }

  Future<bool> saveTrip(TripRecord record) {
    final next = [
      for (final item in _records.trips)
        if (item.id != record.id) item,
      record,
    ];
    return _commit(_records.copyWith(trips: next));
  }

  Future<bool> deleteTrip(String id) {
    return _commit(
      _records.copyWith(
        trips: [
          for (final item in _records.trips)
            if (item.id != id) item,
        ],
      ),
    );
  }

  /// Starts one session. A second start returns the session already active.
  ///
  /// [startedAt] is the actual start. Callers omit it so the clock time of
  /// the tap is stored. Tests may pass the time they arranged.
  Future<SessionStartOutcome> startSession({
    String? title,
    String? notes,
    String? tripId,
    String? pondId,
    String? pondName,
    DateTime? startedAt,
  }) async {
    if (_loading) {
      return const SessionStartOutcome.failed();
    }
    final existing = activeSession;
    if (existing != null) {
      return SessionStartOutcome.alreadyActive(existing);
    }
    final now = startedAt ?? DateTime.now();
    final session = FishingSession(
      id: newId(),
      title: _blankToNull(title),
      notes: _blankToNull(notes),
      tripId: _blankToNull(tripId),
      pondId: _blankToNull(pondId),
      pondName: _blankToNull(pondName),
      startedAt: now,
      createdAt: now,
      updatedAt: now,
    );
    final saved = await _commit(
      _records.copyWith(sessions: [..._records.sessions, session]),
    );
    if (!saved) {
      return const SessionStartOutcome.failed();
    }
    return SessionStartOutcome.started(session);
  }

  /// Records the actual end time. The linked trip is left unchanged.
  Future<bool> endSession(String id, {DateTime? endedAt}) async {
    final current = sessionById(id);
    if (current == null || !current.isActive) {
      return false;
    }
    final now = endedAt ?? DateTime.now();
    final next = current.copyWith(
      status: SessionStatus.completed,
      endedAt: now,
      updatedAt: now,
    );
    return _commit(
      _records.copyWith(
        sessions: [
          for (final item in _records.sessions)
            if (item.id == id) next else item,
        ],
      ),
    );
  }

  static String newId() => DateTime.now().microsecondsSinceEpoch.toString();

  static String? _blankToNull(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }

  Future<void> _load() async {
    try {
      _records = await _repository.load();
      _loadFailed = false;
    } catch (_) {
      _records = AnglerRecords.empty;
      _loadFailed = true;
    }
    _loading = false;
    notifyListeners();
  }

  Future<bool> _commit(AnglerRecords next) async {
    try {
      await _repository.save(next);
      _records = next;
      _saveFailed = false;
      notifyListeners();
      return true;
    } catch (_) {
      _saveFailed = true;
      notifyListeners();
      return false;
    }
  }
}

extension on AnglerRecords {
  AnglerRecords copyWith({
    Set<String>? favoritePondIds,
    List<CatchRecord>? catches,
    List<TripRecord>? trips,
    List<FishingSession>? sessions,
  }) {
    return AnglerRecords(
      favoritePondIds: favoritePondIds ?? this.favoritePondIds,
      catches: catches ?? this.catches,
      trips: trips ?? this.trips,
      sessions: sessions ?? this.sessions,
    );
  }
}
