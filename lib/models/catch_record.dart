/// A catch the angler saved on this device.
class CatchRecord {
  const CatchRecord({
    required this.id,
    required this.species,
    required this.caughtAt,
    this.weightKg,
    this.lengthCm,
    this.notes,
    this.photoPath,
    this.pondId,
    this.pondName,
    this.sessionId,
  });

  final String id;
  final String species;
  final DateTime caughtAt;
  final double? weightKg;
  final double? lengthCm;
  final String? notes;
  final String? photoPath;
  final String? pondId;
  final String? pondName;
  final String? sessionId;

  CatchRecord copyWith({
    String? id,
    String? species,
    DateTime? caughtAt,
    double? weightKg,
    double? lengthCm,
    String? notes,
    String? photoPath,
    String? pondId,
    String? pondName,
    String? sessionId,
    bool clearWeight = false,
    bool clearLength = false,
    bool clearNotes = false,
    bool clearPhoto = false,
    bool clearPond = false,
    bool clearSession = false,
  }) {
    return CatchRecord(
      id: id ?? this.id,
      species: species ?? this.species,
      caughtAt: caughtAt ?? this.caughtAt,
      weightKg: clearWeight ? null : weightKg ?? this.weightKg,
      lengthCm: clearLength ? null : lengthCm ?? this.lengthCm,
      notes: clearNotes ? null : notes ?? this.notes,
      photoPath: clearPhoto ? null : photoPath ?? this.photoPath,
      pondId: clearPond ? null : pondId ?? this.pondId,
      pondName: clearPond ? null : pondName ?? this.pondName,
      sessionId: clearSession ? null : sessionId ?? this.sessionId,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'species': species,
      'caughtAt': caughtAt.toIso8601String(),
      'weightKg': weightKg,
      'lengthCm': lengthCm,
      'notes': notes,
      'photoPath': photoPath,
      'pondId': pondId,
      'pondName': pondName,
      'sessionId': sessionId,
    };
  }

  static CatchRecord? fromJson(Object? value) {
    if (value is! Map) {
      return null;
    }
    final id = value['id'];
    final species = value['species'];
    final caughtAt = value['caughtAt'];
    if (id is! String ||
        id.isEmpty ||
        species is! String ||
        caughtAt is! String) {
      return null;
    }
    final parsed = DateTime.tryParse(caughtAt);
    if (parsed == null) {
      return null;
    }
    return CatchRecord(
      id: id,
      species: species,
      caughtAt: parsed,
      weightKg: _double(value['weightKg']),
      lengthCm: _double(value['lengthCm']),
      notes: _string(value['notes']),
      photoPath: _string(value['photoPath']),
      pondId: _string(value['pondId']),
      pondName: _string(value['pondName']),
      sessionId: _string(value['sessionId']),
    );
  }
}

double? _double(Object? value) {
  if (value is num) {
    return value.toDouble();
  }
  return null;
}

String? _string(Object? value) {
  if (value is String && value.trim().isNotEmpty) {
    return value;
  }
  return null;
}
