/// Salt, fresh, mixed, or not established from a source.
enum PondWaterType { saltwater, freshwater, mixed, unknown }

/// How far the local record was checked against public sources.
enum PondVerificationStatus { unverified, partial, sourced }

/// A fishing pond. The app starts with none until a dataset is supplied.
class Pond {
  const Pond({
    required this.id,
    required this.name,
    required this.species,
    required this.pondType,
    this.description,
    this.imageAsset,
    this.facilities = const <String>[],
    this.addressOrArea,
    this.priceLabel,
    this.openingHoursLabel,
    this.isDemo = false,
    this.waterType = PondWaterType.unknown,
    this.latitude,
    this.longitude,
    this.googleMapsUrl,
    this.sourceUrls = const <String>[],
    this.verificationNote,
    this.verificationStatus = PondVerificationStatus.unverified,
    this.lastChecked,
  });

  final String id;
  final String name;
  final String? description;
  final String? imageAsset;
  final String pondType;
  final List<String> species;
  final List<String> facilities;
  final String? addressOrArea;
  final String? priceLabel;
  final String? openingHoursLabel;
  final bool isDemo;
  final PondWaterType waterType;
  final double? latitude;
  final double? longitude;
  final String? googleMapsUrl;
  final List<String> sourceUrls;
  final String? verificationNote;
  final PondVerificationStatus verificationStatus;
  final DateTime? lastChecked;

  bool get hasCoordinates => latitude != null && longitude != null;

  Pond copyWith({
    String? id,
    String? name,
    String? description,
    String? imageAsset,
    String? pondType,
    List<String>? species,
    List<String>? facilities,
    String? addressOrArea,
    String? priceLabel,
    String? openingHoursLabel,
    bool? isDemo,
    PondWaterType? waterType,
    double? latitude,
    double? longitude,
    String? googleMapsUrl,
    List<String>? sourceUrls,
    String? verificationNote,
    PondVerificationStatus? verificationStatus,
    DateTime? lastChecked,
  }) {
    return Pond(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageAsset: imageAsset ?? this.imageAsset,
      pondType: pondType ?? this.pondType,
      species: species ?? this.species,
      facilities: facilities ?? this.facilities,
      addressOrArea: addressOrArea ?? this.addressOrArea,
      priceLabel: priceLabel ?? this.priceLabel,
      openingHoursLabel: openingHoursLabel ?? this.openingHoursLabel,
      isDemo: isDemo ?? this.isDemo,
      waterType: waterType ?? this.waterType,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      googleMapsUrl: googleMapsUrl ?? this.googleMapsUrl,
      sourceUrls: sourceUrls ?? this.sourceUrls,
      verificationNote: verificationNote ?? this.verificationNote,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      lastChecked: lastChecked ?? this.lastChecked,
    );
  }
}
