import 'package:quehagosalta/core/api/api_client.dart';

class BussinesServices {
  final ApiClient _apiClient;

  BussinesServices(this._apiClient);

  Future<Map<String, dynamic>> getBussines() async {
    return await _apiClient.get('/bussines/');
  }

  Future<Map<String, dynamic>> completeBusinessProfile({
    required String cuil,
    required String imagePath,
    required List<String> businessImagesPaths,
    required String name,
    required String description,
    required String address,
    required String categoryId,
    required double latitude,
    required double longitude,
    required String token,
  }) async {
    _apiClient.token = token.startsWith('Bearer') ? token : 'Bearer $token';

    return await _apiClient.multipartPut(
      endpoint: '/bussines/complete_profile/',
      imagePath: imagePath,
      fields: {
        'cuil': cuil,
        'name': name,
        'description': description,
        'address': address,
        'category': categoryId,
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
      },
    );
  }
}
