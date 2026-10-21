import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/angler_records_controller.dart';
import '../../controllers/pond_catalog_controller.dart';
import '../../core/constants/app_constants.dart';
import '../../core/navigation/open_explore.dart';
import '../../core/theme/app_colors.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../widgets/detail_scaffold.dart';
import '../explore/pond_details_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  static const Key emptyKey = Key('favorites-empty');

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final records = context.watch<AnglerRecordsController>();
    final catalog = context.watch<PondCatalogController>();
    final ids = records.favoritePondIds.toList();

    return DetailScaffold(
      title: l10n.favorites,
      titleKey: const Key('favorites-heading'),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.pageHorizontalPadding),
        children: [
          if (records.loading)
            Text(
              l10n.loadingRecords,
              style: Theme.of(context).textTheme.bodyLarge,
            )
          else if (ids.isEmpty)
            _EmptyFavorites(l10n: l10n)
          else
            for (final id in ids) ...[
              _FavoriteTile(pondId: id, pondName: _nameFor(catalog, id)),
              const SizedBox(height: 8),
            ],
        ],
      ),
    );
  }
}

String? _nameFor(PondCatalogController catalog, String id) {
  for (final pond in catalog.ponds) {
    if (pond.id == id) {
      return pond.name;
    }
  }
  return null;
}

class _EmptyFavorites extends StatelessWidget {
  const _EmptyFavorites({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(Icons.favorite_border, color: AppColors.primary, size: 40),
        const SizedBox(height: 16),
        Text(
          l10n.noFavoritesYet,
          key: FavoritesScreen.emptyKey,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20),
        ),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: () => showExploreTab(context),
          child: Text(l10n.explorePonds),
        ),
      ],
    );
  }
}

class _FavoriteTile extends StatelessWidget {
  const _FavoriteTile({required this.pondId, required this.pondName});

  final String pondId;
  final String? pondName;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final catalog = context.read<PondCatalogController>();
    final available = pondName != null;

    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        title: Text(available ? pondName! : l10n.pondUnavailable),
        subtitle: available ? null : Text(pondId),
        trailing: IconButton(
          tooltip: l10n.unfavoritePond,
          onPressed: () {
            context.read<AnglerRecordsController>().setFavorite(
              pondId,
              favorite: false,
            );
          },
          icon: const Icon(Icons.favorite, color: AppColors.primary),
        ),
        onTap: available
            ? () {
                final pond = catalog.ponds.firstWhere(
                  (item) => item.id == pondId,
                );
                pushAppPage(context, PondDetailsScreen(pond: pond), '/pond');
              }
            : null,
      ),
    );
  }
}
