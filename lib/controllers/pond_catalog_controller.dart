import 'package:flutter/foundation.dart';

import '../models/pond.dart';

/// Local pond list used by search and filters. Empty unless a dataset is supplied.
class PondCatalogController extends ChangeNotifier {
  PondCatalogController({Iterable<Pond> ponds = const <Pond>[]})
    : _ponds = List<Pond>.unmodifiable(ponds);

  List<Pond> _ponds;
  String _query = '';
  String? _species;
  String? _pondType;
  PondWaterType? _waterType;
  bool _sortByName = false;

  List<Pond> get ponds => _ponds;

  String get query => _query;

  String? get selectedSpecies => _species;

  String? get selectedPondType => _pondType;

  PondWaterType? get selectedWaterType => _waterType;

  bool get sortByName => _sortByName;

  bool get hasActiveFilters =>
      _query.trim().isNotEmpty ||
      _species != null ||
      _pondType != null ||
      _waterType != null ||
      _sortByName;

  List<String> get speciesOptions =>
      _uniqueValues(_ponds.expand((pond) => pond.species));

  List<String> get pondTypeOptions =>
      _uniqueValues(_ponds.map((pond) => pond.pondType));

  List<PondWaterType> get waterTypeOptions {
    const order = <PondWaterType>[
      PondWaterType.saltwater,
      PondWaterType.freshwater,
      PondWaterType.mixed,
      PondWaterType.unknown,
    ];
    final present = _ponds.map((pond) => pond.waterType).toSet();
    return [
      for (final type in order)
        if (present.contains(type)) type,
    ];
  }

  List<Pond> get visible {
    final query = _query.trim().toLowerCase();
    final matched = [
      for (final pond in _ponds)
        if (_matches(pond, query)) pond,
    ];
    if (!_sortByName) {
      return matched;
    }
    final sorted = List<Pond>.of(matched);
    sorted.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return sorted;
  }

  void setQuery(String value) {
    if (value == _query) {
      return;
    }
    _query = value;
    notifyListeners();
  }

  void setSpecies(String? value) {
    final next = _blankToNull(value);
    if (next == _species) {
      return;
    }
    _species = next;
    notifyListeners();
  }

  void setPondType(String? value) {
    final next = _blankToNull(value);
    if (next == _pondType) {
      return;
    }
    _pondType = next;
    notifyListeners();
  }

  void setWaterType(PondWaterType? value) {
    if (value == _waterType) {
      return;
    }
    _waterType = value;
    notifyListeners();
  }

  void setSortByName(bool value) {
    if (value == _sortByName) {
      return;
    }
    _sortByName = value;
    notifyListeners();
  }

  void clearFilters() {
    if (!hasActiveFilters) {
      return;
    }
    _query = '';
    _species = null;
    _pondType = null;
    _waterType = null;
    _sortByName = false;
    notifyListeners();
  }

  /// Replaces the catalog. Clears filters so a new list is fully visible.
  void replacePonds(Iterable<Pond> ponds) {
    final next = List<Pond>.unmodifiable(ponds);
    final sameIds =
        next.length == _ponds.length &&
        List<bool>.generate(
          next.length,
          (index) => next[index].id == _ponds[index].id,
        ).every((matches) => matches);
    if (sameIds && !hasActiveFilters) {
      return;
    }
    _ponds = next;
    _query = '';
    _species = null;
    _pondType = null;
    _waterType = null;
    _sortByName = false;
    notifyListeners();
  }

  bool _matches(Pond pond, String query) {
    if (query.isNotEmpty &&
        !pond.name.toLowerCase().contains(query) &&
        !(pond.addressOrArea?.toLowerCase().contains(query) ?? false)) {
      return false;
    }
    if (_species != null &&
        !pond.species.any((item) => _same(item, _species!))) {
      return false;
    }
    if (_pondType != null && !_same(pond.pondType, _pondType!)) {
      return false;
    }
    return _matchesWater(pond);
  }

  bool _matchesWater(Pond pond) {
    final selected = _waterType;
    if (selected == null) {
      return true;
    }
    if (selected == PondWaterType.saltwater) {
      return pond.waterType == PondWaterType.saltwater ||
          pond.waterType == PondWaterType.mixed;
    }
    if (selected == PondWaterType.freshwater) {
      return pond.waterType == PondWaterType.freshwater ||
          pond.waterType == PondWaterType.mixed;
    }
    return pond.waterType == selected;
  }

  List<String> _uniqueValues(Iterable<String> values) {
    final unique = <String>{};
    for (final value in values) {
      final trimmed = value.trim();
      if (trimmed.isNotEmpty) {
        unique.add(trimmed);
      }
    }
    final sorted = unique.toList()..sort();
    return sorted;
  }

  String? _blankToNull(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }

  bool _same(String left, String right) =>
      left.trim().toLowerCase() == right.trim().toLowerCase();
}
