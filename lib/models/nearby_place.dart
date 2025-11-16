import 'package:google_maps_flutter/google_maps_flutter.dart';

class NearbyPlace {
  final String placeId;
  final String name;
  final String address;
  final LatLng location;
  final double? rating;
  final bool? isOpen;
  final List<String> types;

  NearbyPlace({
    required this.placeId,
    required this.name,
    required this.address,
    required this.location,
    this.rating,
    this.isOpen,
    required this.types,
  });

  factory NearbyPlace.fromJson(Map<String, dynamic> json) {
    final geometry = json['geometry'] as Map<String, dynamic>? ?? {};
    final loc = geometry['location'] as Map<String, dynamic>? ?? {};

    return NearbyPlace(
      placeId: json['place_id'] as String? ?? '',
      name: json['name'] as String? ?? 'Nieznana lokalizacja',
      address: json['vicinity'] as String? ?? (json['formatted_address'] as String? ?? ''),
      location: LatLng(
        (loc['lat'] as num?)?.toDouble() ?? 0,
        (loc['lng'] as num?)?.toDouble() ?? 0,
      ),
      rating: (json['rating'] as num?)?.toDouble(),
      isOpen: (json['opening_hours'] as Map<String, dynamic>?)?['open_now'] as bool?,
      types: (json['types'] as List<dynamic>?)
              ?.map((type) => type.toString())
              .toList() ??
          const [],
    );
  }
}

