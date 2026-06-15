import 'package:quehagosalta/core/api/api_client.dart';

class BussinesServices {
  final ApiClient _apiClient;

  BussinesServices(this._apiClient);

  Future<Map<String, dynamic>> getBussines() async {
    return await _apiClient.get('/bussines/');
  }

  Future<void> createBusiness({
    required String name,
    required String description,
    required String address,
    required double latitude,
    required double longitude,
  }) async {
    await _apiClient.post('/bussines/create/', {
      'name': name,
      'description': description,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    });
  }
}
