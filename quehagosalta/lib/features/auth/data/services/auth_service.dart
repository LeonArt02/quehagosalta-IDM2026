import 'package:quehagosalta/core/api/api_client.dart';
import 'package:quehagosalta/core/api/api_config.dart';
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
    required String firstName,
    required String lastName,
    required String email,
    required String
    phone, // 🚀 Corregido: Obligatorio para coincidir con la Screen y el Back
    required String password,
    required bool isBusiness,
  }) async {
    final Map<String, dynamic> bodyData = {
      'firstName': firstName,
      'lastName': lastName,
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
}
