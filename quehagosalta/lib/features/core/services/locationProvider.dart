// Utiliza geolocator para obtener la ubicación del usuario
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';

class LocationProvider extends ChangeNotifier {
  LatLng? _currentPosition;
  bool _isLoading = true;
  String _errorMessage = '';

  LatLng? get currentPosition => _currentPosition;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> initLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _errorMessage = 'El servicio de ubicación está desactivado.';
      _isLoading = false;
      notifyListeners();
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _errorMessage = 'Permisos de ubicación denegados.';
        _isLoading = false;
        notifyListeners();
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition();
    _currentPosition = LatLng(position.latitude, position.longitude);
    _isLoading = false;
    notifyListeners();

    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) {
      _currentPosition = LatLng(position.latitude, position.longitude);
      notifyListeners();
    });
<<<<<<< Updated upstream

=======
>>>>>>> Stashed changes
  }
}
