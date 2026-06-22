import 'package:flutter/material.dart';
import 'package:quehagosalta/features/auth/data/services/auth_service.dart';
import 'package:quehagosalta/features/map/data/models/user_model.dart';
import 'package:quehagosalta/features/auth/data/models/aut_response_model.dart';
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
    required String first_name,
    required String last_name,
    required String email,
    required String phone,
    required String password,
    required bool isBusiness,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      final AuthResponseModel response = await _authService.register(
        first_name: first_name,
        last_name: last_name,
        email: email,
        phone: phone,
        password: password,
        isBusiness: isBusiness,
      );

      _currentUser = response.user;
      _token = response.token;
      _isGuest = false;
      notifyListeners();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
    }
  }

  Future<UserModel> updateProfileOnServer({
    required String first_name,
    required String last_name,
    required String phone,
    String? cuil,
  }) async {
    _isLoading = true;
    notifyListeners(); // Prende el spinner de carga en el botón
    try {
      // 1. Invocamos al servicio pasándole el Token de sesión que ya tenemos guardado en el estado
      final updatedUser = await _authService.updateProfile(
        first_name: first_name,
        last_name: last_name,
        phone: phone,
        cuil: cuil,
        token: _token ?? '',
      );
      if (updatedUser.id == 'null' || updatedUser.id.isEmpty) {
        throw Exception("El servidor retornó un usuario inválido.");
      }
      // 2. Usamos el mutador reactivo para actualizar la sesión en Flutter
      updateCurrentUser(updatedUser);

      return updatedUser;
    } catch (e) {
      rethrow; // Relanzamos para que la pantalla lo atrape y muestre un ToastService.error
    } finally {
      _isLoading = false;
      notifyListeners(); // Apaga el spinner de carga
    }
  }

  void updateCurrentUser(UserModel updatedUser) {
    if (updatedUser.id.isEmpty || updatedUser.email.isEmpty) {
      return;
    }
    _currentUser = updatedUser;
    notifyListeners();
  }

  set currentUser(UserModel? user) {
    if (user == null || user.id.isEmpty) {
      throw Exception(
        "¡ALERTA! Alguien está intentando poner un usuario vacío en el Provider",
      );
    }
    _currentUser = user;
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
