import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/angler_records_controller.dart';
import '../../controllers/pond_catalog_controller.dart';
import '../../core/constants/app_constants.dart';
import '../../core/navigation/fade_page_route.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../models/trip_record.dart';
import '../../widgets/detail_scaffold.dart';
import 'session_detail_screen.dart';

class SessionSetupScreen extends StatefulWidget {
  const SessionSetupScreen({super.key, this.initialPondId, this.initialTripId});

  final String? initialPondId;
  final String? initialTripId;

  static const Key titleKey = Key('session-title');
  static const Key notesKey = Key('session-notes');
  static const Key saveKey = Key('session-save');

  @override
  State<SessionSetupScreen> createState() => _SessionSetupScreenState();
}

class _SessionSetupScreenState extends State<SessionSetupScreen> {
  late final TextEditingController _title;
  late final TextEditingController _notes;
  late final TripRecord? _trip;
  String? _pondId;
  var _saving = false;

  @override
  void initState() {
    super.initState();
    final records = context.read<AnglerRecordsController>();
    final trip = widget.initialTripId == null
        ? null
        : records.tripById(widget.initialTripId!);
    _trip = trip != null && trip.status == TripStatus.planned ? trip : null;
    _title = TextEditingController(text: _trip?.title ?? '');
    _notes = TextEditingController();
    _pondId = widget.initialPondId ?? _trip?.pondId;
  }

  @override
  void dispose() {
    _title.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    if (_saving) {
      return;
    }
    setState(() => _saving = true);
    final records = context.read<AnglerRecordsController>();
    final ponds = context.read<PondCatalogController>().ponds;
    String? pondName;
    if (_pondId != null) {
      final matches = ponds.where((pond) => pond.id == _pondId);
      if (matches.isNotEmpty) {
        pondName = matches.first.name;
      } else if (_trip?.pondId == _pondId) {
        pondName = _trip?.pondName;
      }
    }
    final outcome = await records.startSession(
      title: _title.text,
      notes: _notes.text,
      tripId: _trip?.id,
      pondId: _pondId,
      pondName: pondName,
    );
    if (!mounted) {
      return;
    }
    setState(() => _saving = false);
    final l10n = AppLocalizations.of(context);
    if (outcome.failed || outcome.session == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.couldNotSave)));
      return;
    }
    if (!outcome.created) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.sessionInProgress)));
    }
    Navigator.of(context).pushReplacement(
      fadePageRoute(
        page: SessionDetailScreen(sessionId: outcome.session!.id),
        routeName: '/session',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final records = context.watch<AnglerRecordsController>();
    final active = records.activeSession;
    if (active != null) {
      return DetailScaffold(
        title: l10n.fishingSession,
        body: Padding(
          padding: const EdgeInsets.all(AppConstants.pageHorizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.sessionInProgress,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              FilledButton(
                key: const Key('session-resume'),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    fadePageRoute(
                      page: SessionDetailScreen(sessionId: active.id),
                      routeName: '/session',
                    ),
                  );
                },
                child: Text(l10n.resumeSession),
              ),
            ],
          ),
        ),
      );
    }

    final ponds = context.watch<PondCatalogController>().ponds;
    final knownPond =
        _pondId == null || ponds.any((pond) => pond.id == _pondId);

    return DetailScaffold(
      title: l10n.startSession,
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.all(AppConstants.pageHorizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.sessionNotABooking,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (_trip != null) ...[
              const SizedBox(height: 12),
              Text(_trip.title, style: Theme.of(context).textTheme.titleLarge),
            ],
            const SizedBox(height: 16),
            TextField(
              key: SessionSetupScreen.titleKey,
              controller: _title,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(labelText: l10n.sessionTitleLabel),
            ),
            const SizedBox(height: 12),
            TextField(
              key: SessionSetupScreen.notesKey,
              controller: _notes,
              minLines: 2,
              maxLines: 4,
              decoration: InputDecoration(labelText: l10n.notesOptional),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String?>(
              initialValue: knownPond ? _pondId : null,
              decoration: InputDecoration(labelText: l10n.selectPond),
              items: [
                DropdownMenuItem<String?>(
                  value: null,
                  child: Text(l10n.noPondSelected),
                ),
                for (final pond in ponds)
                  DropdownMenuItem<String?>(
                    value: pond.id,
                    child: Text(pond.name, overflow: TextOverflow.ellipsis),
                  ),
              ],
              onChanged: (value) => setState(() => _pondId = value),
            ),
            if (!knownPond && _trip?.pondName != null) ...[
              const SizedBox(height: 8),
              Text(_trip!.pondName!),
              Text(l10n.pondUnavailable),
            ],
            const SizedBox(height: 16),
            FilledButton(
              key: SessionSetupScreen.saveKey,
              onPressed: _saving ? null : _start,
              child: Text(_saving ? l10n.loadingRecords : l10n.startSession),
            ),
          ],
        ),
      ),
    );
  }
}
