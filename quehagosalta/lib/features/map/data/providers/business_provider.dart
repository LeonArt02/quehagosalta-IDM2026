import 'package:flutter/material.dart';
import 'package:quehagosalta/features/map/data/models/bussines_model.dart';
import 'package:quehagosalta/features/auth/data/providers/auth_provider.dart';
import 'package:quehagosalta/features/map/presentation/widgets/bussines_detail_sheet.dart';
import 'package:quehagosalta/features/map/data/services/bussines_services.dart';
import 'package:latlong2/latlong.dart';

class BusinessProvider extends ChangeNotifier {
  final BussinesServices _service;

  // Inyección de dependencias a través del constructor
  BusinessProvider(this._service);

  List<BussinesModel> _businesses = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<BussinesModel> get businesses => _businesses;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> loadBusinesses() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final Map<String, dynamic> response = await _service.getBussines();
      // Django Rest Framework usualmente envía las listas paginadas dentro de la llave 'results'.
      final List<dynamic> rawList =
          response['results'] ?? response['data'] ?? [];
      _businesses = rawList
          .map((json) => BussinesModel.fromJson(json))
          .toList();
    } catch (e) {
      _errorMessage = 'Error al cargar los locales: $e';
      debugPrint(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> completeBusinessProfile({
    required String cuil,
    String? imagePath,
    required List<String> businessImagesPaths,
    required String name,
    required String description,
    required String address,
    required String categoryId,
    required double latitude,
    required double longitude,
    required String authToken,
  }) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      await _service.completeBusinessProfile(
        cuil: cuil,
        imagePath: imagePath,
        businessImagesPaths: businessImagesPaths,
        name: name,
        description: description,
        address: address,
        categoryId: categoryId,
        latitude: latitude,
        longitude: longitude,
        token: authToken,
      );
      // Recarga la lista de locales después de crear uno nuevo
      await loadBusinesses();
    } catch (e) {
      _errorMessage = 'Error al registrar el local: $e';
      debugPrint(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
