import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EventLocation {
  final double latitude;
  final double longitude;
  final String name;
  final String priority;

  EventLocation({
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.priority,
  });
}

class MapScreen extends StatefulWidget {
  final List<EventLocation> locations;

  const MapScreen({super.key, required this.locations});

  @override
  // ignore: library_private_types_in_public_api
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps Markers'),
      ),
      body: widget.locations.isEmpty
          ? const Center(
              child:
                  CircularProgressIndicator()) // Show loading spinner until data is loaded
          : GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
              initialCameraPosition: CameraPosition(
                target: widget.locations.isNotEmpty
                    ? LatLng(widget.locations[0].latitude,
                        widget.locations[0].longitude)
                    : const LatLng(0, 0), // Default camera position
                zoom: 4,
              ),
              markers: _createMarkers(),
            ),
    );
  }

  // Create markers from the provided locations
  Set<Marker> _createMarkers() {
    return widget.locations.map((location) {
      // Assigning hue value based on priority
      double hue;
      switch (location.priority) {
        case 'High':
          hue = 30.0; // Orange hue
          break;
        case 'Medium':
          hue = 60.0; // Yellow hue
          break;
        case 'Low':
          hue = 120.0; // Green hue
          break;
        default:
          hue = 0.0; // Default red hue
      }

      return Marker(
        markerId: MarkerId(location.name),
        position: LatLng(location.latitude, location.longitude),
        infoWindow: InfoWindow(
          title: location.name,
          snippet: location.priority,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(hue), // Correct hue usage
      );
    }).toSet();
  }
}
