import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPicker extends StatefulWidget {
  final Function(double latitude, double longitude) onLocationSelected;

  const LocationPicker({super.key, required this.onLocationSelected});

  @override
  // ignore: library_private_types_in_public_api
  _LocationPickerState createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  LatLng _selectedLocation = const LatLng(0, 0); // Default location

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 300,
          child: GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(0, 0), // Start at the center of the map
              zoom: 2,
            ),
            onMapCreated: (GoogleMapController controller) {
            },
            onTap: (LatLng position) {
              setState(() {
                _selectedLocation = position;
              });
              widget.onLocationSelected(position.latitude, position.longitude); // Pass the location back
            },
            markers: {
              Marker(
                markerId: const MarkerId('selectedLocation'),
                position: _selectedLocation,
              ),
            },
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Selected Location: (${_selectedLocation.latitude}, ${_selectedLocation.longitude})',
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
