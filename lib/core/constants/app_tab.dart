import '../../generated/l10n/app_localizations.dart';

/// Bottom navigation destinations, in display order.
enum AppTab { home, explore, notification, settings }

extension AppTabL10n on AppTab {
  String label(AppLocalizations l10n) {
    return switch (this) {
      AppTab.home => l10n.home,
      AppTab.explore => l10n.explore,
      AppTab.notification => l10n.notification,
      AppTab.settings => l10n.settings,
    };
  }

  /// Stable heading key so tests do not depend on the translated title.
  String get headingId {
    return switch (this) {
      AppTab.home => 'Home',
      AppTab.explore => 'Explore',
      AppTab.notification => 'Notification',
      AppTab.settings => 'Settings',
    };
  }
}
