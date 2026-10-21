import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/angler_records_controller.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../views/sessions/session_detail_screen.dart';
import '../../views/sessions/session_list_screen.dart';
import '../../views/sessions/session_setup_screen.dart';
import 'open_explore.dart';

/// Opens the active session, or the setup screen when none is active.
void openFishingSession(
  BuildContext context, {
  String? pondId,
  String? tripId,
}) {
  final active = context.read<AnglerRecordsController>().activeSession;
  if (active != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).sessionInProgress)),
    );
    pushAppPage(context, SessionDetailScreen(sessionId: active.id), '/session');
    return;
  }
  pushAppPage(
    context,
    SessionSetupScreen(initialPondId: pondId, initialTripId: tripId),
    '/session-setup',
  );
}

void openFishingHistory(BuildContext context) {
  pushAppPage(context, const SessionListScreen(), '/sessions');
}
