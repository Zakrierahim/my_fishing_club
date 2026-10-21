import 'dart:math' as math;

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_fishing_club/app.dart';
import 'package:my_fishing_club/data/dummy/dummy_fishing_data.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:my_fishing_club/core/constants/app_constants.dart';
import 'package:my_fishing_club/generated/l10n/app_localizations.dart';
import 'package:my_fishing_club/views/explore/explore_screen.dart';
import 'package:my_fishing_club/views/explore/pond_details_screen.dart';
import 'package:my_fishing_club/widgets/pond_card.dart';
import 'package:my_fishing_club/views/home/home_screen.dart';
import 'package:my_fishing_club/views/login/login_screen.dart';
import 'package:my_fishing_club/views/pass/fishing_pass_screen.dart';
import 'package:my_fishing_club/views/settings/settings_screen.dart';
import 'package:my_fishing_club/widgets/demo_data_banner.dart';
import 'package:my_fishing_club/widgets/demo_membership_codes.dart';

import 'support/tap_clear_of_nav.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppLocalizations en;

  setUpAll(() async {
    en = await AppLocalizations.delegate.load(const Locale('en'));
  });

  Future<void> openMain(
    WidgetTester tester, {
    bool useDummyData = false,
  }) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(FishingApp(useDummyData: useDummyData));
    await tester.pump(AppConstants.splashDuration);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(LoginScreen.loginButtonKey));
    await tester.tap(find.byKey(LoginScreen.loginButtonKey));
    await tester.pumpAndSettle();
  }

  Finder pondList() {
    return find.descendant(
      of: find.byKey(ExploreScreen.listKey),
      matching: find.byWidgetPredicate(
        (widget) =>
            widget is Scrollable && widget.axisDirection == AxisDirection.down,
      ),
    );
  }

  Future<void> revealPond(WidgetTester tester, String id) async {
    await tester.scrollUntilVisible(
      find.byKey(ValueKey<String>('pond-$id')),
      400,
      scrollable: pondList(),
    );
    await tester.pumpAndSettle();
  }

  Future<void> openPond(WidgetTester tester, String id) async {
    await revealPond(tester, id);
    final card = find.byKey(ValueKey<String>('pond-$id'));
    final listBox = tester.getRect(find.byKey(ExploreScreen.listKey));
    final cardBox = tester.getRect(card);
    final top = math.max(cardBox.top, listBox.top);
    final bottom = math.min(cardBox.bottom, listBox.bottom);
    await tester.tapAt(Offset(cardBox.center.dx, (top + bottom) / 2));
    await tester.pumpAndSettle();
  }

  testWidgets('production defaults stay empty without demo data', (
    tester,
  ) async {
    await openMain(tester);

    expect(find.text('Kolam Pancing MV (Air Masin)'), findsNothing);
    expect(find.text('Demo Pond Alpha'), findsNothing);
    expect(find.byKey(DemoDataBanner.bannerKey), findsNothing);
    expect(find.text(en.noMembershipYet), findsOneWidget);
    expect(find.text(en.verifiedMembership), findsNothing);
    expect(find.text(DummyFishingData.demoMemberId), findsNothing);

    await tapClearOfNav(tester, find.byKey(HomeScreen.passKey));
    expect(find.byKey(FishingPassScreen.emptyKey), findsOneWidget);
    expect(find.byType(QrImageView), findsNothing);
    expect(find.byType(BarcodeWidget), findsNothing);
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.explore_rounded));
    await tester.pumpAndSettle();
    expect(find.text(en.noPondsYet), findsOneWidget);
  });

  testWidgets('demo preview shows the sample ponds and one demo membership', (
    tester,
  ) async {
    await openMain(tester, useDummyData: true);

    expect(find.byKey(DemoDataBanner.bannerKey), findsWidgets);
    expect(find.text('Kolam Pancing MV (Air Masin)'), findsOneWidget);
    expect(find.text('Demo Pond Alpha'), findsNothing);
    expect(find.text(en.previewData), findsWidgets);
    expect(find.text(en.demoPreview), findsWidgets);
    expect(find.text(en.notVerifiedMembership), findsWidgets);
    expect(find.text(en.verifiedMembership), findsNothing);

    await tester.tap(find.byIcon(Icons.explore_rounded));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(ExploreScreen.searchKey), 'Aduro');
    await tester.pumpAndSettle();
    expect(find.byType(PondCard), findsOneWidget);
    expect(find.text('Ulu Bendul Fish Valley'), findsNothing);

    await openPond(tester, 'kolam-pancing-air-masin-aduro');
    expect(find.text(en.imageUnavailable), findsWidgets);
    expect(find.text('${en.price}: ${en.notConfirmed}'), findsOneWidget);
    expect(find.text('${en.openingHours}: ${en.notConfirmed}'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text(en.searchInGoogleMaps),
      300,
      scrollable: find.descendant(
        of: find.byType(PondDetailsScreen),
        matching: find.byType(Scrollable),
      ),
    );
    expect(find.text(en.searchInGoogleMaps), findsOneWidget);
    expect(find.text(en.openInGoogleMaps), findsNothing);
    expect(find.textContaining('${en.coordinatesLabel}:'), findsNothing);
    expect(find.text(en.verifiedMembership), findsNothing);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(ExploreScreen.searchKey), 'Ulu Bendul');
    await tester.pumpAndSettle();
    await openPond(tester, 'ulu-bendul-fish-valley');
    await tester.scrollUntilVisible(
      find.textContaining('RM100'),
      300,
      scrollable: find.descendant(
        of: find.byType(PondDetailsScreen),
        matching: find.byType(Scrollable),
      ),
    );
    expect(find.textContaining('RM100'), findsOneWidget);
    expect(find.textContaining('Khamis rehat'), findsOneWidget);
    expect(find.text('${en.speciesLabel}: ${en.notConfirmed}'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text(en.noMembershipAtPond),
      300,
      scrollable: find.descendant(
        of: find.byType(PondDetailsScreen),
        matching: find.byType(Scrollable),
      ),
    );
    expect(find.text(en.noMembershipAtPond), findsOneWidget);
    expect(find.text(en.verifiedMembership), findsNothing);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.home_rounded));
    await tester.pumpAndSettle();
    await tapClearOfNav(tester, find.byKey(HomeScreen.passKey));
    expect(find.byKey(FishingPassScreen.demoBannerKey), findsOneWidget);
    expect(find.text(en.qrUnavailable), findsNothing);
    expect(find.text(en.verifiedMembership), findsNothing);
    expect(find.text(en.demoPreviewBadge), findsOneWidget);
    expect(find.text(en.demoQrCode), findsOneWidget);
    expect(find.text(en.demoBarcode), findsOneWidget);
    expect(find.text(en.demoPassOnly), findsOneWidget);
    expect(find.text(en.membershipNotVerified), findsOneWidget);
    expect(
      tester.widget<DemoQrCode>(find.byKey(DemoMembershipCodes.qrKey)).data,
      DummyFishingData.demoMemberId,
    );
    expect(
      tester
          .widget<DemoBarcode>(find.byKey(DemoMembershipCodes.barcodeKey))
          .data,
      DummyFishingData.demoMemberId,
    );
    final barcode = tester.widget<BarcodeWidget>(find.byType(BarcodeWidget));
    expect(String.fromCharCodes(barcode.data), DummyFishingData.demoMemberId);
    expect(barcode.barcode.name, 'CODE 128');
    expect(find.text(DummyFishingData.demoMemberId), findsWidgets);
    expect(find.byType(QrImageView), findsOneWidget);
    expect(find.byType(BarcodeWidget), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text(en.checkInUnavailable),
      300,
      scrollable: find.descendant(
        of: find.byType(FishingPassScreen),
        matching: find.byType(Scrollable),
      ),
    );
    expect(find.text(en.checkInUnavailable), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tapClearOfNav(tester, find.byKey(HomeScreen.membershipsKey));
    expect(
      find.text('${en.memberId}: ${DummyFishingData.demoMemberId}'),
      findsWidgets,
    );
    expect(find.text(en.demoPassOnly), findsWidgets);
    expect(find.text(en.verifiedMembership), findsNothing);
    expect(
      tester.widget<DemoQrCode>(find.byKey(DemoMembershipCodes.qrKey)).data,
      DummyFishingData.demoMemberId,
    );

    await tester.tap(find.text('Kolam Pancing MV (Air Masin)'));
    await tester.pumpAndSettle();
    expect(find.text(en.membershipNotVerified), findsOneWidget);
    expect(find.text(en.verifiedMembership), findsNothing);
    expect(
      tester
          .widget<DemoBarcode>(find.byKey(DemoMembershipCodes.barcodeKey))
          .data,
      DummyFishingData.demoMemberId,
    );
    expect(
      String.fromCharCodes(
        tester.widget<BarcodeWidget>(find.byType(BarcodeWidget)).data,
      ),
      DummyFishingData.demoMemberId,
    );
  });

  testWidgets('the settings switch turns the sample ponds on and off', (
    tester,
  ) async {
    await openMain(tester);

    await tester.tap(find.byIcon(Icons.settings_rounded));
    await tester.pumpAndSettle();
    await tapClearOfNav(tester, find.byKey(SettingsScreen.demoDataKey));

    await tester.tap(find.byIcon(Icons.explore_rounded));
    await tester.pumpAndSettle();
    await revealPond(tester, 'kolam-pancing-mv');
    expect(find.text('Kolam Pancing MV (Air Masin)'), findsOneWidget);
    await revealPond(tester, 'kolam-pancing-air-masin-aduro');
    expect(find.text('Kolam Pancing Air Masin Aduro'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.settings_rounded));
    await tester.pumpAndSettle();
    await tapClearOfNav(tester, find.byKey(SettingsScreen.demoDataKey));

    await tester.tap(find.byIcon(Icons.explore_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Kolam Pancing MV (Air Masin)'), findsNothing);
    expect(find.text(en.noPondsYet), findsOneWidget);
  });
}
