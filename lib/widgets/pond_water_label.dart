import '../generated/l10n/app_localizations.dart';
import '../models/pond.dart';

String pondWaterLabel(AppLocalizations l10n, PondWaterType type) {
  switch (type) {
    case PondWaterType.saltwater:
      return l10n.saltwater;
    case PondWaterType.freshwater:
      return l10n.freshwater;
    case PondWaterType.mixed:
      return l10n.mixedWater;
    case PondWaterType.unknown:
      return l10n.unknownWater;
  }
}
