import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'models/nearby_place.dart';
import 'services/maps_service.dart';

class NearbyStoresPage extends StatefulWidget {
  const NearbyStoresPage({super.key});

  @override
  State<NearbyStoresPage> createState() => _NearbyStoresPageState();
}

class _NearbyStoresPageState extends State<NearbyStoresPage> {
  final MapsService _mapsService = MapsService();
  final List<NearbyPlace> _places = [];
  LatLng? _userLocation;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final permission = await _ensureLocationPermission();
      if (!permission) {
        setState(() {
          _errorMessage = 'Brak uprawnień do lokalizacji.';
          _isLoading = false;
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final current = LatLng(position.latitude, position.longitude);

      if (!mounted) return;
      setState(() {
        _userLocation = current;
      });

      final places = await _mapsService.fetchNearbyStores(current);
      if (!mounted) return;
      setState(() {
        _places
          ..clear()
          ..addAll(places);
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<bool> _ensureLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  Set<Marker> _buildMarkers() {
    final markers = <Marker>{};
    if (_userLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('current-location'),
          position: _userLocation!,
          infoWindow: const InfoWindow(title: 'Twoja lokalizacja'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        ),
      );
    }

    for (final place in _places) {
      markers.add(
        Marker(
          markerId: MarkerId(place.placeId),
          position: place.location,
          infoWindow: InfoWindow(
            title: place.name,
            snippet: place.address,
          ),
        ),
      );
    }
    return markers;
  }

  Widget _buildStatus() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _errorMessage!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }
    if (_userLocation == null) {
      return const Center(child: Text('Oczekiwanie na lokalizację...'));
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sklepy budowlane w okolicy'),
        backgroundColor: theme.colorScheme.primaryContainer,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 250,
            child: _userLocation == null
                ? _buildStatus()
                : GoogleMap(
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    zoomControlsEnabled: false,
                    initialCameraPosition: CameraPosition(
                      target: _userLocation!,
                      zoom: 13,
                    ),
                    markers: _buildMarkers(),
                  ),
          ),
          Expanded(
            child: _isLoading && _places.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : _places.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            'Nie znaleziono sklepów z materiałami budowlanymi w promieniu 5 km.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _init,
                        child: ListView.separated(
                          padding: const EdgeInsets.all(12),
                          itemBuilder: (_, index) {
                            final place = _places[index];
                            return Card(
                              child: ListTile(
                                leading: const Icon(Icons.store_mall_directory),
                                title: Text(place.name),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(place.address),
                                    if (place.rating != null)
                                      Text('Ocena: ${place.rating?.toStringAsFixed(1)}'),
                                    if (place.isOpen != null)
                                      Text(place.isOpen! ? 'Otwarte teraz' : 'Zamknięte'),
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (_, __) => const SizedBox(height: 8),
                          itemCount: _places.length,
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}

