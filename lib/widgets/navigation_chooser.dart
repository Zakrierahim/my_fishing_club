import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../generated/l10n/app_localizations.dart';
import '../models/pond.dart';
import '../services/map_navigation_service.dart';

/// Asks which maps app to use, then reports whether a link actually opened.
Future<void> chooseAndOpenNavigation({
  required BuildContext context,
  required Pond pond,
  MapNavigationService? service,
}) async {
  final l10n = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.of(context);
  final navigation = service ?? const MapNavigationService();
  final providers = navigation.navigationProviders();
  final suggested = navigation.defaultProvider();

  final selected = await showModalBottomSheet<MapProvider>(
    context: context,
    backgroundColor: AppColors.surface,
    showDragHandle: true,
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(
                  l10n.chooseNavigation,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontSize: 18),
                ),
              ),
              if (!pond.hasCoordinates)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Text(
                    l10n.navigationSearchNote,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              for (final provider in providers)
                ListTile(
                  key: Key('nav-${provider.name}'),
                  title: Text(_providerLabel(l10n, provider)),
                  trailing: provider == suggested
                      ? Text(
                          l10n.navigationSuggested,
                          style: const TextStyle(color: AppColors.primary),
                        )
                      : null,
                  onTap: () => Navigator.of(context).pop(provider),
                ),
            ],
          ),
        ),
      );
    },
  );

  if (selected == null || !context.mounted) {
    return;
  }
  final outcome = await navigation.openNavigation(
    provider: selected,
    pond: pond,
  );
  if (!context.mounted) {
    return;
  }
  final message = switch (outcome) {
    MapLaunchOutcome.appOpened => null,
    MapLaunchOutcome.webOpened => l10n.mapsOpenedInBrowser,
    MapLaunchOutcome.failed => l10n.mapsLaunchFailed,
  };
  if (message == null) {
    return;
  }
  messenger.showSnackBar(SnackBar(content: Text(message)));
}

String _providerLabel(AppLocalizations l10n, MapProvider provider) {
  return switch (provider) {
    MapProvider.google => l10n.googleMaps,
    MapProvider.waze => l10n.waze,
    MapProvider.apple => l10n.appleMaps,
  };
}
