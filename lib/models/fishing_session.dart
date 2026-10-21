enum SessionStatus { active, completed }

/// A fishing session saved on this device. It is not a booking.
class FishingSession {
  const FishingSession({
    required this.id,
    required this.startedAt,
    required this.createdAt,
    required this.updatedAt,
    this.title,
    this.tripId,
    this.pondId,
    this.pondName,
    this.endedAt,
    this.status = SessionStatus.active,
    this.notes,
  });

  final String id;
  final String? title;
  final String? tripId;
  final String? pondId;
  final String? pondName;
  final DateTime startedAt;
  final DateTime? endedAt;
  final SessionStatus status;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get isActive => status == SessionStatus.active;

  /// Elapsed time from the stored start until [now], or until the stored end.
  Duration elapsedUntil(DateTime now) {
    final end = isActive ? now : (endedAt ?? now);
    final span = end.difference(startedAt);
    if (span.isNegative) {
      return Duration.zero;
    }
    return span;
  }

  FishingSession copyWith({
    String? id,
    String? title,
    String? tripId,
    String? pondId,
    String? pondName,
    DateTime? startedAt,
    DateTime? endedAt,
    SessionStatus? status,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool clearTitle = false,
    bool clearTrip = false,
    bool clearPond = false,
    bool clearEnded = false,
    bool clearNotes = false,
  }) {
    return FishingSession(
      id: id ?? this.id,
      title: clearTitle ? null : title ?? this.title,
      tripId: clearTrip ? null : tripId ?? this.tripId,
      pondId: clearPond ? null : pondId ?? this.pondId,
      pondName: clearPond ? null : pondName ?? this.pondName,
      startedAt: startedAt ?? this.startedAt,
      endedAt: clearEnded ? null : endedAt ?? this.endedAt,
      status: status ?? this.status,
      notes: clearNotes ? null : notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'title': title,
      'tripId': tripId,
      'pondId': pondId,
      'pondName': pondName,
      'startedAt': startedAt.toIso8601String(),
      'endedAt': endedAt?.toIso8601String(),
      'status': status.name,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  static FishingSession? fromJson(Object? value) {
    if (value is! Map) {
      return null;
    }
    final id = value['id'];
    final startedRaw = value['startedAt'];
    if (id is! String || id.isEmpty || startedRaw is! String) {
      return null;
    }
    final startedAt = DateTime.tryParse(startedRaw);
    if (startedAt == null) {
      return null;
    }
    final endedAt = value['endedAt'] is String
        ? DateTime.tryParse(value['endedAt'] as String)
        : null;
    final status = _status(value['status'], endedAt);
    if (status == null) {
      return null;
    }
    final createdAt = value['createdAt'] is String
        ? DateTime.tryParse(value['createdAt'] as String) ?? startedAt
        : startedAt;
    final updatedAt = value['updatedAt'] is String
        ? DateTime.tryParse(value['updatedAt'] as String) ??
              (endedAt ?? startedAt)
        : (endedAt ?? startedAt);
    return FishingSession(
      id: id,
      title: _text(value['title']),
      tripId: _text(value['tripId']),
      pondId: _text(value['pondId']),
      pondName: _text(value['pondName']),
      startedAt: startedAt,
      endedAt: endedAt,
      status: status,
      notes: _text(value['notes']),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

SessionStatus? _status(Object? value, DateTime? endedAt) {
  if (value == null) {
    return endedAt == null ? SessionStatus.active : SessionStatus.completed;
  }
  if (value == SessionStatus.active.name) {
    return SessionStatus.active;
  }
  if (value == SessionStatus.completed.name) {
    return SessionStatus.completed;
  }
  return null;
}

String? _text(Object? value) {
  if (value is String && value.trim().isNotEmpty) {
    return value;
  }
  return null;
}
