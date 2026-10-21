import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_fishing_club/models/pond.dart';
import 'package:my_fishing_club/services/map_navigation_service.dart';

void main() {
  const named = Pond(
    id: 'mv',
    name: 'Kolam A & B',
    species: <String>[],
    pondType: 'Pay pond',
    addressOrArea: 'Jalan 1/2, Hulu Langat',
    googleMapsUrl:
        'https://www.google.com/maps/search/?api=1&query=Kolam+A+%26+B',
  );
  const pinned = Pond(
    id: 'pin',
    name: 'Pinned Pond',
    species: <String>[],
    pondType: 'Pay pond',
    latitude: 3.1,
    longitude: 101.8,
  );

  test('Android offers Google Maps and Waze, not Apple Maps', () {
    const service = MapNavigationService(platform: TargetPlatform.android);

    expect(service.navigationProviders(), [
      MapProvider.google,
      MapProvider.waze,
    ]);
    expect(service.navigationProviders(), isNot(contains(MapProvider.apple)));
    expect(service.defaultProvider(), MapProvider.google);
  });

  test('iOS offers Apple Maps, Google Maps, and Waze', () {
    const service = MapNavigationService(platform: TargetPlatform.iOS);

    expect(service.navigationProviders(), [
      MapProvider.apple,
      MapProvider.google,
      MapProvider.waze,
    ]);
    expect(service.defaultProvider(), MapProvider.apple);
  });

  test('text destinations encode spaces and punctuation', () {
    const service = MapNavigationService(platform: TargetPlatform.android);
    final link = service.navigationLink(
      provider: MapProvider.google,
      pond: named,
    );

    expect(
      link.webUri.queryParameters['destination'],
      'Kolam A & B, Jalan 1/2, Hulu Langat',
    );
    expect(link.webUri.toString(), contains('Kolam+A+%26+B'));
    expect(link.webUri.scheme, 'https');
    expect(link.appUri.toString(), contains('google.navigation:q='));
    expect(link.appUri.toString(), contains('Kolam%20A%20%26%20B'));
    expect(link.appUri.toString(), contains('Jalan%201%2F2'));
  });

  test(
    'verified coordinates are used and are not invented for other ponds',
    () {
      const service = MapNavigationService(platform: TargetPlatform.iOS);

      expect(named.hasCoordinates, isFalse);
      expect(service.viewMapUri(named).toString(), named.googleMapsUrl);

      final view = service.viewMapUri(pinned);
      expect(view.queryParameters['query'], '3.1,101.8');
      expect(view.host, 'www.google.com');

      final google = service.navigationLink(
        provider: MapProvider.google,
        pond: pinned,
      );
      expect(
        google.appUri.toString(),
        'comgooglemaps://?daddr=3.1%2C101.8&directionsmode=driving',
      );
      expect(google.webUri.queryParameters['destination'], '3.1,101.8');

      final waze = service.navigationLink(
        provider: MapProvider.waze,
        pond: pinned,
      );
      expect(waze.appUri.toString(), 'waze://?ll=3.1,101.8&navigate=yes');
      expect(waze.webUri.queryParameters['ll'], '3.1,101.8');

      final apple = service.navigationLink(
        provider: MapProvider.apple,
        pond: pinned,
      );
      expect(apple.appUri.scheme, 'maps');
      expect(apple.webUri.host, 'maps.apple.com');
      expect(apple.webUri.queryParameters['daddr'], '3.1,101.8');
    },
  );

  test('a failed app launch can fall back to the web page', () async {
    final opened = <Uri>[];
    final service = MapNavigationService(
      platform: TargetPlatform.android,
      launch: (uri) async {
        opened.add(uri);
        return uri.scheme == 'https';
      },
    );

    final outcome = await service.openNavigation(
      provider: MapProvider.waze,
      pond: named,
    );

    expect(outcome, MapLaunchOutcome.webOpened);
    expect(opened.first.scheme, 'waze');
    expect(opened.last.scheme, 'https');
  });

  test('failure is reported when neither link opens', () async {
    const service = MapNavigationService(
      platform: TargetPlatform.android,
      launch: _neverOpens,
    );

    expect(
      await service.openNavigation(provider: MapProvider.google, pond: named),
      MapLaunchOutcome.failed,
    );
    expect(await service.openViewMap(named), MapLaunchOutcome.failed);
  });
}

Future<bool> _neverOpens(Uri uri) async => false;
