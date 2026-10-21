import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_fishing_club/controllers/angler_records_controller.dart';
import 'package:my_fishing_club/controllers/membership_controller.dart';
import 'package:my_fishing_club/controllers/pond_catalog_controller.dart';
import 'package:my_fishing_club/core/theme/app_theme.dart';
import 'package:my_fishing_club/data/dummy/dummy_fishing_data.dart';
import 'package:my_fishing_club/data/dummy/providers/dummy_fishing_data_provider.dart';
import 'package:my_fishing_club/data/repositories/angler_records_repository.dart';
import 'package:my_fishing_club/generated/l10n/app_localizations.dart';
import 'package:my_fishing_club/models/catch_record.dart';
import 'package:my_fishing_club/models/trip_record.dart';
import 'package:my_fishing_club/views/catches/catch_form_screen.dart';
import 'package:my_fishing_club/views/explore/pond_details_screen.dart';
import 'package:my_fishing_club/views/home/home_screen.dart';
import 'package:my_fishing_club/views/sessions/session_detail_screen.dart';
import 'package:my_fishing_club/views/sessions/session_list_screen.dart';
import 'package:my_fishing_club/views/sessions/session_setup_screen.dart';
import 'package:my_fishing_club/views/trips/trip_detail_screen.dart';
import 'package:provider/provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<AnglerRecordsController> records() async {
    final controller = AnglerRecordsController(
      repository: MemoryAnglerRecordsRepository(),
    );
    await Future<void>.value();
    return controller;
  }

  Widget harness({
    required Widget home,
    required AnglerRecordsController store,
    Locale locale = const Locale('en'),
  }) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AnglerRecordsController>.value(value: store),
        ChangeNotifierProvider(
          create: (_) => PondCatalogController(ponds: DummyFishingData.ponds),
        ),
        ChangeNotifierProvider(create: (_) => MembershipController()),
        ChangeNotifierProvider(
          create: (_) => DummyFishingDataProvider(enabled: false),
        ),
      ],
      child: MaterialApp(
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.dark,
        home: home,
      ),
    );
  }

  testWidgets('Home starts a session and opens it', (tester) async {
    final store = await records();
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    await tester.pumpWidget(harness(store: store, home: const HomeScreen()));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(const Key('session-start')));
    await tester.tap(find.byKey(const Key('session-start')));
    await tester.pumpAndSettle();
    expect(find.byKey(SessionSetupScreen.saveKey), findsOneWidget);

    await tester.tap(find.byKey(SessionSetupScreen.saveKey));
    await tester.pumpAndSettle();

    expect(store.activeSession, isNotNull);
    expect(store.activeSession!.tripId, isNull);
    expect(store.activeSession!.pondId, isNull);
    expect(find.text(l10n.sessionActive), findsOneWidget);
    expect(find.byKey(SessionDetailScreen.addCatchKey), findsOneWidget);
  });

  testWidgets('a planned trip can start a session without booking the pond', (
    tester,
  ) async {
    final store = await records();
    await store.saveTrip(
      TripRecord(
        id: 'trip-1',
        title: 'Saturday morning',
        startsOn: DateTime.utc(2026, 10, 25),
        pondId: DummyFishingData.mvId,
        pondName: 'Kolam Pancing MV (Air Masin)',
      ),
    );
    await tester.pumpWidget(
      harness(
        store: store,
        home: const TripDetailScreen(tripId: 'trip-1'),
      ),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(const Key('trip-start-session')));
    await tester.tap(find.byKey(const Key('trip-start-session')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(SessionSetupScreen.saveKey));
    await tester.pumpAndSettle();

    expect(store.activeSession!.tripId, 'trip-1');
    expect(store.activeSession!.pondId, DummyFishingData.mvId);
    expect(store.activeSession!.pondName, 'Kolam Pancing MV (Air Masin)');
    expect(store.tripById('trip-1')!.status, TripStatus.planned);
    expect(
      DummyFishingData.ponds.map((pond) => pond.name),
      isNot(contains('Saturday morning')),
    );
  });

  testWidgets('pond details starts a session with that pond preselected', (
    tester,
  ) async {
    final store = await records();
    final pond = DummyFishingData.ponds.firstWhere(
      (item) => item.id == DummyFishingData.mvId,
    );
    await tester.pumpWidget(
      harness(
        store: store,
        home: PondDetailsScreen(pond: pond),
      ),
    );
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.byKey(const Key('pond-start-session')),
      400,
      scrollable: find.descendant(
        of: find.byType(PondDetailsScreen),
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is Scrollable &&
              widget.axisDirection == AxisDirection.down,
        ),
      ),
    );
    await tester.tap(find.byKey(const Key('pond-start-session')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(SessionSetupScreen.saveKey));
    await tester.pumpAndSettle();

    expect(store.activeSession!.pondId, DummyFishingData.mvId);
    expect(store.activeSession!.pondName, pond.name);
    expect(store.activeSession!.tripId, isNull);
  });

  testWidgets('the active session adds a catch and ends into a summary', (
    tester,
  ) async {
    final store = await records();
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    final started = await store.startSession(
      title: 'Dawn',
      pondId: DummyFishingData.mvId,
      pondName: 'Kolam Pancing MV (Air Masin)',
      startedAt: DateTime.utc(2026, 10, 21, 6),
    );
    await tester.pumpWidget(
      harness(
        store: store,
        home: SessionDetailScreen(sessionId: started.session!.id),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(l10n.sessionActive), findsOneWidget);
    expect(find.text('Dawn'), findsOneWidget);
    await tester.tap(find.byKey(SessionDetailScreen.addCatchKey));
    await tester.pumpAndSettle();
    expect(find.text(l10n.sessionCatchLinked), findsOneWidget);
    await tester.enterText(find.byKey(CatchFormScreen.speciesKey), 'Siakap');
    await tester.ensureVisible(find.byKey(CatchFormScreen.saveKey));
    await tester.tap(find.byKey(CatchFormScreen.saveKey));
    await tester.pumpAndSettle();

    expect(store.catches.single.sessionId, started.session!.id);
    expect(store.catches.single.pondId, DummyFishingData.mvId);
    expect(find.text('Siakap'), findsOneWidget);

    await tester.ensureVisible(find.byKey(SessionDetailScreen.endKey));
    await tester.tap(find.byKey(SessionDetailScreen.endKey));
    await tester.pumpAndSettle();
    expect(find.text(l10n.endSessionConfirmTitle), findsOneWidget);
    await tester.tap(find.byKey(const Key('session-end-confirm')));
    await tester.pumpAndSettle();

    expect(store.activeSession, isNull);
    expect(find.text(l10n.sessionSummary), findsOneWidget);
    expect(find.text(l10n.sessionCompleted), findsOneWidget);
    expect(find.byKey(SessionDetailScreen.addCatchKey), findsNothing);
    expect(find.text('Siakap'), findsOneWidget);
    expect(store.catches.single.sessionId, started.session!.id);
  });

  testWidgets('ending shows an error and stays active when saving fails', (
    tester,
  ) async {
    final repository = MemoryAnglerRecordsRepository();
    final store = AnglerRecordsController(repository: repository);
    await Future<void>.value();
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    final started = await store.startSession(
      title: 'Dawn',
      startedAt: DateTime.utc(2026, 10, 21, 6),
    );
    await tester.pumpWidget(
      harness(
        store: store,
        home: SessionDetailScreen(sessionId: started.session!.id),
      ),
    );
    await tester.pumpAndSettle();
    repository.failNextSave = true;

    await tester.tap(find.byKey(SessionDetailScreen.endKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('session-end-confirm')));
    await tester.pumpAndSettle();

    expect(find.text(l10n.couldNotSave), findsOneWidget);
    expect(find.text(l10n.sessionActive), findsOneWidget);
    expect(store.activeSession, isNotNull);
    expect(find.byKey(SessionDetailScreen.addCatchKey), findsOneWidget);
  });

  testWidgets('history lists a completed session and the empty state', (
    tester,
  ) async {
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    final empty = await records();
    await tester.pumpWidget(
      harness(store: empty, home: const SessionListScreen()),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(SessionListScreen.emptyKey), findsOneWidget);
    expect(find.text(l10n.noSessionsYet), findsOneWidget);
    expect(find.text(l10n.startSession), findsOneWidget);

    final store = await records();
    final started = await store.startSession(
      title: 'Dawn',
      pondName: 'Former pond',
      pondId: 'removed-pond',
      startedAt: DateTime.utc(2026, 10, 21, 6),
    );
    await store.saveCatch(
      CatchRecord(
        id: 'catch-1',
        species: 'Siakap',
        caughtAt: DateTime.utc(2026, 10, 21, 7),
        sessionId: started.session!.id,
      ),
    );
    await store.endSession(
      started.session!.id,
      endedAt: DateTime.utc(2026, 10, 21, 8),
    );
    await tester.pumpWidget(
      harness(store: store, home: const SessionListScreen()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Dawn'), findsOneWidget);
    expect(
      find.text('Former pond · ${l10n.sessionCatchCount(1)}'),
      findsOneWidget,
    );
    await tester.tap(find.text('Dawn'));
    await tester.pumpAndSettle();
    expect(find.text(l10n.sessionSummary), findsOneWidget);
    expect(find.text(l10n.pondUnavailable), findsOneWidget);
    expect(find.text('Siakap'), findsOneWidget);
  });

  testWidgets('Malay session history uses the selected language', (
    tester,
  ) async {
    final store = await records();
    final l10n = await AppLocalizations.delegate.load(const Locale('ms'));
    await tester.pumpWidget(
      harness(
        store: store,
        home: const SessionListScreen(),
        locale: const Locale('ms'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(l10n.fishingHistory), findsOneWidget);
    expect(find.text(l10n.noSessionsYet), findsOneWidget);
    expect(find.text(l10n.startSession), findsOneWidget);
    expect(find.text('Fishing history'), findsNothing);
  });
}
