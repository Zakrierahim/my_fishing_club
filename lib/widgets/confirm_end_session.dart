import 'package:flutter/material.dart';

import '../generated/l10n/app_localizations.dart';

Future<bool> confirmEndSession(BuildContext context) async {
  final l10n = AppLocalizations.of(context);
  final result = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(l10n.endSessionConfirmTitle),
        content: Text(l10n.endSessionConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            key: const Key('session-end-confirm'),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.endSession),
          ),
        ],
      );
    },
  );
  return result ?? false;
}
