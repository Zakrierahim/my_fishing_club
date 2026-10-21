import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/pond_catalog_controller.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_tab.dart';
import '../../core/navigation/open_explore.dart';
import '../../core/theme/app_colors.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../widgets/demo_data_banner.dart';
import '../../widgets/floating_bottom_nav.dart';
import '../../widgets/pond_card.dart';
import '../../widgets/pond_water_label.dart';
import 'pond_details_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  static const Key searchKey = Key('pond-search');
  static const Key emptyKey = Key('pond-empty');
  static const Key listKey = Key('pond-list');

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _search = TextEditingController();
  PondCatalogController? _catalog;
  var _syncedQuery = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final catalog = context.read<PondCatalogController>();
    if (!identical(_catalog, catalog)) {
      _catalog?.removeListener(_syncSearch);
      _catalog = catalog;
      catalog.addListener(_syncSearch);
    }
    if (_syncedQuery) {
      return;
    }
    _syncedQuery = true;
    _search.text = catalog.query;
  }

  void _syncSearch() {
    final query = _catalog?.query;
    if (query != null && _search.text != query) {
      _search.value = TextEditingValue(
        text: query,
        selection: TextSelection.collapsed(offset: query.length),
      );
    }
  }

  @override
  void dispose() {
    _catalog?.removeListener(_syncSearch);
    _search.dispose();
    super.dispose();
  }

  void _clear() {
    _search.clear();
    context.read<PondCatalogController>().clearFilters();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final catalog = context.watch<PondCatalogController>();
    final clearance = floatingNavClearance(context);
    final visible = catalog.visible;
    final emptyMessage = catalog.ponds.isEmpty
        ? l10n.noPondsYet
        : l10n.noMatchingPonds;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppConstants.contentMaxWidth,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppConstants.pageHorizontalPadding,
                16,
                AppConstants.pageHorizontalPadding,
                0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.explore,
                    key: ValueKey<String>(
                      'page-heading-${AppTab.explore.headingId}',
                    ),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  const DemoDataBanner(),
                  TextField(
                    key: ExploreScreen.searchKey,
                    controller: _search,
                    textInputAction: TextInputAction.search,
                    onChanged: catalog.setQuery,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: l10n.searchPonds,
                      prefixIcon: const Icon(Icons.search_rounded),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView(
                      key: ExploreScreen.listKey,
                      cacheExtent: 2000,
                      padding: EdgeInsets.only(bottom: clearance),
                      children: [
                        _FilterSection(onClear: _clear),
                        const SizedBox(height: 12),
                        if (visible.isEmpty) ...[
                          const SizedBox(height: 24),
                          const Icon(
                            Icons.water_rounded,
                            color: AppColors.primary,
                            size: 40,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            emptyMessage,
                            key: ExploreScreen.emptyKey,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ] else
                          for (final pond in visible) ...[
                            PondCard(
                              key: ValueKey<String>('pond-${pond.id}'),
                              pond: pond,
                              onTap: () {
                                pushAppPage(
                                  context,
                                  PondDetailsScreen(pond: pond),
                                  '/pond',
                                );
                              },
                            ),
                            const SizedBox(height: 8),
                          ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ChipStrip extends StatelessWidget {
  const _ChipStrip({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: children.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) => children[index],
      ),
    );
  }
}

class _FilterSection extends StatelessWidget {
  const _FilterSection({required this.onClear});

  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final catalog = context.watch<PondCatalogController>();
    final species = catalog.speciesOptions;
    final types = catalog.pondTypeOptions;
    final waters = catalog.waterTypeOptions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.waterType,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        if (species.isEmpty && types.isEmpty && waters.isEmpty)
          Text(l10n.noFiltersYet, style: Theme.of(context).textTheme.bodyMedium)
        else if (waters.isNotEmpty)
          _ChipStrip(
            children: [
              for (final type in waters)
                FilterChip(
                  label: Text(pondWaterLabel(l10n, type)),
                  selected: catalog.selectedWaterType == type,
                  onSelected: (selected) {
                    catalog.setWaterType(selected ? type : null);
                  },
                ),
            ],
          ),
        const SizedBox(height: 12),
        Text(
          l10n.fishSpecies,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        if (species.isNotEmpty)
          _ChipStrip(
            children: [
              for (final item in species)
                FilterChip(
                  label: Text(item),
                  selected: catalog.selectedSpecies == item,
                  onSelected: (selected) {
                    catalog.setSpecies(selected ? item : null);
                  },
                ),
            ],
          ),
        const SizedBox(height: 12),
        Text(
          l10n.pondType,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        if (types.isNotEmpty || catalog.ponds.isNotEmpty)
          _ChipStrip(
            children: [
              if (catalog.ponds.isNotEmpty)
                FilterChip(
                  key: const Key('pond-sort'),
                  label: Text(l10n.sortByName),
                  selected: catalog.sortByName,
                  onSelected: catalog.setSortByName,
                ),
              for (final item in types)
                FilterChip(
                  label: Text(item),
                  selected: catalog.selectedPondType == item,
                  onSelected: (selected) {
                    catalog.setPondType(selected ? item : null);
                  },
                ),
            ],
          ),
        if (catalog.hasActiveFilters) ...[
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: onClear,
              child: Text(l10n.clearFilters),
            ),
          ),
        ],
      ],
    );
  }
}
