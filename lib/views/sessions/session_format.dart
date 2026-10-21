import '../../generated/l10n/app_localizations.dart';
import '../../models/fishing_session.dart';

String sessionTitle(AppLocalizations l10n, FishingSession session) {
  final title = session.title?.trim();
  if (title == null || title.isEmpty) {
    return l10n.fishingSession;
  }
  return title;
}

String sessionStatusLabel(AppLocalizations l10n, SessionStatus status) {
  return switch (status) {
    SessionStatus.active => l10n.sessionActive,
    SessionStatus.completed => l10n.sessionCompleted,
  };
}

String sessionDurationLabel(AppLocalizations l10n, Duration duration) {
  final safe = duration.isNegative ? Duration.zero : duration;
  final hours = safe.inHours;
  final minutes = safe.inMinutes.remainder(60);
  if (hours > 0) {
    return l10n.sessionDurationHours(hours, minutes);
  }
  return l10n.sessionDurationMinutes(minutes);
}
