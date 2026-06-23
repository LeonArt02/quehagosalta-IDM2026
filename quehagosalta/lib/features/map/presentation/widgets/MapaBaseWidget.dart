import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:quehagosalta/features/business/data/models/bussines_model.dart';
import 'package:quehagosalta/features/map/data/providers/locationProvider.dart';
import 'package:quehagosalta/features/map/presentation/widgets/CustomFlutterMap.dart';
import 'package:quehagosalta/features/business/widgets/bussines_detail_sheet.dart';
import 'package:quehagosalta/features/users/widgets/user-location-marker.dart';
import 'package:quehagosalta/features/business/data/providers/business_provider.dart';
import 'package:quehagosalta/features/business/widgets/bussines_marker_widget.dart';
import 'package:provider/provider.dart';
import 'package:quehagosalta/core/utils/icon_mapper.dart';
import '../../../users/widgets/user-location-marker.dart';
import 'CustomFlutterMap.dart';
import 'package:quehagosalta/features/categories/data/models/category_model.dart';

class MapBaseWidget extends StatefulWidget {
  const MapBaseWidget({super.key});

  State<MapBaseWidget> createState() => _mapBaseWidget();
}

class _mapBaseWidget extends State<MapBaseWidget> {
  final MapController _mapController = MapController();
  // :D

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
    final locationUser = context.read<LocationProvider>();
    final LatLng userLatLng =
        locationUser.currentPosition ?? const LatLng(-24.7859, -65.4116);
    return businesses.map((business) {
      return Marker(
        point: LatLng(business.lat, business.lng),
        width: 45,
        height: 45,
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: () {
            BussinesDetailSheet.show(context, business, userLatLng);
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
