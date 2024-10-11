import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class SingleLocationMap extends StatefulWidget {
  final double targetLatitude;
  final double targetLongitude;
  final String targetName;

  const SingleLocationMap({super.key, 
    required this.targetLatitude,
    required this.targetLongitude,
    required this.targetName,
  });

  @override
  // ignore: library_private_types_in_public_api
  _SingleLocationMapState createState() => _SingleLocationMapState();
}

class _SingleLocationMapState extends State<SingleLocationMap> {
  late GoogleMapController mapController;
  late LatLng _currentLocation;
  late LatLng _targetLocation;
  late Set<Marker> _markers;
  late Set<Polyline> _polylines;

  @override
  void initState() {
    super.initState();
    _targetLocation = LatLng(widget.targetLatitude, widget.targetLongitude);
    _markers = {};
    _polylines = {};
    _currentLocation = const LatLng(0.0, 0.0); // Initialize with a default value
    _getCurrentLocation();
  }

  // Get the current location of the user
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.checkPermission();

    if (!serviceEnabled) {
      // Show an error if location services are not enabled
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location services are disabled.")),
      );
      return;
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        // Handle denied permission
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Location permission denied.")),
        );
        return;
      }
    }

    // Fetch the current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
      _markers.add(
        Marker(
          markerId: const MarkerId("current_location"),
          position: _currentLocation,
          infoWindow: const InfoWindow(title: "Current Location"),
        ),
      );
      _markers.add(
        Marker(
          markerId: MarkerId(widget.targetName),
          position: _targetLocation,
          infoWindow: InfoWindow(title: widget.targetName),
        ),
      );
      _polylines.add(
        Polyline(
          polylineId: const PolylineId("route"),
          points: [_currentLocation, _targetLocation],
          color: Colors.blue,
          width: 5,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location and Path'),
      ),
      body: _currentLocation.latitude == 0.0 &&
              _currentLocation.longitude == 0.0
          ? const Center(
              child:
                  CircularProgressIndicator()) // Show a loading spinner while waiting for location
          : GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
              initialCameraPosition: CameraPosition(
                target: _currentLocation,
                zoom: 14,
              ),
              markers: _markers,
              polylines: _polylines,
            ),
    );
  }
}
