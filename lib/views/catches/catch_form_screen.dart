import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../controllers/angler_records_controller.dart';
import '../../controllers/pond_catalog_controller.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../models/catch_record.dart';
import '../../services/catch_photo_store.dart';
import '../../widgets/detail_scaffold.dart';

class CatchFormScreen extends StatefulWidget {
  const CatchFormScreen({
    super.key,
    this.existingId,
    this.sessionId,
    this.initialPondId,
    this.initialPondName,
  });

  final String? existingId;
  final String? sessionId;
  final String? initialPondId;
  final String? initialPondName;

  static const Key speciesKey = Key('catch-species');
  static const Key weightKey = Key('catch-weight');
  static const Key lengthKey = Key('catch-length');
  static const Key notesKey = Key('catch-notes');
  static const Key saveKey = Key('catch-save');

  @override
  State<CatchFormScreen> createState() => _CatchFormScreenState();
}

class _CatchFormScreenState extends State<CatchFormScreen> {
  late final TextEditingController _species;
  late final TextEditingController _weight;
  late final TextEditingController _length;
  late final TextEditingController _notes;
  late DateTime _caughtAt;
  String? _pondId;
  String? _sessionId;
  String? _photoPath;
  var _photoIsNew = false;
  var _saving = false;
  String? _speciesError;
  String? _numberError;

  @override
  void initState() {
    super.initState();
    final existing = widget.existingId == null
        ? null
        : context.read<AnglerRecordsController>().catchById(widget.existingId!);
    _species = TextEditingController(text: existing?.species ?? '');
    _weight = TextEditingController(text: _number(existing?.weightKg));
    _length = TextEditingController(text: _number(existing?.lengthCm));
    _notes = TextEditingController(text: existing?.notes ?? '');
    _caughtAt = existing?.caughtAt ?? DateTime.now();
    _pondId = existing?.pondId ?? widget.initialPondId;
    _sessionId = existing?.sessionId ?? widget.sessionId;
    _photoPath = existing?.photoPath;
  }

  @override
  void dispose() {
    _species.dispose();
    _weight.dispose();
    _length.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _caughtAt,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked == null) {
      return;
    }
    setState(() {
      _caughtAt = DateTime(
        picked.year,
        picked.month,
        picked.day,
        _caughtAt.hour,
        _caughtAt.minute,
      );
    });
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_caughtAt),
    );
    if (picked == null) {
      return;
    }
    setState(() {
      _caughtAt = DateTime(
        _caughtAt.year,
        _caughtAt.month,
        _caughtAt.day,
        picked.hour,
        picked.minute,
      );
    });
  }

  Future<void> _pickPhoto() async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (image == null || !mounted) {
        return;
      }
      setState(() {
        _photoPath = image.path;
        _photoIsNew = true;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).photoUnavailable)),
      );
    }
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final species = _species.text.trim();
    final weight = _optionalNumber(_weight.text);
    final length = _optionalNumber(_length.text);
    setState(() {
      _speciesError = species.isEmpty ? l10n.speciesRequired : null;
      _numberError =
          weight == null && _weight.text.trim().isNotEmpty ||
              length == null && _length.text.trim().isNotEmpty
          ? l10n.invalidNumber
          : null;
    });
    if (_speciesError != null || _numberError != null || _saving) {
      return;
    }

    setState(() => _saving = true);
    final records = context.read<AnglerRecordsController>();
    final id = widget.existingId ?? AnglerRecordsController.newId();
    var photo = _photoPath;
    if (_photoIsNew && photo != null) {
      final stored = await persistCatchPhoto(sourcePath: photo, catchId: id);
      if (!mounted) {
        return;
      }
      if (stored == null) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.photoUnavailable)));
        return;
      }
      photo = stored;
    }

    final ponds = context.read<PondCatalogController>().ponds;
    String? pondName;
    if (_pondId != null) {
      final matches = ponds.where((pond) => pond.id == _pondId);
      if (matches.isNotEmpty) {
        pondName = matches.first.name;
      } else {
        pondName =
            records.catchById(id)?.pondName ??
            (_pondId == widget.initialPondId ? widget.initialPondName : null);
      }
    }
    final saved = await records.saveCatch(
      CatchRecord(
        id: id,
        species: species,
        caughtAt: _caughtAt,
        weightKg: weight,
        lengthCm: length,
        notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
        photoPath: photo,
        pondId: _pondId,
        pondName: pondName,
        sessionId: _sessionId,
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
      title: editing ? l10n.editCatch : l10n.addCatch,
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.all(AppConstants.pageHorizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              key: CatchFormScreen.speciesKey,
              controller: _species,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: l10n.speciesLabel,
                errorText: _speciesError,
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _pickDate,
              child: Text(
                '${l10n.catchDate}: ${DateFormat.yMMMd(locale).format(_caughtAt)}',
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: _pickTime,
              child: Text(
                '${l10n.catchTime}: ${DateFormat.jm(locale).format(_caughtAt)}',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              key: CatchFormScreen.weightKey,
              controller: _weight,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: l10n.weightKg,
                errorText: _numberError,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              key: CatchFormScreen.lengthKey,
              controller: _length,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(labelText: l10n.lengthCm),
            ),
            const SizedBox(height: 12),
            TextField(
              key: CatchFormScreen.notesKey,
              controller: _notes,
              minLines: 2,
              maxLines: 4,
              decoration: InputDecoration(labelText: l10n.notesOptional),
            ),
            if (_sessionId != null) ...[
              const SizedBox(height: 12),
              Text(
                l10n.sessionCatchLinked,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
            const SizedBox(height: 12),
            DropdownButtonFormField<String?>(
              initialValue: knownPond ? _pondId : null,
              decoration: InputDecoration(labelText: l10n.associatedPond),
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
            if (!knownPond) ...[
              const SizedBox(height: 8),
              Text(l10n.pondUnavailable),
            ],
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _saving ? null : _pickPhoto,
              icon: const Icon(Icons.photo_outlined),
              label: Text(l10n.addPhoto),
            ),
            if (_photoPath != null) ...[
              const SizedBox(height: 8),
              Text(
                l10n.photoSelected,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _photoPath = null;
                    _photoIsNew = false;
                  });
                },
                child: Text(l10n.removePhoto),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              l10n.savedOnDeviceOnly,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            FilledButton(
              key: CatchFormScreen.saveKey,
              onPressed: _saving ? null : _save,
              child: Text(_saving ? l10n.loadingRecords : l10n.save),
            ),
          ],
        ),
      ),
    );
  }
}

String _number(double? value) {
  if (value == null) {
    return '';
  }
  if (value == value.roundToDouble()) {
    return value.toStringAsFixed(0);
  }
  return value.toString();
}

double? _optionalNumber(String raw) {
  final trimmed = raw.trim().replaceAll(',', '.');
  if (trimmed.isEmpty) {
    return null;
  }
  final value = double.tryParse(trimmed);
  if (value == null || value.isNaN || value < 0) {
    return null;
  }
  return value;
}
