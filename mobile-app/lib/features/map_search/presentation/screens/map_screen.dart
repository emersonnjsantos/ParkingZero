import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(-25.5478, -54.5881), // Foz do Iguaçu
    zoom: 14.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Estacionamento'),
      ),
      body: const GoogleMap(
        initialCameraPosition: _initialPosition,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
