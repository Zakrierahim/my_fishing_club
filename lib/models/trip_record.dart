enum TripStatus { planned, completed, cancelled }

/// A trip the angler planned on this device. It is not a reservation.
class TripRecord {
  const TripRecord({
    required this.id,
    required this.title,
    required this.startsOn,
    this.endsOn,
    this.notes,
    this.pondId,
    this.pondName,
    this.status = TripStatus.planned,
  });

  final String id;
  final String title;
  final DateTime startsOn;
  final DateTime? endsOn;
  final String? notes;
  final String? pondId;
  final String? pondName;
  final TripStatus status;

  TripRecord copyWith({
    String? id,
    String? title,
    DateTime? startsOn,
    DateTime? endsOn,
    String? notes,
    String? pondId,
    String? pondName,
    TripStatus? status,
    bool clearEnd = false,
    bool clearNotes = false,
    bool clearPond = false,
  }) {
    return TripRecord(
      id: id ?? this.id,
      title: title ?? this.title,
      startsOn: startsOn ?? this.startsOn,
      endsOn: clearEnd ? null : endsOn ?? this.endsOn,
      notes: clearNotes ? null : notes ?? this.notes,
      pondId: clearPond ? null : pondId ?? this.pondId,
      pondName: clearPond ? null : pondName ?? this.pondName,
      status: status ?? this.status,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'title': title,
      'startsOn': startsOn.toIso8601String(),
      'endsOn': endsOn?.toIso8601String(),
      'notes': notes,
      'pondId': pondId,
      'pondName': pondName,
      'status': status.name,
    };
  }

  static TripRecord? fromJson(Object? value) {
    if (value is! Map) {
      return null;
    }
    final id = value['id'];
    final title = value['title'];
    final startsOn = value['startsOn'];
    if (id is! String ||
        id.isEmpty ||
        title is! String ||
        startsOn is! String) {
      return null;
    }
    final parsedStart = DateTime.tryParse(startsOn);
    if (parsedStart == null) {
      return null;
    }
    final statusName = value['status'];
    final status = TripStatus.values.where((item) => item.name == statusName);
    return TripRecord(
      id: id,
      title: title,
      startsOn: parsedStart,
      endsOn: value['endsOn'] is String
          ? DateTime.tryParse(value['endsOn'] as String)
          : null,
      notes:
          value['notes'] is String &&
              (value['notes'] as String).trim().isNotEmpty
          ? value['notes'] as String
          : null,
      pondId:
          value['pondId'] is String && (value['pondId'] as String).isNotEmpty
          ? value['pondId'] as String
          : null,
      pondName:
          value['pondName'] is String &&
              (value['pondName'] as String).trim().isNotEmpty
          ? value['pondName'] as String
          : null,
      status: status.isEmpty ? TripStatus.planned : status.first,
    );
  }
}
