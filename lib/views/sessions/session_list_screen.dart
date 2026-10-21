import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../controllers/angler_records_controller.dart';
import '../../core/constants/app_constants.dart';
import '../../core/navigation/open_explore.dart';
import '../../core/theme/app_colors.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../models/fishing_session.dart';
import '../../widgets/detail_scaffold.dart';
import 'session_detail_screen.dart';
import 'session_format.dart';
import 'session_setup_screen.dart';

class SessionListScreen extends StatelessWidget {
  const SessionListScreen({super.key});

  static const Key emptyKey = Key('sessions-empty');
  static const Key startKey = Key('session-start');

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final records = context.watch<AnglerRecordsController>();
    final items = records.sessions;
    final active = [
      for (final session in items)
        if (session.isActive) session,
    ];
    final completed = [
      for (final session in items)
        if (!session.isActive) session,
    ];

    return DetailScaffold(
      title: l10n.fishingHistory,
      titleKey: const Key('sessions-heading'),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.pageHorizontalPadding),
        children: [
          Text(
            l10n.sessionNotABooking,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          if (records.loadFailed) ...[
            const SizedBox(height: 12),
            Text(l10n.recordsLoadFailed),
          ],
          const SizedBox(height: 16),
          if (records.loading)
            Text(l10n.loadingRecords)
          else if (items.isEmpty) ...[
            Text(
              l10n.noSessionsYet,
              key: emptyKey,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: FilledButton(
                key: startKey,
                onPressed: () {
                  pushAppPage(
                    context,
                    const SessionSetupScreen(),
                    '/session-setup',
                  );
                },
                child: Text(l10n.startSession),
              ),
            ),
          ] else ...[
            if (active.isNotEmpty) ...[
              Text(
                l10n.activeSessionSection,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              for (final session in active) ...[
                _SessionTile(session: session),
                const SizedBox(height: 8),
              ],
              const SizedBox(height: 12),
            ],
            if (completed.isNotEmpty) ...[
              Text(
                l10n.completedSessionsSection,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              for (final session in completed) ...[
                _SessionTile(session: session),
                const SizedBox(height: 8),
              ],
            ],
          ],
        ],
      ),
    );
  }
}

class _SessionTile extends StatelessWidget {
  const _SessionTile({required this.session});

  final FishingSession session;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final records = context.watch<AnglerRecordsController>();
    final locale = Localizations.localeOf(context).toString();
    final when = DateFormat.yMMMd(locale).add_jm().format(session.startedAt);
    final duration = sessionDurationLabel(
      l10n,
      session.elapsedUntil(DateTime.now()),
    );
    final pond = session.pondName ?? l10n.noPondOnSession;
    final count = records.catchesForSession(session.id).length;

    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          pushAppPage(
            context,
            SessionDetailScreen(sessionId: session.id),
            '/session',
          );
        },
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 72),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sessionTitle(l10n, session),
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$when · $duration',
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 2),
                Text(
                  '$pond · ${l10n.sessionCatchCount(count)}',
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
