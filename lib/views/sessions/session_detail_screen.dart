import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../controllers/angler_records_controller.dart';
import '../../controllers/pond_catalog_controller.dart';
import '../../core/constants/app_constants.dart';
import '../../core/navigation/open_explore.dart';
import '../../core/theme/app_colors.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../models/fishing_session.dart';
import '../../models/trip_record.dart';
import '../../widgets/confirm_end_session.dart';
import '../../widgets/detail_scaffold.dart';
import '../catches/catch_detail_screen.dart';
import '../catches/catch_form_screen.dart';
import 'session_format.dart';

class SessionDetailScreen extends StatelessWidget {
  const SessionDetailScreen({super.key, required this.sessionId});

  final String sessionId;

  static const Key addCatchKey = Key('session-add-catch');
  static const Key endKey = Key('session-end');

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final records = context.watch<AnglerRecordsController>();
    final session = records.sessionById(sessionId);
    if (session == null) {
      return DetailScaffold(
        title: l10n.fishingSession,
        body: Padding(
          padding: const EdgeInsets.all(AppConstants.pageHorizontalPadding),
          child: Text(l10n.recordMissing),
        ),
      );
    }

    final locale = Localizations.localeOf(context).toString();
    final started = DateFormat.yMMMd(locale).add_jm().format(session.startedAt);
    final ended = session.endedAt == null
        ? null
        : DateFormat.yMMMd(locale).add_jm().format(session.endedAt!);
    final duration = sessionDurationLabel(
      l10n,
      session.elapsedUntil(DateTime.now()),
    );
    final catalog = context.watch<PondCatalogController>();
    final pondMissing =
        session.pondId != null &&
        catalog.ponds.every((pond) => pond.id != session.pondId);
    final trip = session.tripId == null
        ? null
        : records.tripById(session.tripId!);
    final catches = records.catchesForSession(session.id);
    final completed = !session.isActive;

    return DetailScaffold(
      title: completed ? l10n.sessionSummary : l10n.fishingSession,
      titleKey: const Key('session-heading'),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.pageHorizontalPadding),
        children: [
          Text(
            sessionTitle(l10n, session),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            sessionStatusLabel(l10n, session.status),
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text('${l10n.sessionStartedAt}: $started'),
          if (ended != null) ...[
            const SizedBox(height: 8),
            Text('${l10n.sessionEndedAt}: $ended'),
          ] else if (completed) ...[
            const SizedBox(height: 8),
            Text(l10n.sessionEndMissing),
          ],
          const SizedBox(height: 8),
          Text('${l10n.sessionElapsed}: $duration'),
          const SizedBox(height: 8),
          Text(
            session.pondName == null
                ? l10n.noPondOnSession
                : '${l10n.sessionPond}: ${session.pondName}',
          ),
          if (pondMissing) ...[
            const SizedBox(height: 8),
            Text(l10n.pondUnavailable),
          ],
          if (session.tripId != null) ...[
            const SizedBox(height: 8),
            Text(trip == null ? l10n.linkedTripMissing : trip.title),
          ],
          if (session.notes != null) ...[
            const SizedBox(height: 8),
            Text(session.notes!),
          ],
          const SizedBox(height: 8),
          Text(l10n.sessionCatchCount(catches.length)),
          const SizedBox(height: 8),
          Text(l10n.sessionNotABooking),
          const SizedBox(height: 20),
          if (session.isActive) ...[
            FilledButton.icon(
              key: addCatchKey,
              onPressed: () {
                pushAppPage(
                  context,
                  CatchFormScreen(
                    sessionId: session.id,
                    initialPondId: session.pondId,
                    initialPondName: session.pondName,
                  ),
                  '/catch-form',
                );
              },
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.addCatchToSession),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              key: endKey,
              onPressed: () => _end(context, session),
              child: Text(l10n.endSession),
            ),
            const SizedBox(height: 16),
          ],
          if (catches.isEmpty)
            Text(
              l10n.noCatchesYet,
              style: Theme.of(context).textTheme.bodyLarge,
            )
          else
            for (final item in catches) ...[
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(item.species),
                subtitle: Text(
                  DateFormat.yMMMd(locale).add_jm().format(item.caughtAt),
                ),
                onTap: () {
                  pushAppPage(
                    context,
                    CatchDetailScreen(catchId: item.id),
                    '/catch',
                  );
                },
              ),
            ],
          if (completed &&
              trip != null &&
              trip.status == TripStatus.planned) ...[
            const SizedBox(height: 8),
            OutlinedButton(
              key: const Key('session-complete-trip'),
              onPressed: () => _completeTrip(context, trip),
              child: Text(l10n.markLinkedTripCompleted),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _end(BuildContext context, FishingSession session) async {
    final confirmed = await confirmEndSession(context);
    if (!confirmed || !context.mounted) {
      return;
    }
    final saved = await context.read<AnglerRecordsController>().endSession(
      session.id,
    );
    if (!context.mounted || saved) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).couldNotSave)),
    );
  }

  Future<void> _completeTrip(BuildContext context, TripRecord trip) async {
    final saved = await context.read<AnglerRecordsController>().saveTrip(
      trip.copyWith(status: TripStatus.completed),
    );
    if (!context.mounted || saved) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).couldNotSave)),
    );
  }
}
