import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_fishing_club/app.dart';
import 'package:my_fishing_club/controllers/membership_controller.dart';
import 'package:my_fishing_club/controllers/pond_catalog_controller.dart';
import 'package:my_fishing_club/core/constants/app_constants.dart';
import 'package:my_fishing_club/generated/l10n/app_localizations.dart';
import 'package:my_fishing_club/models/pond.dart';
import 'package:my_fishing_club/models/pond_membership.dart';
import 'package:my_fishing_club/views/explore/explore_screen.dart';
import 'package:my_fishing_club/views/home/home_screen.dart';
import 'package:my_fishing_club/views/login/login_screen.dart';
import 'package:my_fishing_club/views/membership/memberships_screen.dart';
import 'package:my_fishing_club/views/membership/membership_detail_screen.dart';
import 'package:my_fishing_club/views/notification/notification_screen.dart';
import 'package:my_fishing_club/views/pass/fishing_pass_screen.dart';
import 'package:my_fishing_club/views/profile/edit_profile_screen.dart';
import 'package:my_fishing_club/views/profile/profile_screen.dart';
import 'package:my_fishing_club/views/settings/settings_screen.dart';

import 'support/tap_clear_of_nav.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppLocalizations en;

  setUpAll(() async {
    en = await AppLocalizations.delegate.load(const Locale('en'));
  });

  Future<void> openMain(
    WidgetTester tester, {
    PondCatalogController? pondCatalog,
    MembershipController? membershipController,
  }) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(
      FishingApp(
        pondCatalog: pondCatalog,
        membershipController: membershipController,
      ),
    );
    await tester.pump(AppConstants.splashDuration);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(LoginScreen.loginButtonKey));
    await tester.tap(find.byKey(LoginScreen.loginButtonKey));
    await tester.pumpAndSettle();
  }

  testWidgets('memberships, profile, and notifications stay empty', (
    tester,
  ) async {
    await openMain(tester);

    await tapClearOfNav(tester, find.byKey(HomeScreen.membershipsKey));
    expect(find.text(en.noMembershipYet), findsWidgets);
    expect(find.text(en.membershipsEmptyBody), findsOneWidget);

    await tester.tap(find.byKey(MembershipsScreen.exploreKey));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey<String>('page-heading-Explore')),
      findsOneWidget,
    );

    await tester.tap(find.byIcon(Icons.settings_rounded));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(SettingsScreen.profileKey));
    await tester.tap(find.byKey(SettingsScreen.profileKey));
    await tester.pumpAndSettle();
    expect(find.text(en.nameNotSet), findsOneWidget);
    expect(find.text(en.unavailable), findsNWidgets(2));

    await tester.tap(find.byKey(ProfileScreen.editKey));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(EditProfileScreen.nameKey), 'Aina');
    await tester.tap(find.byKey(EditProfileScreen.saveKey));
    await tester.pumpAndSettle();
    expect(find.text('Aina'), findsOneWidget);
    expect(find.text(en.unavailable), findsNWidgets(2));

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.notifications_rounded));
    await tester.pumpAndSettle();
    expect(find.byKey(NotificationScreen.emptyKey), findsOneWidget);
    expect(find.text(en.noNotificationsBody), findsOneWidget);
  });

  testWidgets('pond search and filters use the supplied dataset', (
    tester,
  ) async {
    final catalog = PondCatalogController(
      ponds: const [
        Pond(
          id: 'north',
          name: 'North Test Pond',
          species: ['Test Carp'],
          pondType: 'Pay pond',
        ),
        Pond(
          id: 'south',
          name: 'South Test Pond',
          species: ['Test Catfish'],
          pondType: 'Public pond',
        ),
      ],
    );
    await openMain(tester, pondCatalog: catalog);

    await tester.tap(find.byIcon(Icons.explore_rounded));
    await tester.pumpAndSettle();
    expect(find.text('North Test Pond'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('South Test Pond'),
      300,
      scrollable: find.descendant(
        of: find.byKey(ExploreScreen.listKey),
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is Scrollable &&
              widget.axisDirection == AxisDirection.down,
        ),
      ),
    );
    expect(find.text('South Test Pond'), findsOneWidget);

    await tester.enterText(find.byKey(ExploreScreen.searchKey), 'North');
    await tester.pumpAndSettle();
    expect(find.text('North Test Pond'), findsOneWidget);
    expect(find.text('South Test Pond'), findsNothing);

    await tester.tap(find.text(en.clearFilters));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilterChip, 'Public pond'));
    await tester.pumpAndSettle();
    expect(find.text('South Test Pond'), findsOneWidget);
    expect(find.text('North Test Pond'), findsNothing);

    await tester.ensureVisible(find.text('South Test Pond'));
    await tester.tap(find.text('South Test Pond'));
    await tester.pumpAndSettle();
    expect(find.text(en.pondDetails), findsOneWidget);
    expect(find.text(en.noMembershipAtPond), findsOneWidget);
  });

  testWidgets('a demo membership is never shown as verified', (tester) async {
    final memberships = MembershipController(
      memberships: const [
        PondMembership(
          id: 'demo-1',
          pondId: 'north',
          pondName: 'North Test Pond',
          standing: MembershipStanding.demoPreview,
        ),
      ],
    );
    await openMain(tester, membershipController: memberships);

    expect(find.text(en.demoPreview), findsWidgets);
    expect(find.text(en.verifiedMembership), findsNothing);
    expect(find.text(en.notVerifiedMembership), findsOneWidget);

    await tapClearOfNav(tester, find.byKey(HomeScreen.passKey));

    expect(find.byKey(FishingPassScreen.demoBannerKey), findsOneWidget);
    expect(find.text(en.demoPassBody), findsOneWidget);
    expect(find.text(en.qrUnavailable), findsOneWidget);
    expect(find.text(en.checkInUnavailable), findsOneWidget);
    expect(find.text(en.verifiedMembership), findsNothing);
    expect(find.byKey(FishingPassScreen.qrSlotKey), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tapClearOfNav(tester, find.byKey(HomeScreen.membershipsKey));
    await tester.tap(find.text('North Test Pond'));
    await tester.pumpAndSettle();

    expect(
      tester.widget<Text>(find.byKey(MembershipDetailScreen.standingKey)).data,
      en.demoPreview,
    );
    expect(find.text(en.verifiedMembership), findsNothing);
  });

  testWidgets('new screens fit a small phone and a landscape layout', (
    tester,
  ) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    for (final size in const <Size>[Size(320, 568), Size(844, 390)]) {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = size;
      await openMain(tester);

      await tapClearOfNav(tester, find.byKey(HomeScreen.passKey));
      expect(find.byKey(FishingPassScreen.emptyKey), findsOneWidget);

      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.notifications_rounded));
      await tester.pumpAndSettle();
      expect(find.byKey(NotificationScreen.emptyKey), findsOneWidget);
    }
  });
}
