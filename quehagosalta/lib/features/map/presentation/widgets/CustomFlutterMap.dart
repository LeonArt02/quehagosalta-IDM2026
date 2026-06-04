import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class Customfluttermap extends StatelessWidget {
  final LatLng centerPosition;
  final List<Marker> markers;
  final MapController mapController;

  const Customfluttermap({
    super.key,
    required this.centerPosition,
    required this.markers,
    required this.mapController,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: centerPosition,
        initialZoom: 15.0,
        maxZoom: 18.0,
        minZoom: 12.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.quehagosalta.app',
        ),
        MarkerLayer(markers: markers),
      ],
    );
  }
}
