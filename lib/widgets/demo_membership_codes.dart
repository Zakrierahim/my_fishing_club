import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../core/theme/app_colors.dart';
import '../generated/l10n/app_localizations.dart';
import '../models/pond_membership.dart';

/// Local preview codes for one demo membership. The value is the demo id only.
class DemoMembershipCodes extends StatelessWidget {
  const DemoMembershipCodes({
    super.key,
    required this.membership,
    this.showPondName = true,
  });

  final PondMembership membership;
  final bool showPondName;

  static const Key qrKey = Key('demo-qr-code');
  static const Key barcodeKey = Key('demo-barcode');

  @override
  Widget build(BuildContext context) {
    final memberId = membership.demoIdentifier;
    if (memberId == null) {
      return const SizedBox.shrink();
    }

    final l10n = AppLocalizations.of(context);
    final body = Theme.of(context).textTheme.bodyLarge;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.demoPreviewBadge,
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
          ),
        ),
        if (showPondName) ...[
          const SizedBox(height: 8),
          Text(
            membership.pondName,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
        const SizedBox(height: 8),
        Text('${l10n.memberId}: $memberId', style: body),
        const SizedBox(height: 8),
        Text(l10n.membershipNotVerified, style: body),
        const SizedBox(height: 8),
        Text(l10n.demoPassOnly, style: body),
        const SizedBox(height: 20),
        DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Column(
              children: [
                Text(
                  l10n.demoQrCode,
                  style: const TextStyle(
                    color: AppColors.background,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                DemoQrCode(key: qrKey, data: memberId),
                const SizedBox(height: 20),
                Text(
                  l10n.demoBarcode,
                  style: const TextStyle(
                    color: AppColors.background,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                DemoBarcode(key: barcodeKey, data: memberId),
                const SizedBox(height: 8),
                Text(
                  memberId,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.background,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Draws one local QR code. [data] is the only value encoded.
class DemoQrCode extends StatelessWidget {
  const DemoQrCode({super.key, required this.data});

  final String data;

  @override
  Widget build(BuildContext context) {
    return QrImageView(
      data: data,
      size: 180,
      backgroundColor: Colors.white,
      eyeStyle: const QrEyeStyle(
        eyeShape: QrEyeShape.square,
        color: AppColors.background,
      ),
      dataModuleStyle: const QrDataModuleStyle(
        dataModuleShape: QrDataModuleShape.square,
        color: AppColors.background,
      ),
    );
  }
}

/// Draws one local Code 128 barcode. [data] is the only value encoded.
class DemoBarcode extends StatelessWidget {
  const DemoBarcode({super.key, required this.data});

  final String data;

  @override
  Widget build(BuildContext context) {
    return BarcodeWidget(
      barcode: Barcode.code128(),
      data: data,
      width: double.infinity,
      height: 72,
      drawText: false,
      color: AppColors.background,
      backgroundColor: Colors.white,
    );
  }
}
