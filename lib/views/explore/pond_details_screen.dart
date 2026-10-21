import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/angler_records_controller.dart';
import '../../controllers/membership_controller.dart';
import '../../core/constants/app_constants.dart';
import '../../core/navigation/open_explore.dart';
import '../../core/navigation/open_session.dart';
import '../../core/theme/app_colors.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../models/pond.dart';
import '../../models/pond_membership.dart';
import '../../services/map_navigation_service.dart';
import '../../widgets/detail_scaffold.dart';
import '../../widgets/navigation_chooser.dart';
import '../../widgets/pond_image.dart';
import '../../widgets/pond_water_label.dart';
import '../membership/membership_detail_screen.dart';
import '../trips/trip_form_screen.dart';

class PondDetailsScreen extends StatelessWidget {
  const PondDetailsScreen({super.key, required this.pond});

  final Pond pond;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final records = context.watch<AnglerRecordsController>();
    final favorite = records.isFavorite(pond.id);
    final memberships = context.watch<MembershipController>().forPond(pond.id);
    final species = pond.species
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .join(', ');
    final facilities = pond.facilities
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .join(', ');

    return DetailScaffold(
      title: l10n.pondDetails,
      actions: [
        IconButton(
          key: ValueKey<String>('favorite-${pond.id}'),
          tooltip: favorite ? l10n.unfavoritePond : l10n.favoritePond,
          onPressed: () {
            context.read<AnglerRecordsController>().setFavorite(
              pond.id,
              favorite: !favorite,
            );
          },
          icon: Icon(
            favorite ? Icons.favorite : Icons.favorite_border,
            color: AppColors.primary,
          ),
        ),
      ],
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.pageHorizontalPadding),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: PondImage(
              asset: pond.imageAsset,
              height: 200,
              unavailableLabel: pond.imageAsset == null
                  ? l10n.imageUnavailable
                  : null,
            ),
          ),
          const SizedBox(height: 16),
          Text(pond.name, style: Theme.of(context).textTheme.titleLarge),
          if (pond.isDemo) ...[
            const SizedBox(height: 8),
            Text(
              l10n.previewData,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          if (pond.description != null &&
              pond.description!.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              pond.description!.trim(),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
          const SizedBox(height: 8),
          Text(
            '${l10n.waterType}: ${pondWaterLabel(l10n, pond.waterType)}',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          if (pond.pondType.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              pond.pondType.trim(),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
          const SizedBox(height: 8),
          Text(
            '${l10n.speciesLabel}: ${species.isEmpty ? l10n.notConfirmed : species}',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          Text(
            '${l10n.facilities}: ${facilities.isEmpty ? l10n.notConfirmed : facilities}',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          Text(
            '${l10n.areaLabel}: ${pond.addressOrArea == null || pond.addressOrArea!.trim().isEmpty ? l10n.notConfirmed : pond.addressOrArea!.trim()}',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          Text(
            '${l10n.price}: ${pond.priceLabel == null || pond.priceLabel!.trim().isEmpty ? l10n.notConfirmed : pond.priceLabel!.trim()}',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          Text(
            '${l10n.openingHours}: ${pond.openingHoursLabel == null || pond.openingHoursLabel!.trim().isEmpty ? l10n.notConfirmed : pond.openingHoursLabel!.trim()}',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          if (pond.hasCoordinates) ...[
            const SizedBox(height: 8),
            Text(
              '${l10n.coordinatesLabel}: ${pond.latitude}, ${pond.longitude}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
          const SizedBox(height: 28),
          Text(
            l10n.membershipSection,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          if (memberships.isEmpty)
            Text(
              l10n.noMembershipAtPond,
              style: Theme.of(context).textTheme.bodyLarge,
            )
          else
            for (final membership in memberships) ...[
              _PondMembershipLink(membership: membership),
              if (membership.isDemo) ...[
                const SizedBox(height: 8),
                Text(
                  l10n.notVerifiedMembership,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
              const SizedBox(height: 8),
            ],
          const SizedBox(height: 28),
          Tooltip(
            message: l10n.viewMap,
            child: OutlinedButton.icon(
              key: const Key('pond-map'),
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(context);
                final outcome = await const MapNavigationService().openViewMap(
                  pond,
                );
                if (!context.mounted || outcome != MapLaunchOutcome.failed) {
                  return;
                }
                messenger.showSnackBar(
                  SnackBar(content: Text(l10n.mapsLaunchFailed)),
                );
              },
              icon: Icon(
                pond.hasCoordinates
                    ? Icons.place_outlined
                    : Icons.open_in_new_rounded,
              ),
              label: Text(
                pond.hasCoordinates
                    ? l10n.openInGoogleMaps
                    : l10n.searchInGoogleMaps,
              ),
            ),
          ),
          const SizedBox(height: 8),
          FilledButton.icon(
            key: const Key('pond-navigate'),
            onPressed: () =>
                chooseAndOpenNavigation(context: context, pond: pond),
            icon: const Icon(Icons.navigation_outlined),
            label: Text(l10n.navigate),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            key: const Key('pond-plan-trip'),
            onPressed: () {
              pushAppPage(
                context,
                TripFormScreen(initialPondId: pond.id),
                '/trip-form',
              );
            },
            icon: const Icon(Icons.route_rounded),
            label: Text(l10n.planATrip),
          ),
          const SizedBox(height: 8),
          FilledButton.icon(
            key: const Key('pond-start-session'),
            onPressed: () => openFishingSession(context, pondId: pond.id),
            icon: const Icon(Icons.timer_outlined),
            label: Text(
              records.activeSession == null
                  ? l10n.startSession
                  : l10n.resumeSession,
            ),
          ),
        ],
      ),
    );
  }
}

class _PondMembershipLink extends StatelessWidget {
  const _PondMembershipLink({required this.membership});

  final PondMembership membership;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final standing = membership.isVerified
        ? l10n.verifiedMembership
        : l10n.demoPreview;

    return OutlinedButton(
      onPressed: () {
        pushAppPage(
          context,
          MembershipDetailScreen(membership: membership),
          '/membership',
        );
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        side: const BorderSide(color: AppColors.border),
        minimumSize: const Size(64, 52),
        alignment: Alignment.centerLeft,
      ),
      child: Text('$standing · ${membership.pondName}'),
    );
  }
}
