

import 'package:flutter/material.dart';
import 'package:quehagosalta/features/map/data/services/auth_service.dart';
import 'package:quehagosalta/features/map/data/models/user_model.dart';
import 'package:quehagosalta/features/map/data/models/aut_response_model.dart';
import 'package:quehagosalta/features/map/data/models/role_model.dart';


class AuthProvider extends ChangeNotifier {
  final AuthService _authService;

  AuthProvider(this._authService);

  UserModel? _currentUser;
  String? _token;
  bool _isLoading = false;
  bool _isGuest = false;

  bool get isLoading => _isLoading;
  bool get isGuest => _isGuest;
  bool get isAuthenticated => _currentUser != null && _token != null;
  
  UserModel? get currentUser => _currentUser;
  String? get token => _token;

  RoleModel? get role {
    if (_currentUser != null && _currentUser!.roles.isNotEmpty) {
      return _currentUser!.roles.first;
    }
    return null;
  }



  Future<void> login({required String email, required String password}) async {
    _isLoading = true;
    notifyListeners(); // Activa el spinner de carga en tu CustomButton

    try {
      // El servicio devuelve el modelo de respuesta completo (User + Token)
      final AuthResponseModel response = await _authService.login(
        email: email,
        password: password,
      );

      // Guardamos en el estado temporal
      _currentUser = response.user;
      _token = response.token;
      _isGuest = false; // Nos aseguramos de apagar el modo invitado

      // TODO: Aquí implementaremos el guardado en el dispositivo (SecureStorage)
      // await _secureStorage.saveToken(response.token);

    } catch (e) {
      // Relanzamos el error para que el UI muestre el ToastService.error
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners(); // Oculta el spinner de carga
    }
  }

  Future<void> register({
    required String name,
    required String lastname,
    required String email,
    required String phone,
    required String password,
    required bool isBusiness,
  }) async {

    try {

      _isLoading = true;
      notifyListeners();

      await _authService.register(
        name: name,
        lastname: lastname,
        email: email,
        phone: phone,
        password: password,
        isBusiness: isBusiness, 
      );

    } finally {

      _isLoading = false;
      notifyListeners();
    }
  }


  /// Activa el modo anónimo/invitado para explorar la app
  void continueAsGuest() {
    _currentUser = null;
    _token = null;
    _isGuest = true;
    notifyListeners();
  }

  /// Cierra la sesión activa y limpia los datos
  void logout() {
    _currentUser = null;
    _token = null;
    _isGuest = false;
    notifyListeners();
    
    // TODO: Aquí implementaremos el borrado del token local
    // await _secureStorage.deleteToken();
  }

  /// (Opcional) Método para cargar una sesión existente al abrir la App
  Future<void> checkExistingSession() async {
    // TODO: Leer el token de la memoria local y validar con el backend
    // Si es válido, popular _currentUser y notificar.
  }
}