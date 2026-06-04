import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:quehagosalta/features/core/services/locationProvider.dart';
import 'package:quehagosalta/features/map/presentation/widgets/CustomFlutterMap.dart';
import 'package:quehagosalta/features/map/presentation/widgets/user-location-marker.dart';
import 'package:provider/provider.dart';
import 'user-location-marker.dart';
import 'CustomFlutterMap.dart';

class MapBaseWidget extends StatefulWidget {
  const MapBaseWidget({super.key});

  State<MapBaseWidget> createState() => _mapBaseWidget();
}

class _mapBaseWidget extends State<MapBaseWidget> {
  final MapController _mapController = MapController();

  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LocationProvider>().initLocation();
    });
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locationState = context.watch<LocationProvider>();

    return Scaffold(
      body: Stack(
        children: [
          if (locationState.isLoading)
            const Center(child: CircularProgressIndicator())
          else if (locationState.errorMessage.isNotEmpty)
            Center(child: Text(locationState.errorMessage))
          else if (locationState.currentPosition != null)
            Customfluttermap(
              mapController: _mapController,
              centerPosition: locationState.currentPosition!,
              markers: [
                UserMarkerLocationWidget.build(locationState.currentPosition!),
              ],
            ),
          if (!locationState.isLoading && locationState.currentPosition != null)
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                child: const Icon(Icons.my_location),
                onPressed: () {
                  _mapController.move(locationState.currentPosition!, 15.0);
                },
              ),
            ),
        ],
      ),
    );
  }
}
