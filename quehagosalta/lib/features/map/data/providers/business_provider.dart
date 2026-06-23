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
  List<BussinesModel> _filteredBusinesses = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<BussinesModel> get allBusinesses => _businesses;
  List<BussinesModel> get filteredBusinesses => _filteredBusinesses;

  String? _selectedCategoryId;

  String? get selectedCategoryId => _selectedCategoryId;

  BussinesModel? _myBusiness;
  BussinesModel? get myBusiness => _myBusiness;

  List<BussinesModel> get businesses {
    if (_selectedCategoryId == null)
      return _businesses;
    else {
      return _filteredBusinesses
          .where((business) => business.category.id == _selectedCategoryId)
          .toList();
    }
  }

  List<BussinesModel> get businessesWithoutFilter => _businesses;

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  void setCategoryFilter(String? categoryId) {
    if (_selectedCategoryId == categoryId) return;
    _selectedCategoryId = categoryId;
    notifyListeners();
  }

  Future<void> loadBusinesses() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final Map<String, dynamic> response = await _service.getBussines();
      final List<dynamic> rawList =
          response['results'] ?? response['data'] ?? [];
      _businesses = rawList
          .map((json) => BussinesModel.fromJson(json))
          .toList();
      _filteredBusinesses = List.from(_businesses);
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

  Future<void> loadMyBusiness(String token) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      final response = await _service.getMyBusinessProfile(token);
      if (response['data'] != null) {
        _myBusiness = BussinesModel.fromJson(response['data']);
      } else {
        _myBusiness = BussinesModel.fromJson(response);
      }
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Error al obtener tu negocio: $e';
      _myBusiness = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setMyBusiness(BussinesModel business) {
    _myBusiness = business;
    notifyListeners();
  }

  Future<bool> updateBusiness({
    required String name,
    required String description,
    required List<String> businessImagesPaths,
    required List<String> keptImages,
    required String authToken,
  }) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await _service.updateBusinessProfile(
        name: name,
        description: description,
        businessImagesPaths: businessImagesPaths,
        keptImages: keptImages,
        token: authToken,
      );

      final dynamic responseData = response['data'] ?? response;

      if (responseData != null && responseData['business'] != null) {
        _myBusiness = BussinesModel.fromJson(responseData['business']);

        await loadBusinesses();
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = 'Error al actualizar los datos: $e';
      debugPrint(_errorMessage);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
