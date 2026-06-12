import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:quehagosalta/features/map/data/models/bussines_model.dart';
import 'package:quehagosalta/features/map/data/providers/locationProvider.dart';
import 'package:quehagosalta/features/map/presentation/widgets/CustomFlutterMap.dart';
import 'package:quehagosalta/features/map/presentation/widgets/user-location-marker.dart';
import 'package:quehagosalta/features/map/data/providers/business_provider.dart';
import 'package:quehagosalta/features/map/presentation/widgets/bussines_marker_widget.dart';
import 'package:provider/provider.dart';
import 'package:quehagosalta/core/utils/icon_mapper.dart';
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

    /*WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LocationProvider>().initLocation();
    });

    context.read<BusinessProvider>().loadBusinesses();
    */

    Future.microtask(() {
      if (mounted) {
        context.read<LocationProvider>().initLocation();
        context.read<BusinessProvider>().loadBusinesses();
      }
    });
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  List<Marker> _buildBusinessMarkers(List<BussinesModel> businesses) {
    return businesses.map((business) {
      return Marker(
        point: LatLng(business.lat, business.lng),
        width: 45,
        height: 45,
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: () {
            // Al tocar el pin rojo, desplegamos la hoja de detalle que ya tenés armada
            /*showModalBottomSheet(
              context: context,
              builder: (context) => BussinesDetailSheet(bussines: business),
            );*/
          },
          child: BusinessMarkerWidget(business: business),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final locationState = context.watch<LocationProvider>();
    final bussinesProvider = context.watch<BusinessProvider>();

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
                ..._buildBusinessMarkers(bussinesProvider.businesses),
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
