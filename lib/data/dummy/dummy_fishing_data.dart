import 'models/fishing_pond.dart';
import 'models/pond_membership.dart';
import '../../models/pond.dart';

/// Local preview of publicly listed Malaysian fishing venues.
///
/// These are not live bookings. Prices, hours, species, and coordinates are
/// stored only when a public source supported them on the last check.
class DummyFishingData {
  const DummyFishingData._();

  static final DateTime lastChecked = DateTime.utc(2026, 10, 21);

  static const String mvId = 'kolam-pancing-mv';
  static const String kakNgahId = 'kak-ngah-sport-fishing';
  static const String uluBendulId = 'ulu-bendul-fish-valley';
  static const String ttfcId = 'tuan-tanah-fishing-centre';
  static const String aduroId = 'kolam-pancing-air-masin-aduro';

  static const String _mvMaps =
      'https://www.google.com/maps/search/?api=1&query=Kolam+Pancing+MV+Air+Masin+Hulu+Langat';
  static const String _kakNgahMaps =
      'https://www.google.com/maps/search/?api=1&query=Kak+Ngah+Sport+Fishing+Hulu+Langat';
  static const String _uluBendulMaps =
      'https://www.google.com/maps/search/?api=1&query=Ulu+Bendul+Fish+Valley+Tanjung+Ipoh';
  static const String _ttfcMaps =
      'https://www.google.com/maps/search/?api=1&query=Tuan+Tanah+Fishing+Centre+Sungai+Buloh';
  static const String _aduroMaps =
      'https://www.google.com/maps/search/?api=1&query=Kolam+Pancing+Air+Masin+Aduro+Sungai+Buloh';

