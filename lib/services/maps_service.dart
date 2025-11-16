import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../models/nearby_place.dart';

class MapsService {
  MapsService();

  String get _apiKey => dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';

  Future<List<NearbyPlace>> fetchNearbyStores(
    LatLng location, {
    int radiusInMeters = 5000,
  }) async {
    if (_apiKey.isEmpty) {
      throw Exception('Brak klucza GOOGLE_MAPS_API_KEY w pliku .env');
    }

    final queryParameters = {
      'location': '${location.latitude},${location.longitude}',
      'radius': radiusInMeters.toString(),
      'keyword': 'materiały budowlane sklep',
      'type': 'hardware_store',
      'key': _apiKey,
    };

    final uri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/place/nearbysearch/json',
      queryParameters,
    );

    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Google Places API zwróciło status ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final status = decoded['status'] as String? ?? 'UNKNOWN';

    if (status == 'ZERO_RESULTS') {
      return [];
    }

    if (status != 'OK') {
      final errorMessage = decoded['error_message'] as String?;
      throw Exception('Google Places API error: $status ${errorMessage ?? ''}');
    }

    final results = decoded['results'] as List<dynamic>? ?? [];
    return results
        .map((item) => NearbyPlace.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}

