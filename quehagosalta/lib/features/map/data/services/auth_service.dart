import 'package:quehagosalta/core/api/api_client.dart';
import 'package:quehagosalta/core/api/api_config.dart';
import '../models/aut_response_model.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient(baseUrl: ApiConfig.host);

  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post('/auth/login/', {
      'email': email,
      'password': password,
    });

    if (response['success'] == false) {
      // Es buena práctica usar un fallback '??' por si el backend no envía el 'message'
      throw Exception(response['message'] ?? 'Error al iniciar sesión');
    }

    return AuthResponseModel.fromJson(response['data']);
  }

  Future<void> register({
    required String name,
    required String lastname,
    required String email,
    required String password,
    String? phone, //
    required bool isBusiness,
  }) async {
    final response = await _apiClient.post('/auth/register/', {
      'name': name,
      'lastname': lastname,
      'email': email,
      'password': password,
      if (phone != null && phone.isNotEmpty) 'phone': phone,
    });

    if (response['success'] == false) {
      throw Exception(response['message'] ?? 'Error al registrar');
    }
  }
}
