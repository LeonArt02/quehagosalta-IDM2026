import 'package:flutter/material.dart';
import 'package:quehagosalta/core/api/api_client.dart';
import 'package:quehagosalta/core/api/api_config.dart';
import 'package:quehagosalta/features/users/data/models/user_model.dart';
import '../models/aut_response_model.dart';

class AuthService {
  final ApiClient _apiClient;

  AuthService(this._apiClient);

  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post('/login/', {
      'email': email,
      'password': password,
    });

    if (response['success'] == false) {
      // Es buena práctica usar un fallback '??' por si el backend no envía el 'message'
      throw Exception(response['message'] ?? 'Error al iniciar sesión');
    }

    return AuthResponseModel.fromJson(response['data']);
  }

  Future<AuthResponseModel> register({
    required String first_name,
    required String last_name,
    required String email,
    required String phone,
    required String password,
    required bool isBusiness,
  }) async {
    final Map<String, dynamic> bodyData = {
      'first_name': first_name,
      'last_name': last_name,
      'email': email,
      'password': password,
      'phone': phone,
      'is_business': isBusiness,
      'notification_token': null,
    };

    final response = await _apiClient.post('/register/', bodyData);

    if (response['success'] == false || response['data'] == null) {
      throw Exception(response['message'] ?? 'Error al registrar el usuario');
    }

    return AuthResponseModel.fromJson(response['data']);
  }

  Future<UserModel> updateProfile({
    required String first_name,
    required String last_name,
    required String phone,
    String? cuil,
    required String token,
  }) async {
    _apiClient.token = token.startsWith('Bearer') ? token : 'Bearer $token';

    final response = await _apiClient.put('/users/update_profile/', {
      'first_name': first_name,
      'last_name': last_name,
      'phone': phone,
      if (cuil != null && cuil.isNotEmpty) 'cuil': cuil,
    });
    final Map<String, dynamic> userData =
        response['data'] as Map<String, dynamic>;
    if (response['success'] == true) {
      return UserModel.fromJson(userData);
    } else {
      throw Exception(response['message'] ?? 'Error al actualizar el perfil');
    }
  }
}