  static final List<FishingPond> ponds = <FishingPond>[
    FishingPond(
      id: mvId,
      name: 'Kolam Pancing MV (Air Masin)',
      description:
          'Saltwater pay pond in Hulu Langat. The street address is repeated by public directories and was not confirmed on an official venue page.',
      pondType: 'Pay pond',
      waterType: PondWaterType.saltwater,
      species: const <String>['Siakap', 'Kerapu', 'Jenahak'],
      addressOrArea:
          '869-7, Jalan Sg. Sop, Batu 14, 43100 Hulu Langat, Selangor, Malaysia',
      googleMapsUrl: _mvMaps,
      sourceUrls: const <String>[
        'https://kolamudangnearme.my/kolam-pancing-mv-air-masin/',
        'https://masterpancing.com/kolam-pancing-hulu-langat/',
      ],
      verificationNote:
          'Name, saltwater category, and the Jalan Sg. Sop address appear on two public directories. Species are listed by masterpancing.com only. Opening hours differ between those directories, so hours and prices are omitted. No source gave verified coordinates. The map link is a name search, not a pin.',
      verificationStatus: PondVerificationStatus.partial,
      lastChecked: lastChecked,
    ),
    FishingPond(
      id: kakNgahId,
      name: 'Kak Ngah Sport Fishing',
      description:
          'Sport-fishing venue in Hulu Langat. A news report names marine species landed there during a competition.',
      pondType: '',
      waterType: PondWaterType.saltwater,
      species: const <String>['Kerapu naga', 'Siakap', 'Kaci', 'Jenahak'],
      addressOrArea: 'Hulu Langat, Selangor',
      googleMapsUrl: _kakNgahMaps,
      sourceUrls: const <String>[
        'https://www.hmetro.com.my/mutakhir/2026/09/1416176/80-kakitangan-pegawai-kanan-sprm-buru-gelaran-raja-pancing',
        'https://www.tiktok.com/@kakngahsportfishing',
      ],
      verificationNote:
          'Harian Metro, 27 September 2026, places Kak Ngah Sport Fishing in Hulu Langat and names kerapu naga, siakap, kaci, and jenahak landed at a competition. The report does not give a street address, coordinates, ticket price, or opening hours. This is not the separate prawn pond listed under a similar Kak Ngah name.',
      verificationStatus: PondVerificationStatus.partial,
      lastChecked: lastChecked,
    ),
    FishingPond(
      id: uluBendulId,
      name: 'Ulu Bendul Fish Valley',
      description:
          'Fishing valley at Kampung Ulu Bendol. Its ticketing site sells separate saltwater and freshwater pond sessions.',
      pondType: 'Pay pond',
      waterType: PondWaterType.mixed,
      species: const <String>[],
      addressOrArea:
          'Jalan Kuala Pilah, Kampung Ulu Bendol, 71500 Tanjung Ipoh, Negeri Sembilan',
      priceLabel:
          'Kolam A (air masin) 4 jam RM100, 8 jam RM130. Kolam C (air tawar) 4 jam RM40.',
      openingHoursLabel:
          'Ahad–Rabu 10am–12am, Khamis rehat, Jumaat 3pm–7am, Sabtu 10am–7am',
      googleMapsUrl: _uluBendulMaps,
      sourceUrls: const <String>[
        'https://ticketing.1stopfishing.com/shop/',
        'https://ticketing.1stopfishing.com/contact-us/',
        'https://ticketing.1stopfishing.com/product/kolam-a-air-masin-8-jam/',
      ],
      verificationNote:
          'Address, hours, and the listed ticket prices come from the Ulu Bendul pages on ticketing.1stopfishing.com. Kolam A is labelled air masin and Kolam C air tawar, so the venue is mixed. Species and coordinates are not stated there. The map link is a name search, not a pin.',
      verificationStatus: PondVerificationStatus.sourced,
      lastChecked: lastChecked,
    ),
    FishingPond(
      id: ttfcId,
      name: 'Tuan Tanah Fishing Centre',
      description:
          'Sungai Buloh fishing centre. A news visit describes marine fish ponds and a separate giant freshwater prawn pond.',
      pondType: 'Pay pond',
      waterType: PondWaterType.mixed,
      species: const <String>[
        'Siakap putih',
        'Siakap merah',
        'Jenahak',
        'Merah',
        'Gerepoh (GT)',
        'Bawal pinang',
        'Udang galah',
      ],
      addressOrArea:
          'PT 1915, Taman Seri Alam, 3, Jalan Seri Alam 14, Bandar Saujana Utama, 47000 Sungai Buloh, Selangor, Malaysia',
      openingHoursLabel: 'Every day, 10:00–00:00',
      googleMapsUrl: _ttfcMaps,
      sourceUrls: const <String>[
        'https://www.kosmo.com.my/2026/08/20/lepas-gian-di-tuan-tanah-fishing-centre/',
        'https://kolamudangnearme.my/tuan-tanah-fishing-centre/',
      ],
      verificationNote:
          'Kosmo, 20 August 2026, describes two marine ponds plus an udang galah pond, names the species, and states daily hours from 10am to midnight with 4, 5, or 8 hour sessions. It does not state a street address or a session price. The street address is the one repeated by a public directory, so it is not treated as official. No verified coordinates. The map link is a name search, not a pin.',
      verificationStatus: PondVerificationStatus.partial,
      lastChecked: lastChecked,
    ),
    FishingPond(
      id: aduroId,
      name: 'Kolam Pancing Air Masin Aduro',
      description:
          'Saltwater pond in Sungai Buloh, described by the operator in a 2023 news report.',
      pondType: 'Pay pond',
      waterType: PondWaterType.saltwater,
      species: const <String>['Siakap', 'Kaci', 'Kerapu', 'Jenahak'],
      addressOrArea: 'Sungai Buloh, Selangor',
      googleMapsUrl: _aduroMaps,
      sourceUrls: const <String>[
        'https://www.kosmo.com.my/2023/06/03/kolam-air-masin-lubuk-buru-kerapu-jenahak/',
      ],
      verificationNote:
          'Kosmo, 3 June 2023, quotes the operator of Kolam Pancing Air Masin Aduro in Sungai Buloh and names siakap, kaci, kerapu, and jenahak. The article gives no street address, coordinates, current price, or opening hours. The map link is a name search, not a pin.',
      verificationStatus: PondVerificationStatus.partial,
      lastChecked: lastChecked,
    ),
  ];

  /// Fictional preview id. It is not a member account and cannot be verified.
  static const String demoMemberId = 'DEMO-MV-0001';

  static const List<DemoPondMembership> memberships = <DemoPondMembership>[
    DemoPondMembership(
      id: 'demo-membership-preview',
      pondId: mvId,
      pondName: 'Kolam Pancing MV (Air Masin)',
      membershipNumber: demoMemberId,
    ),
  ];
}
