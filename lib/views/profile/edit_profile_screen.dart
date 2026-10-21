import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/profile_controller.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../widgets/detail_scaffold.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  static const Key nameKey = Key('profile-name-field');
  static const Key saveKey = Key('profile-save');

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _name;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(
      text: context.read<ProfileController>().displayName ?? '',
    );
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _save() {
    context.read<ProfileController>().setDisplayName(_name.text);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final fieldStyle = Theme.of(
      context,
    ).textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary);

    return DetailScaffold(
      title: l10n.editProfile,
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.pageHorizontalPadding),
        children: [
          TextField(
            key: EditProfileScreen.nameKey,
            controller: _name,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _save(),
            style: fieldStyle,
            decoration: InputDecoration(hintText: l10n.displayName),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.savedOnDeviceOnly,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          FilledButton(
            key: EditProfileScreen.saveKey,
            onPressed: _save,
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }
}
