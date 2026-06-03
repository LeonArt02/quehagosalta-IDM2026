import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapaOSM extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa OpenStreetMap'),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(-24.7859, -65.4116), // Coordenadas iniciales (Salta, Argentina)
          initialZoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.tu.app', // Reemplaza con el nombre de tu paquete
          ),
        ],
      ),
    );
  }
}
