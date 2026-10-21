import '../../../models/pond.dart';

/// A local preview pond. Venue names can be real, but the record is not live data.
class FishingPond extends Pond {
  const FishingPond({
    required super.id,
    required super.name,
    required super.species,
    required super.pondType,
    super.description,
    super.imageAsset,
    super.facilities,
    super.addressOrArea,
    super.priceLabel,
    super.openingHoursLabel,
    super.waterType,
    super.latitude,
    super.longitude,
    super.googleMapsUrl,
    super.sourceUrls,
    super.verificationNote,
    super.verificationStatus,
    super.lastChecked,
  }) : super(isDemo: true);

  @override
  FishingPond copyWith({
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
    assert(isDemo != false, 'A preview pond stays marked as preview data.');
    return FishingPond(
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
