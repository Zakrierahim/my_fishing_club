import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_fishing_club/controllers/angler_records_controller.dart';
import 'package:my_fishing_club/controllers/pond_catalog_controller.dart';
import 'package:my_fishing_club/core/theme/app_theme.dart';
import 'package:my_fishing_club/data/dummy/dummy_fishing_data.dart';
import 'package:my_fishing_club/data/repositories/angler_records_repository.dart';
import 'package:my_fishing_club/generated/l10n/app_localizations.dart';
import 'package:my_fishing_club/models/pond.dart';
import 'package:my_fishing_club/services/map_navigation_service.dart';
import 'package:my_fishing_club/views/catches/catch_form_screen.dart';
import 'package:my_fishing_club/views/favorites/favorites_screen.dart';
import 'package:my_fishing_club/views/trips/trip_form_screen.dart';
import 'package:my_fishing_club/widgets/navigation_chooser.dart';
import 'package:provider/provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget harness({
    required Widget home,
    required AnglerRecordsController records,
    Locale locale = const Locale('en'),
  }) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AnglerRecordsController>.value(value: records),
        ChangeNotifierProvider(
          create: (_) => PondCatalogController(ponds: DummyFishingData.ponds),
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

  Future<AnglerRecordsController> records() async {
    final controller = AnglerRecordsController(
      repository: MemoryAnglerRecordsRepository(),
    );
    await Future<void>.value();
    return controller;
  }

  testWidgets('the catch form saves a species and leaves the ponds unchanged', (
    tester,
  ) async {
    final store = await records();
    await tester.pumpWidget(
      harness(records: store, home: const CatchFormScreen()),
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(CatchFormScreen.speciesKey), 'Siakap');
    await tester.ensureVisible(find.byKey(CatchFormScreen.saveKey));
    await tester.tap(find.byKey(CatchFormScreen.saveKey));
    await tester.pumpAndSettle();

    expect(store.catches.single.species, 'Siakap');
    expect(store.catches.single.pondId, isNull);
    expect(
      DummyFishingData.ponds.map((pond) => pond.name),
      isNot(contains('Siakap')),
    );
  });

  testWidgets('the trip form keeps the preselected pond', (tester) async {
    final store = await records();
    await tester.pumpWidget(
      harness(
        records: store,
        home: const TripFormScreen(initialPondId: DummyFishingData.mvId),
      ),
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(TripFormScreen.titleKey), 'Saturday');
    await tester.ensureVisible(find.byKey(TripFormScreen.saveKey));
    await tester.tap(find.byKey(TripFormScreen.saveKey));
    await tester.pumpAndSettle();

    expect(store.trips.single.title, 'Saturday');
    expect(store.trips.single.pondId, DummyFishingData.mvId);
    expect(store.trips.single.pondName, 'Kolam Pancing MV (Air Masin)');
  });

  testWidgets('favorites list the pond and can remove it', (tester) async {
    final store = await records();
    await store.setFavorite(DummyFishingData.mvId, favorite: true);
    await tester.pumpWidget(
      harness(records: store, home: const FavoritesScreen()),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(FavoritesScreen.emptyKey), findsNothing);
    expect(find.text('Kolam Pancing MV (Air Masin)'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.favorite));
    await tester.pumpAndSettle();
    expect(store.isFavorite(DummyFishingData.mvId), isFalse);
    expect(find.byKey(FavoritesScreen.emptyKey), findsOneWidget);
  });

  testWidgets('the Malay navigation sheet offers no Apple Maps on Android', (
    tester,
  ) async {
    final ms = await AppLocalizations.delegate.load(const Locale('ms'));
    const pond = Pond(
      id: 'mv',
      name: 'Kolam A & B',
      species: <String>[],
      pondType: 'Pay pond',
      addressOrArea: 'Jalan 1/2',
    );
    const service = MapNavigationService(
      platform: TargetPlatform.android,
      launch: _failLaunch,
    );

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ms'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.dark,
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: TextButton(
                onPressed: () {
                  chooseAndOpenNavigation(
                    context: context,
                    pond: pond,
                    service: service,
                  );
                },
                child: const Text('open'),
              ),
            );
          },
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text(ms.chooseNavigation), findsOneWidget);
    expect(find.text(ms.navigationSearchNote), findsOneWidget);
    expect(find.text(ms.googleMaps), findsOneWidget);
    expect(find.text(ms.waze), findsOneWidget);
    expect(find.text(ms.appleMaps), findsNothing);

    await tester.tap(find.byKey(const Key('nav-waze')));
    await tester.pumpAndSettle();
    expect(find.text(ms.mapsLaunchFailed), findsOneWidget);
    expect(find.text(ms.mapsOpenedInBrowser), findsNothing);
  });

  testWidgets('the iOS navigation sheet includes Apple Maps', (tester) async {
    final en = await AppLocalizations.delegate.load(const Locale('en'));
    const pond = Pond(
      id: 'pin',
      name: 'Pinned Pond',
      species: <String>[],
      pondType: 'Pay pond',
      latitude: 3.1,
      longitude: 101.8,
    );
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.dark,
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: TextButton(
                onPressed: () {
                  chooseAndOpenNavigation(
                    context: context,
                    pond: pond,
                    service: const MapNavigationService(
                      platform: TargetPlatform.iOS,
                      launch: _failLaunch,
                    ),
                  );
                },
                child: const Text('open'),
              ),
            );
          },
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text(en.appleMaps), findsOneWidget);
    expect(find.text(en.navigationSearchNote), findsNothing);
    expect(find.text(en.navigationSuggested), findsOneWidget);
  });
}

Future<bool> _failLaunch(Uri uri) async => false;
