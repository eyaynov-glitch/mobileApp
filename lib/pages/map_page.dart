import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    const ynovMaroc = LatLng(33.5731, -7.5898);
    return Scaffold(
      appBar: AppBar(title: const Text('Event Map - Casablanca')),
      body: const GoogleMap(
        initialCameraPosition: CameraPosition(target: ynovMaroc, zoom: 12),
        markers: {
          Marker(
            markerId: MarkerId('ynov-campus-maroc'),
            position: ynovMaroc,
            infoWindow: InfoWindow(title: 'Ynov Campus Maroc', snippet: '8 Ibnou Katima, Casablanca'),
          ),
        },
      ),
    );
  }
}
