import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../controllers/angler_records_controller.dart';
import '../../controllers/pond_catalog_controller.dart';
import '../../core/constants/app_constants.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../models/trip_record.dart';
import '../../widgets/detail_scaffold.dart';

class TripFormScreen extends StatefulWidget {
  const TripFormScreen({super.key, this.existingId, this.initialPondId});

  final String? existingId;
  final String? initialPondId;

  static const Key titleKey = Key('trip-title');
  static const Key notesKey = Key('trip-notes');
  static const Key saveKey = Key('trip-save');

  @override
  State<TripFormScreen> createState() => _TripFormScreenState();
}

class _TripFormScreenState extends State<TripFormScreen> {
  late final TextEditingController _title;
  late final TextEditingController _notes;
  late DateTime _startsOn;
  DateTime? _endsOn;
  String? _pondId;
  TripStatus _status = TripStatus.planned;
  var _saving = false;
  String? _titleError;
  String? _dateError;

  @override
  void initState() {
    super.initState();
    final existing = widget.existingId == null
        ? null
        : context.read<AnglerRecordsController>().tripById(widget.existingId!);
    _title = TextEditingController(text: existing?.title ?? '');
    _notes = TextEditingController(text: existing?.notes ?? '');
    _startsOn = _dateOnly(existing?.startsOn ?? DateTime.now());
    _endsOn = existing?.endsOn == null ? null : _dateOnly(existing!.endsOn!);
    _pondId = existing?.pondId ?? widget.initialPondId;
    _status = existing?.status ?? TripStatus.planned;
  }

  @override
  void dispose() {
    _title.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _pickStart() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startsOn,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (picked == null) {
      return;
    }
    setState(() => _startsOn = _dateOnly(picked));
  }

  Future<void> _pickEnd() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endsOn ?? _startsOn,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (picked == null) {
      return;
    }
    setState(() => _endsOn = _dateOnly(picked));
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final title = _title.text.trim();
    final endTooEarly = _endsOn != null && _endsOn!.isBefore(_startsOn);
    setState(() {
      _titleError = title.isEmpty ? l10n.tripTitleRequired : null;
      _dateError = endTooEarly ? l10n.endBeforeStart : null;
    });
    if (_titleError != null || _dateError != null || _saving) {
      return;
    }

    setState(() => _saving = true);
    final records = context.read<AnglerRecordsController>();
    final ponds = context.read<PondCatalogController>().ponds;
    final id = widget.existingId ?? AnglerRecordsController.newId();
    String? pondName;
    if (_pondId != null) {
      final matches = ponds.where((pond) => pond.id == _pondId);
      pondName = matches.isEmpty
          ? records.tripById(id)?.pondName
          : matches.first.name;
    }
    final saved = await records.saveTrip(
      TripRecord(
        id: id,
        title: title,
        startsOn: _startsOn,
        endsOn: _endsOn,
        notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
        pondId: _pondId,
        pondName: pondName,
        status: _status,
      ),
    );
    if (!mounted) {
      return;
    }
    setState(() => _saving = false);
    if (!saved) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.couldNotSave)));
      return;
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ponds = context.watch<PondCatalogController>().ponds;
    final locale = Localizations.localeOf(context).toString();
    final editing = widget.existingId != null;
    final knownPond =
        _pondId == null || ponds.any((pond) => pond.id == _pondId);

    return DetailScaffold(
      title: editing ? l10n.editTrip : l10n.planATrip,
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.all(AppConstants.pageHorizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.notAReservation,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            TextField(
              key: TripFormScreen.titleKey,
              controller: _title,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: l10n.tripTitleLabel,
                errorText: _titleError,
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _pickStart,
              child: Text(
                '${l10n.startDate}: ${DateFormat.yMMMd(locale).format(_startsOn)}',
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: _pickEnd,
              child: Text(
                _endsOn == null
                    ? l10n.endDate
                    : '${l10n.endDate}: ${DateFormat.yMMMd(locale).format(_endsOn!)}',
              ),
            ),
            if (_endsOn != null)
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () => setState(() => _endsOn = null),
                  child: Text(l10n.clearEndDate),
                ),
              ),
            if (_dateError != null)
              Text(
                _dateError!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            const SizedBox(height: 12),
            if (ponds.isEmpty)
              Text(l10n.noPondsForTrip)
            else
              DropdownButtonFormField<String?>(
                initialValue: knownPond ? _pondId : null,
                isExpanded: true,
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
            const SizedBox(height: 12),
            TextField(
              key: TripFormScreen.notesKey,
              controller: _notes,
              minLines: 2,
              maxLines: 4,
              decoration: InputDecoration(labelText: l10n.notesOptional),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.savedOnDeviceOnly,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            FilledButton(
              key: TripFormScreen.saveKey,
              onPressed: _saving ? null : _save,
              child: Text(_saving ? l10n.loadingRecords : l10n.save),
            ),
          ],
        ),
      ),
    );
  }
}

DateTime _dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);
