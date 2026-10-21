import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/pond.dart';

/// Maps app the angler can choose for turn-by-turn navigation.
enum MapProvider { google, waze, apple }

/// What happened when the app tried to open a map.
enum MapLaunchOutcome { appOpened, webOpened, failed }

/// An app link plus a browser page used when the app is missing.
class MapLink {
  const MapLink({required this.appUri, required this.webUri});

  final Uri appUri;
  final Uri webUri;
}

/// Builds map links and opens them. Widgets do not assemble these URIs.
class MapNavigationService {
  const MapNavigationService({this.platform, this.launch});

  /// When omitted, the current device platform is used.
  final TargetPlatform? platform;

  /// Test hook. Production uses [launchUrl].
  final Future<bool> Function(Uri uri)? launch;

  TargetPlatform get resolvedPlatform => platform ?? defaultTargetPlatform;

  /// Apple Maps is offered on iOS only.
  List<MapProvider> navigationProviders([TargetPlatform? override]) {
    final current = override ?? resolvedPlatform;
    if (current == TargetPlatform.iOS) {
      return const [MapProvider.apple, MapProvider.google, MapProvider.waze];
    }
    return const [MapProvider.google, MapProvider.waze];
  }

  MapProvider defaultProvider([TargetPlatform? override]) {
    return navigationProviders(override).first;
  }

  /// Name and address only. Coordinates are added separately when verified.
  String destinationQuery(Pond pond) {
    final name = pond.name.trim();
    final address = pond.addressOrArea?.trim() ?? '';
    if (name.isEmpty) {
      return address;
    }
    if (address.isEmpty) {
      return name;
    }
    return '$name, $address';
  }

  /// Opens a map search. Verified coordinates are used as the query.
  Uri viewMapUri(Pond pond) {
    if (pond.hasCoordinates) {
      return Uri.https('www.google.com', '/maps/search/', {
        'api': '1',
        'query': _coordinatePair(pond),
      });
    }
    final existing = pond.googleMapsUrl?.trim();
    final parsed = existing == null ? null : Uri.tryParse(existing);
    if (parsed != null && parsed.scheme == 'https') {
      return parsed;
    }
    return Uri.https('www.google.com', '/maps/search/', {
      'api': '1',
      'query': destinationQuery(pond),
    });
  }

  MapLink navigationLink({
    required MapProvider provider,
    required Pond pond,
    TargetPlatform? platform,
  }) {
    final current = platform ?? resolvedPlatform;
    final destination = pond.hasCoordinates
        ? _coordinatePair(pond)
        : destinationQuery(pond);
    final encoded = Uri.encodeComponent(destination);
    switch (provider) {
      case MapProvider.google:
        final app = current == TargetPlatform.iOS
            ? 'comgooglemaps://?daddr=$encoded&directionsmode=driving'
            : 'google.navigation:q=$encoded';
        return MapLink(
          appUri: Uri.parse(app),
          webUri: Uri.https('www.google.com', '/maps/dir/', {
            'api': '1',
            'destination': destination,
          }),
        );
      case MapProvider.waze:
        final app = pond.hasCoordinates
            ? 'waze://?ll=$destination&navigate=yes'
            : 'waze://?q=$encoded&navigate=yes';
        return MapLink(
          appUri: Uri.parse(app),
          webUri: Uri.https('www.waze.com', '/ul', {
            if (pond.hasCoordinates) 'll': destination else 'q': destination,
            'navigate': 'yes',
          }),
        );
      case MapProvider.apple:
        return MapLink(
          appUri: Uri.parse('maps://?daddr=$encoded&dirflg=d'),
          webUri: Uri.https('maps.apple.com', '/', {
            'daddr': destination,
            'dirflg': 'd',
          }),
        );
    }
  }

  Future<MapLaunchOutcome> openViewMap(Pond pond) async {
    final opened = await _try(viewMapUri(pond));
    return opened ? MapLaunchOutcome.webOpened : MapLaunchOutcome.failed;
  }

  /// Tries the maps app, then the https page. Failure stays a failure.
  Future<MapLaunchOutcome> openNavigation({
    required MapProvider provider,
    required Pond pond,
  }) async {
    final link = navigationLink(provider: provider, pond: pond);
    if (await _try(link.appUri)) {
      return MapLaunchOutcome.appOpened;
    }
    if (await _try(link.webUri)) {
      return MapLaunchOutcome.webOpened;
    }
    return MapLaunchOutcome.failed;
  }

  Future<bool> _try(Uri uri) async {
    try {
      final opener = launch;
      if (opener != null) {
        return await opener(uri);
      }
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }

  String _coordinatePair(Pond pond) => '${pond.latitude},${pond.longitude}';
}
